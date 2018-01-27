# Subtyping

`struct` can't inherit from other `struct`s. But
for those poor `struct`s D provides another great
means to extend their functionality: **subtyping**.

A struct type can define one of its members as
`alias this`:

    struct SafeInt {
        private int theInt;
        alias theInt this;
    }

Any function or operation on `SafeInt` that can't
be handled by the type itself will be forwarded
to the `alias this`ed member. From the outside
`SafeInt` then looks like a normal integer.

This allows extending other types
with new functionality but with zero overhead
in terms of memory or runtime. The compiler
makes sure to do the right thing when
accessing the `alias this` member.

`alias this` work with classes too.

## {SourceCode}

```d
import std.stdio : writeln;

struct Point
{
    private double[2] p;
    // p is used by the compiler
    // to lookup unknown symbols
    alias p this;

    double dot(Point rhs)
    {
        return p[0] * rhs.p[0]
             + p[1] * rhs.p[1];
    }
}
void main()
{
    Point p1, p2;
    // We're basically accessing a double[2]
    p1 = [2, 1], p2 = [1, 1];
    assert(p1[$ - 1] == 1);

    // but with extended functionality
    writeln("p1 dot p2 = ", p1.dot(p2));
}
```
