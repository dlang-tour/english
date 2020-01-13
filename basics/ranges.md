# Ranges

If a `foreach` is encountered by the compiler

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

Any object which fulfills the following interface is called a **range**
(or more specific `InputRange`) and is thus a type that can be iterated over:

```
    interface InputRange(E)
    {
        bool empty();
        E front();
        void popFront();
    }
```

Have a look at the example on the right to inspect the implementation and usage
of an input range closer.

## Laziness

Ranges are __lazy__. They won't be evaluated until requested.
Hence, a range from an infinite range can be taken:

```d
42.repeat.take(3).writeln; // [42, 42, 42]
```

## Value vs. Reference types

If the range object is a value type, then range will be copied and only the copy
will be consumed:

```d
auto r = 5.iota;
r.drop(5).writeln; // []
r.writeln; // [0, 1, 2, 3, 4]
```

If the range object is a reference type (e.g. `class` or [`std.range.refRange`](https://dlang.org/phobos/std_range.html#refRange)),
then the range will be consumed and won't be reset:

```d
auto r = 5.iota;
auto r2 = refRange(&r);
r2.drop(5).writeln; // []
r2.writeln; // []
```

### Copyable `InputRanges` are `ForwardRanges`

Most of the ranges in the standard library are structs and so `foreach`
iteration is usually non-destructive, though not guaranteed. If this
guarantee is important, a specialization of an `InputRange` can be used—
**forward** ranges with a `.save` method:

```
interface ForwardRange(E) : InputRange!E
{
    typeof(this) save();
}
```

```d
// by value (Structs)
auto r = 5.iota;
auto r2 = refRange(&r);
r2.save.drop(5).writeln; // []
r2.writeln; // [0, 1, 2, 3, 4]
```

### `ForwardRanges` can be extended to Bidirectional ranges + random access ranges

There are two extensions of the copyable `ForwardRange`: (1) a bidirectional range
and (2) a random access range.
A bidirectional range allows iteration from the back:

```d
interface BidirectionalRange(E) : ForwardRange!E
{
     E back();
     void popBack();
}
```

```d
5.iota.retro.writeln; // [4, 3, 2, 1, 0]
```

A random access range has a known `length` and each element can be directly accessed.

```d
interface RandomAccessRange(E) : ForwardRange!E
{
     E opIndex(size_t i);
     size_t length();
}
```

The best known random access range is D's array:

```d
auto r = [4, 5, 6];
r[1].writeln; // 5
```

### Lazy range algorithms

The functions in [`std.range`](http://dlang.org/phobos/std_range.html) and
[`std.algorithm`](http://dlang.org/phobos/std_algorithm.html) provide
building blocks that make use of this interface. Ranges enable the
composition of complex algorithms behind an object that
can be iterated with ease. Furthermore, ranges enable the creation of **lazy**
objects that only perform a calculation when it's really needed
in an iteration e.g. when the next range's element is accessed.
Special range algorithms will be presented later in the
[D's Gems](gems/range-algorithms) section.

### In-depth

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
