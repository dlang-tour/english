# Alias & Strings

Now that we know what arrays are, have gotten in touch with `immutable`,
and had a quick look at the basic types, it's time to introduce two
new constructs in one line:

    alias string = immutable(char)[];

The term `string` is defined by an `alias` statement which defines it
as a slice of `immutable(char)`s. This means, once a `string` has been constructed
its content will never change again. And actually this is the second
introduction: welcome UTF-8 `string`!

Due to their immutablility, `string`s can be shared perfectly among
different threads. As `string` is a slice, parts can be taken out of it without
allocating memory. The standard function
[`std.algorithm.splitter`](https://dlang.org/phobos/std_algorithm_iteration.html#.splitter)
for example, splits a string by newline without any memory allocations.

Besides the UTF-8 `string`, there are two more types:

    alias wstring = immutable(wchar)[]; // UTF-16
    alias dstring = immutable(dchar)[]; // UTF-32

The variants are most easily converted between each other using
the `to` method from `std.conv`:

    dstring myDstring = to!dstring(myString);
    string myString   = to!string(myDstring);

### Unicode strings

This means that a plain `string` is defined as an array of 8-bit Unicode [code
units](http://unicode.org/glossary/#code_unit). All array operations can be
used on strings, but they will work on a code unit level, and not a character level. At
the same time, standard library algorithms will interpret `string`s as sequences
of [code points](http://unicode.org/glossary/#code_point), and there is also an
option to treat them as sequence of
[graphemes](http://unicode.org/glossary/#grapheme) by explicit usage of
[`std.uni.byGrapheme`](https://dlang.org/library/std/uni/by_grapheme.html).

This small example illustrates the difference in interpretation:

    string s = "\u0041\u0308"; // Ä

    writeln(s.length); // 3

    import std.range : walkLength;
    writeln(s.walkLength); // 2

    import std.uni : byGrapheme;
    writeln(s.byGrapheme.walkLength); // 1

Here the actual array length of `s` is 3, because it contains 3 code units:
`0x41`, `0x03` and `0x08`. Those latter two define a single code point
(combining diacritics character) and
[`walkLength`](https://dlang.org/library/std/range/primitives/walk_length.html)
(standard library function to calculate arbitrary range length) counts two code
points total. Finally, `byGrapheme` performs rather expensive calculations
to recognize that these two code points combine into a single displayed
character.

Correct processing of Unicode can be very complicated, but most of the time, D
developers can simply consider `string` variables as magical byte arrays and
rely on standard library algorithms to do the right job.
If by element (code unit) iteration is desired, one can use
[`byCodeUnit`](http://dlang.org/phobos/std_utf.html#.byCodeUnit).

Auto-decoding in D is explained in more details
in the [Unicode gems chapter](gems/unicode).

### Multi-line strings

To create multi-line strings, use the `string str = q{ ... }` syntax.

    string multiline = q{ This
        may be a
        long document
    };

### Raw strings

It is also possible to use raw strings to minimize laborious escaping
of reserved symbols. Raw strings can be declared using either backticks (`` `
... ` ``) or the r(aw)-prefix (`r" ... "`).

    string raw  =  `raw "string"`; // raw "string"
    string raw2 = r"raw `string`"; // raw `string`

### In-depth

- [Unicode gem](gems/unicode)
- [Characters in _Programming in D_](http://ddili.org/ders/d.en/characters.html)
- [Strings in _Programming in D_](http://ddili.org/ders/d.en/strings.html)
- [std.utf](http://dlang.org/phobos/std_utf.html) - UTF en-/decoding algorithms
- [std.uni](http://dlang.org/phobos/std_uni.html) - Unicode algorithms

## {SourceCode}

```d
import std.stdio : writeln, writefln;
import std.range : walkLength;
import std.uni : byGrapheme;
import std.string : format;

void main() {
    // format generates a string using a printf
    // like syntax. D allows native UTF string
    // handling!
    string str = format("%s %s", "Hellö",
        "Wörld");
    writeln("My string: ", str);
    writeln("Array length (code unit count)"
        ~ " of string: ", str.length);
    writeln("Range length (code point count)"
        ~ " of string: ", str.walkLength);
    writeln("Character length (grapheme count)"
        ~ " of string: ",
        str.byGrapheme.walkLength);

    // Strings are just normal arrays, so any
    // operation that works on arrays works here
    // too!
    import std.array : replace;
    writeln(replace(str, "lö", "lo"));
    import std.algorithm : endsWith;
    writefln("Does %s end with 'rld'? %s",
        str, endsWith(str, "rld"));

    import std.conv : to;
    // Convert to UTF-32
    dstring dstr = to!dstring(str);
    // .. which of course looks the same!
    writeln("My dstring: ", dstr);
}
```
