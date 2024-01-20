# opDispatch & opApply

D allows overriding operators like `+`, `-` or
the call operator `()` for
[classes and structs](https://dlang.org/spec/operatoroverloading.html).
We will have a closer look at the two special
operator overloads `opDispatch` and `opApply`.

### opDispatch

`opDispatch` can be defined as a member function of either
`struct` or `class` types. Any unknown member function call
to that type is passed to `opDispatch`,
passing the unknown member function's name as a `string`
template parameter. `opDispatch` is a *catch-all*
member function and allows another level of generic
programming - completely at **compile time**!

    struct C {
        void callA(int i, int j) { ... }
        void callB(string s) { ... }
    }
    struct CallLogger(C) {
        C content;
        void opDispatch(string name, T...)(T vals) {
            writeln("called ", name);
            mixin("content." ~ name)(vals);
        }
    }
    CallLogger!C l;
    l.callA(1, 2);
    l.callB("ABC");

### opApply

An alternative way to implementing a `foreach` traversal
instead of defining a user defined *range* is to implement
an `opApply` member function. Iterating with `foreach`
over such a type will call `opApply` with a special
delegate as a parameter:

    class Tree {
        int val;
        Tree lhs;
        Tree rhs;
        this(int val, Tree lhs = null, Tree rhs = null) {
            this.val = val;
            this.lhs = lhs;
            this.rhs = rhs;
        }
        int opApply(scope int delegate(ref Tree) dg) {
            if (int res = lhs ? lhs.opApply(dg) : 0) return res;
            if (int res = rhs ? rhs.opApply(dg) : 0) return res;
            return dg(this);
        }
    }
    Tree tree = new Tree(5,
                         new Tree(3, new Tree(190)), new Tree(6));
    foreach (node; tree) {
        node.val.writeln;
    }

The compiler transforms the `foreach` body to a special
delegate that is passed to the object. Its one and only
parameter will contain the current
iteration's value. The magic `int` return value
must be interpreted and if it is not `0`, the iteration
must be stopped.

### In-depth

- [Operator overloading in _Programming in D_](http://ddili.org/ders/d.en/operator_overloading.html)
- [`opApply` in _Programming in D_](http://ddili.org/ders/d.en/foreach_opapply.html)
- [Operator overloading in D](https://dlang.org/spec/operatoroverloading.html)

## {SourceCode}

```d
/*
A Variant is something that might contain
any other type:
https://dlang.org/phobos/std_variant.html
*/

import std.variant : Variant;

/*
Type that can be filled with opDispatch
with any number of members. Like
JavaScript's var.
*/
struct var {
    private Variant[string] values;

    @property
    Variant opDispatch(string name)() const {
        return values[name];
    }

    @property
    void opDispatch(string name, T)(T val) {
        values[name] = val;
    }
}

void main() {
    import std.stdio : writeln;

    var test;
    test.foo = "test";
    test.bar = 50;
    writeln("test.foo = ", test.foo);
    writeln("test.bar = ", test.bar);
    test.foobar = 3.1415;
    writeln("test.foobar = ", test.foobar);
    // ERROR because it doesn't exist
    // already
    // writeln("test.notthere = ",
    //   test.notthere);
}
```
