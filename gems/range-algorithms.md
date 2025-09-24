# Range algorithms

The standard modules [std.range](http://dlang.org/phobos/std_range.html)
and [std.algorithm](http://dlang.org/phobos/std_algorithm.html)
provide many excellent functions that can be
composed together to express complex operations in a still
readable way - using *ranges* as building blocks.

The great thing about these algorithms is that if you
define your own range, you will immediately
be able to use it with the existing functions in the standard
library.

### std.algorithm

`filter` - Given a lambda as the template parameter,
 generate a new range that filters elements:

    filter!(a => a > 20)(range);

`map` - Generate a new range using the predicate
 defined as a template parameter:

    [1, 2, 3].map!(x => to!string(x));

`each` - Poor man's `foreach` as a range crunching
function:

    [1, 2, 3].each!(a => writeln(a));

### std.range

`take` - limit to the first *N* elements:

    aBigBigRange.take(10);

`zip` - iterate over *M* ranges
in parallel returning a succession of *M*-tuples, each with
the next element from each of the ranges:

    assert(zip([1,2], ["hello","world"]).front
      == tuple(1, "hello"));

`generate` - takes a function and creates a range
which in turn calls it on each iteration, for example:

    alias RandomRange = generate!(() => uniform(1, 1000));

`cycle` - returns a range that repeats the given input range
forever.

    auto c = cycle([1]);
    // range will never be empty!
    assert(!c.empty);

### Library Documentation

Visit [std.range](http://dlang.org/phobos/std_range.html)
and [std.algorithm](http://dlang.org/phobos/std_algorithm.html)
for the full list of functions and details of their usage.

### In-depth

- [Ranges in _Programming in D_](http://ddili.org/ders/d.en/ranges.html)
- [More Ranges in _Programming in D_](http://ddili.org/ders/d.en/ranges_more.html)

## {SourceCode}

```d
// Hey come on, just get the whole army!
import std.algorithm : canFind, count, map,
  filter, sort, uniq, joiner, chunkBy, splitter;
import std.array : array, empty;
import std.range : zip;
import std.stdio : writeln;
import std.string : format;

void main()
{
    string text = q{This tour will give you an
overview of this powerful and expressive systems
programming language which compiles directly
to efficient, *native* machine code.};

    // splitting predicate
    alias pred = c => canFind(" ,.\n", c);
    // as a good algorithm it just works
    // lazily without allocating memory!
    auto words = text.splitter!pred
      .filter!(a => !a.empty);

    auto wordCharCounts = words
      .map!(a => a.count);

    // Output the character count
    // per word in a nice way
    // beginning with least chars!
    zip(wordCharCounts, words)
      // convert to array for sorting
      .array()
      .sort()
      // we don't need duplication, right?
      .uniq()
      // put all in one row that have the
      // same char count. chunkBy helps
      // us here by generating ranges
      // of range that are chunked by the length
      .chunkBy!(a => a[0])
      // those elments will be joined
      // on one line
      .map!(chunk => format("%d -> %s",
          chunk[0],
          // just the words
          chunk[1]
            .map!(a => a[1])
            .joiner(", ")))
      // joiner joins, but lazily!
      // and now the lines with the line
      // feed
      .joiner("\n")
      // pipe to stdout
      .writeln();
}
```
