# Functional programming

D puts an emphasis on *functional programming* and provides
first-class support for development
in a functional style. See:
* [immutable](basics/type-qualifiers) type qualifier
* [anonymous functions](basics/delegates#anonymous-functions-lambdas)
* [range algorithms](gems/range-algorithms)

## Pure functions

In D a function can be declared as `pure`, which implies
that given the same input parameters, the **same** output
is always generated. `pure` functions cannot access or change
any mutable global state and are thus just allowed to call other
functions which are `pure` themselves.

    int add(int lhs, int rhs) pure {
        impureFunction(); // ERROR: unable to call impureFunction here
        return lhs + rhs;
    }

This variant of `add` is called a **strongly pure function**
because it returns a result dependent only on its input
parameters without modifying them. D also allows the
definition of **weakly pure functions** which might
have mutable parameters:

    void add(ref int result, int lhs, int rhs) pure {
        result = lhs + rhs;
    }

These functions are still considered pure and can't
access or change any mutable global state. Only passed-in
mutable parameters can be altered. A strongly pure
function can call a weakly pure function, because only
temporary state is changed:

```d
int add(int lhs, int rhs) pure {
    int result;
    add(result, lhs, rhs);
    return result;
}
```

Pure functions can allocate memory, and [the result can
be implicitly converted](https://dlang.org/spec/function.html#pure-factory-functions)
to other type qualifiers. For example, when the result is
a pointer to mutable data, it can convert to `immutable`.
This is because there are no mutable references to the
result remaining after the call.

```d
int* heap(int v) pure => new int(v);

immutable int* p = heap(42);
```

Due to the constraints imposed by `pure`, pure functions
are ideal for multi-threading environments to prevent
data races *by design*. Additionally pure functions
can be cached easily and allow a range of compiler
optimizations.

The `pure` attribute is automatically inferred
by the compiler for templated, nested or literal functions and `auto` functions,
where applicable (this is also true for `@safe`, `nothrow`,
and `@nogc`).

### In-depth

- [Functional DLang Garden](https://garden.dlang.io/)

## {SourceCode}

```d
import std.bigint : BigInt;

/**
 * Computes the power of a base
 * with an exponent.
 *
 * Returns:
 *     Result of the power as an
 *     arbitrary-sized integer
 */
BigInt bigPow(uint base, uint power) pure
{
    BigInt result = 1;

    foreach (_; 0 .. power)
        result *= base;

    return result;
}

void main()
{
    import std.datetime.stopwatch : benchmark;
    import std.functional : memoize,
        reverseArgs;
    import std.stdio : writefln, writeln;

    // memoize caches the result of the function
    // call depending on the input parameters.
    // pure functions are great for that!
    alias fastBigPow = memoize!(bigPow);

    void test()
    {
        writefln(".uintLength() = %s ",
               fastBigPow(5, 10000).uintLength);
    }

    foreach (_; 0 .. 10)
        ( benchmark!test(1)[0]
            .total!"usecs"/1000.0 )
            .reverseArgs!writefln
                (" took: %.2f miliseconds");
}
```
