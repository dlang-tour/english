# Ranges

A range produces a series of elements (values) of the same type.

If a [`foreach` statement](basics/foreach) is encountered by the compiler
with an expression recognised as a *range*:

```
foreach (element; range)
{
    // Loop body...
}
```

it's internally rewritten similar to the following:

```
for (auto __rangeCopy = range;
     !__rangeCopy.empty;
     __rangeCopy.popFront())
{
    auto element = __rangeCopy.front;
    // Loop body...
}
```

The remainder of range behaviour is defined in the standard library.

## Range primitives

Any type which supports the following primitives is called an *input range*
and is thus a type that can be iterated over:

```
bool empty();
E front();
void popFront();
```

`E` is the element type of the range.

A [dynamic array](basics/arrays) can be a range by importing
[`std.range.primitives`](http://dlang.org/phobos/std_range_primitives.html).
This module defines range primitives on arrays, which can be called by
[UFCS](gems/uniform-function-call-syntax-ufcs):

```
import std.range;

int[] a = [1, 2, 3];
assert(!a.empty);
assert(a.front == 1);
a.popFront();
assert(a == [2, 3]);
```

Have a look at the example on the right to inspect the implementation and usage
of a custom input range.

Algorithms can be written generically to work with any range,
regardless of how the primitives are implemented.

## Laziness

Ranges are __lazy__. They won't be evaluated until requested.
Hence, a range can produce infinite elements.

Below a range is returned from `repeat`, which produces infinite
elements, each the same as its initial argument. That range is
processed by `take`, which will select the first N elements.
Range functions are often called in a 'pipeline' style using
[UFCS](gems/uniform-function-call-syntax-ufcs) chains:

```d
import std.range;

42.repeat.take(3).writeln; // [42, 42, 42]
```

## Value vs. reference semantics

If the range object has value semantics (e.g [structs](basics/structs)
without reference type fields), then the range will be
copied when passing it as a value parameter to a function, and only the copy
will be consumed.

Below `iota` produces a struct instance, and `drop` accepts it by value:

```d
import std.range;

auto r = 5.iota;
r.drop(5).writeln; // []
r.writeln; // [0, 1, 2, 3, 4]
```

If the range object has reference semantics (e.g. a [`class`](basics/classes)
or [`std.range.refRange`](https://dlang.org/phobos/std_range.html#refRange)),
then the source range will also be consumed:

```d
auto r = 5.iota;
auto r2 = refRange(&r);
r2.drop(5).writeln; // []
r.writeln; // []
```

A dynamic array has reference semantics for its element values, but value
semantics for its length and starting address.

## Forward ranges

A forward range is an input range which can copy its iteration state.

Most of the ranges in the standard library are structs and so `foreach`
iteration is usually non-destructive, though that is not guaranteed. If this
guarantee is important, a specialization of an input range can be used —
**forward** ranges with a `.save` method:

```
typeof(this) save();
```

Calling `save` makes an independent copy of the range's iteration state:

```d
// by value (Structs)
auto r = 5.iota;
auto r2 = refRange(&r);
r2.save.drop(5).writeln; // []
r2.writeln; // [0, 1, 2, 3, 4]
```

`r2.save` is a copy of `r2`, so dropping elements from the copy does not shorten
`r2`.

## Bidirectional ranges

A bidirectional range extends a forward range, allowing iteration from the back:

```d
E back();
void popBack();
```

`E` is the element type of the range. Below `iota` produces a bidirectional range.
[`std.range.retro`](https://dlang.org/phobos/std_range.html#retro) iterates that
range backwards:

```d
5.iota.retro.writeln; // [4, 3, 2, 1, 0]
```

## Random access ranges

A random access range extends a bidirectional range.
It has a known `length` and each element can be directly accessed:

```d
E opIndex(size_t i);
size_t length();
```

The best known random access range is D's array (which has built-in indexing):

```d
auto r = [4, 5, 6];
r[1].writeln; // 5
```

## Lazy range algorithms

The functions in [`std.range`](http://dlang.org/phobos/std_range.html) and
[`std.algorithm`](http://dlang.org/phobos/std_algorithm.html) provide
building blocks that make use of this interface. Ranges enable the
composition of complex algorithms behind an object that
can be iterated with ease. Furthermore, ranges enable the creation of **lazy**
objects that only perform a calculation when it's really needed
in an iteration e.g. when the next range's element is accessed.
Special range algorithms will be presented later in the
[D's Gems](gems/range-algorithms) section.

## In-depth

- [`std.algorithm`](http://dlang.org/phobos/std_algorithm.html)
- [`std.range`](http://dlang.org/phobos/std_range.html)

## {SourceCode}

```d
import std.stdio : writeln;

struct FibonacciRange
{
    // States of the Fibonacci generator
    int a = 1, b = 1;

    // The fibonacci range never ends
    enum empty = false;

    // Peek at the first element
    int front() const @property
    {
        return a;
    }

    // Remove the first element
    void popFront()
    {
        auto t = a;
        a = b;
        b = t + b;
    }
}

void main()
{
    FibonacciRange fib;

    import std.range : drop, take;
    import std.algorithm.iteration :
        filter, sum;

    // Select the first 10 fibonacci numbers
    auto fib10 = fib.take(10);
    writeln("Fib 10: ", fib10);

    // Except the first five
    auto fib5 = fib10.drop(5);
    writeln("Fib 5: ", fib5);

    // Select the even subset
    auto even = fib5.filter!(x => x % 2 == 0);
    writeln("FibEven : ", even);

    // Sum of all elements
    writeln("Sum of FibEven: ", even.sum);

    // Usually this is summarized as:
    fib.take(10)
         .drop(5)
         .filter!(x => x % 2 == 0)
         .sum
         .writeln;
}
```
