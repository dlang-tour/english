# Mutability

D is a statically typed language: once a variable has been declared,
its type can't be changed from that point onwards. This allows
the compiler to prevent bugs early and enforce restrictions
at compile time. Good type-safety provides the support one needs
to make large programs safer and more maintainable.

There are several type qualifiers in D but the most commonly used ones are
`const` and `immutable`.

### `immutable`

In addition to a static type system, D provides type qualifiers (sometimes also
called "type constructors") that enforce additional constraints on certain
objects. For example an `immutable` object can only be initialized once and
after that isn't allowed to change.

    immutable int err = 5;
    // or: immutable err = 5 and int is inferred.
    err = 5; // won't compile

`immutable` objects can thus be safely shared among different threads with no
synchronization because they never change by definition. This also implies that
`immutable` objects can be cached perfectly.

### `const`

`const` objects can't be modified, too. This restriction is just valid for the
current scope. A `const` pointer can be created from either a *mutable* or
`immutable` object. This means that the object is `const` for your current
scope, but someone else might modify it from a different context. It is common
for APIs to accept `const` arguments to ensure they don't modify the input as
that allows the same function to process both mutable and immutable data.

    void foo(const char[] s)
    {
        // if not commented out, next line will
        // result in error (can't modify const):
        // s[0] = 'x';

        import std.stdio : writeln;
        writeln(s);
    }

    // thanks to `const`, both calls will compile:
    foo("abcd"); // string is an immutable array
    foo("abcd".dup); // .dup returns a mutable copy

Both `immutable` and `const` are _transitive_ type qualifiers, which ensures that once
`const` is applied to a type, it applies recursively to every sub-component of that type.

### In-depth

#### Basic references

- [Immutable in _Programming in D_](http://ddili.org/ders/d.en/const_and_immutable.html)
- [Scopes in _Programming in D_](http://ddili.org/ders/d.en/name_space.html)

#### Advanced references

- [const(FAQ)](https://dlang.org/const-faq.html)
- [Type qualifiers in D](https://dlang.org/spec/const3.html)

## {SourceCode}

```d
import std.stdio : writeln;

void main()
{
    /**
    * Variables are mutable by default and
    * editing them is allowed:
    */
    int m = 100; // mutable
    writeln("m: ", typeof(m).stringof);
    m = 10; // fine

    /**
    * Pointing to mutable memory:
    */
    // A const pointer to mutable memory is
    // allowed
    const int* cm = &m;
    writeln("cm: ", typeof(cm).stringof);
    // By defintion `const` can't be modified:
    // *cm = 100; // error!

    // As `immutable` is guaranteed to stay
    // unchanged, it can't point to
    // mutable memory
    // immutable int* im = &m; // error!

    /**
    * Pointing to readonly memory:
    */
    immutable v = 100;
    writeln("v: ", typeof(v).stringof);
    // v = 5; // error!

    // `const` may point to readonly memory,
    // but it is readonly as well
    const int* cv = &v;
    writeln("*cv: ", typeof(cv).stringof);
    // *cv = 10; // error!
}
```
