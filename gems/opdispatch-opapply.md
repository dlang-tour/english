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

An alternative way to implement a `foreach` traversal
instead of using a user-defined *range* is to implement
an `opApply` member function. Iterating with `foreach`
over such a type will call `opApply` with a special
delegate as a parameter:

    struct S {
        int[] arr;
        int opApply(int delegate(int) dg) {
            foreach (e; arr) {
                auto r = dg(e);
                if (r)
                    return r;
            }
            return 0;
        }
    }
    foreach (i; S([2, 3, 4])) {
        ...
    }

The compiler transforms the `foreach` body to a special
delegate that is passed to the object. Its one and only
parameter will contain the current
iteration's value. The delegate's magic `int` result
must be returned if it is not `0`, allowing `foreach`
iteration to stop.

### In-depth

- [Operator overloading in _Programming in D_](http://ddili.org/ders/d.en/operator_overloading.html)
- [`opApply` in _Programming in D_](http://ddili.org/ders/d.en/foreach_opapply.html)
- [Operator overloading spec](https://dlang.org/spec/operatoroverloading.html)
- [`opApply` spec](https://dlang.org/spec/statement.html#foreach_over_struct_and_classes)

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
