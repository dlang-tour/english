# Metaprogramming in D, Part 1

## AliasSeq!(T) compile time sequences

`AliasSeq!(T)` is implemented in the `std.meta` library of Phobos; it allows us to create compile time sequences of types and data. Its implementation is simple:

    alias AliasSeq(T...) = T;

The `Nothing` template is also defined in the same module:

    alias Nothing = AliasSeq!();

We can create a compile time sequence like this:

    alias tSeq = AliasSeq!(ushort, short, uint, int, ulong, long);
    pragma(msg, "Type sequence: ", tSeq);

output:

    Type sequence: (ushort, short, uint, int, ulong, long)

### Append, prepend and concatenating compile time lists

`AliasSeq(T...)` type sequences are not a traditional "container"; when they are input into templates they "spread out", or expand and become like separate arguments of a function, as if they were not contained but input individually. One consequence is that there is no need to define operations for Append, Prepend, and Concatenate because they is already implied in the definition. The following examples show this applied.

#### Append

Here, we append `string` to the end of our type sequence:

    alias appended = AliasSeq!(tSeq, string);
    pragma(msg, appended);


output:

    Append: (ushort, short, uint, int, ulong, long, string)


#### Prepend

Here, we prepend  `string` to the front of our type sequence:

    alias appended = AliasSeq!(string, tSeq);
    pragma(msg, "Append: ", appended);


Output:

    Prepend: (string, ushort, short, uint, int, ulong, long)

#### Concatenate

Here, we concatenate `AliasSeq!(ubyte, byte)` with our original type sequence:

    alias bytes = AliasSeq!(ubyte, byte);
    alias concat = AliasSeq!(bytes, tSeq);
    pragma(msg, "Concatenate: ", concat);

Output:

    Concatenate: (ubyte, byte, ushort, short, uint, int, ulong, long)

## Replacing items in compile time sequences

We can manipulate compile time sequences, and some *functional* modes of manipulation are given in the [std.meta](https://dlang.org/phobos/std_meta.html) module. Below, a template expression is implemented that allows us to replace an item in a compile time sequence `T...`, with a type `S`:

    template Replace(size_t idx, S, Args...)
    {
      static if (Args.length > 0 && idx < Args.length)
        alias Replace = AliasSeq!(Args[0 .. idx], S, Args[idx + 1 .. $]);
      else
        static assert(0);
    }

## Replacing multiple items with an individual type

### String mixins

String mixins allow us to create runtime and compile time code by concatenating strings together like C macros.


The code below implements a `Replace` template specialization. It uses mixins to create compile time code "on the fly". These commands facilitate multiple replacements at locations in `Args` given by the sequence `indices`:

    import std.conv: text;
    template Replace(alias indices, S, Args...)
    if(Args.length > 0)
    {
      enum N = indices.length;
      static foreach(i; 0..N)
      {
        static if(i == 0)
        {
          mixin(text(`alias x`, i, ` = Replace!(indices[i], S, Args);`));
        }else{
          mixin(text(`alias x`, i, ` = Replace!(indices[i], S, x`, (i - 1), `);`));
        }
      }
      mixin(text(`alias Replace = x`, N - 1, `;`));
    }

### static foreach

In the static foreach loop example above, the variables at each iteration are **not** scoped, because we use single curly braces `{` `}`. This means that all the variables we generate, `x0..x(N-1)` are all available outside these braces at the last line, where we assign the last variable created to `Replace`, to be "returned". To scope variables created in a `static foreach` loops, we use double curly braces `{{` `}}` like this:

    static foreach(i; 0..N)
    {{
      /* ... code here ... */
    }}

## Replacing multiple items by a tuple of items

### Contained type sequences

We have already seen that there if we pass more than one `AliasSeq!(T)` sequence as template parameters, the template expands and we can not recover which items were in which parameter. To remedy this, we can build a tuple type as a container for types. For more information see <a href="https://dlang.org/phobos/std_typecons.html" target="_blank">std.typecons</a> which contains tools for interacting with tuples:

    struct Tuple(T...)
    {
      enum ulong length = T.length;
      alias get(ulong i) = T[i];
      alias getTypes = T;
    }

We are now ready for a template specialization that replaces multiple items in `AliasSeq` by the types in a tuple:

    template Replace(alias indices, S, Args...)
    if((Args.length > 0) && isTuple!(S) && (indices.length == S.length))
    {
      enum N = indices.length;
      static foreach(i; 0..N)
      {
        static if(i == 0)
        {
          mixin(text(`alias x`, i, ` = Replace!(indices[i], S.get!(i), Args);`));
        }else{
          mixin(text(`alias x`, i, 
                 ` = Replace!(indices[i], S.get!(i), x`, (i - 1), `);`));
        }
      }
      mixin(text(`alias Replace = x`, N - 1, `;`));
    }

Usage:

    alias replace6 = Replace!([0, 2, 4], Tuple!(long, ulong, real), tSeq);
    pragma(msg, "([0, 2, 4]) => (long, ulong, real): ", replace6);


Output:

    ([0, 2, 4]) => (long, ulong, real): (long, short, ulong, int, real, long)

## {SourceCode}
```d
import std.conv: to;
import std.stdio: writeln;

struct Tuple(T...)
{
  enum length = T.length;
  alias data = T;
  auto opIndex()(long i)
  {
    return data[i];
  }
}

void main()
{
  alias tup = Tuple!(2020, "August", "Friday", 28).data;
  writeln(tup[2] ~ ", " ~ to!(string)(tup[3]) ~ ", " ~ tup[1] ~ 
                  " " ~ to!(string)(tup[0]));
}
```
