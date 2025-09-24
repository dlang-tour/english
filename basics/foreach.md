# Foreach

{{#img-right}}dman-teacher-foreach.jpg{{/img-right}}

D provides a `foreach` loop for easy-to-use
and more readable iteration.

### Element iteration

Given an array `arr` of type `int[]` it is possible to
iterate over each element in turn using a `foreach` loop:

    foreach (int e; arr) {
        writeln(e);
    }

The first parameter in a `foreach` loop is the variable
name used for each iteration's item. Its type can be inferred automatically, for example:

    foreach (e; arr) {
        // typeof(e) is int
        writeln(e);
    }

The second field must be an array - or a special iterable
object called a **range** which will be introduced in the [next section](basics/ranges).

### Access by reference

Elements will be copied from the array or range during iteration.
This is acceptable for basic types, but might be expensive for
large types. To prevent copying or to enable *in-place*
mutation, `ref` can be used:

    foreach (ref e; arr) {
        e = 10; // overwrite value
    }

### Iterate `n` times

D allows us to iterate a specific number of times using
the `..` syntax:

    foreach (i; 0 .. 3) {
        writeln(i);
    }
    // 0 1 2

D's `..` ranges go from the first (start) number up to
one _before_ the second (end) number. So, in this case,
`i` will be `0`, then `1`, then `2`, with the loop body
executing exactly `3` times.

### Iteration with index counter

For arrays, it's also possible to access a separate index variable
(which always counts from `0`).

    foreach (i, e; [4, 5, 6]) {
        writeln(i, ":", e);
    }
    // 0:4 1:5 2:6

### Reverse iteration with `foreach_reverse`

A collection can be iterated in reverse order with
`foreach_reverse`:

    foreach_reverse (e; [1, 2, 3]) {
        writeln(e);
    }
    // 3 2 1

### In-depth

- [`foreach` in _Programming in D_](http://ddili.org/ders/d.en/foreach.html)
- [`foreach` with Structs and Classes  _Programming in D_](http://ddili.org/ders/d.en/foreach_opapply.html)
- [`foreach` specification](https://dlang.org/spec/statement.html#ForeachStatement)

## {SourceCode}

```d
import std.stdio : writefln;

void main() {
    auto arr = [
        [5, 15],      // 20
        [2, 3, 2, 3], // 10
        [3, 6, 2, 9], // 20
    ];

    foreach (i, row; arr)
    {
        double total = 0.0;
        foreach (e; row)
            total += e;

        auto avg = total / row.length;
        writefln("AVG [row=%d]: %.2f", i, avg);
    }
}
```
