# Unicode in D

Unicode is a global standard for encoding and representing text
in computers. D fully supports Unicode in both the language and
the standard library.

## What and Why

Computers, at the lowest level, have no notion of what text is,
as they only deal with numbers. As a result, computer code needs
a way to take text data and transform it to and from a binary
representation. The method of transformation is called an
*encoding scheme*, and Unicode is one such scheme.

To see the numerical representations underlying the strings in
the example, simply run the code.

Unicode is unique in that its design allows it to represent all
the languages of the world using the same encoding scheme. Before
Unicode, computers made by different companies or shipped in
different areas had a hard time communicating, and in some cases
an encoding scheme wasn't supported at all, making viewing the text
on that computer impossible.

For more info on Unicode and the technical details, check the
Wikipedia article on Unicode in the "In-Depth" section.

## How

Unicode has fixed most of those problems and is supported on every
modern machine. D learns from the mistakes of older languages,
as such **all** strings in D are Unicode strings, whereas strings
in languages such as C and C++ are just arrays of bytes.

In D, `string`, `wstring`, and `dstring` are UTF-8, UTF-16, and
UTF-32 encoded strings respectively. Their character types are
`char`, `wchar`, and `dchar`.

According to the spec, it is an error to store non-Unicode
data in the D string types; expect your program to fail in
different ways if your string is encoded improperly.

In order to store other string encodings, or to obtain C/C++
behavior, you can use `ubyte[]` or `char*`.

## Strings in Range Algorithms

*Reading the [gem on range algorithms](gems/range-algorithms) is
suggested for this section.*

There are some important caveats to keep in mind with Unicode
in D.

First, as a convenience feature, when iterating over a string
using the range functions, Phobos will encode the elements of
`string`s and `wstrings` into UTF-32 code-points as each item.
This practice, known as **auto decoding**, means that

```
static assert(is(typeof(utf8.front) == dchar));
```

This behavior has a lot of implications, the main one that
confuses most people is that `std.traits.hasLength!(string)`
equals `False`. Why? Because, in terms of the range API,
`string`'s `length` returns **the number of elements in the string**,
rather than the number of elements the *range function will iterate over*.

From the example, you can see why these two things might not always
be equal. As such, range algorithms in Phobos act as if `string`s
do not have length information.

For more information on the technical details of auto decoding,
and what it means for your program, check the links in the
"In-Depth" section.

### In-Depth

- [Unicode on Wikipedia](https://en.wikipedia.org/wiki/Unicode)
- [Basic Unicode Functions in Phobos](https://dlang.org/phobos/std_uni.html)
- [Tools for Decoding and Encoding UTF in Phobos](https://dlang.org/phobos/std_utf.html)
- [An in Depth Look at Auto Decoding](https://jackstouffer.com/blog/d_auto_decoding_and_you.html)
- [An in Depth Essay on Benefits of Using UTF-8](http://utf8everywhere.org/)

## {SourceCode}

```d
import std.range.primitives : empty,
    front, popFront;
import std.stdio : write, writeln;

void main()
{
    string utf8 = "å ø ∑ 😦";
    wstring utf16 = "å ø ∑ 😦";
    dstring utf32 = "å ø ∑ 😦";

    writeln("utf8 length: ", utf8.length);
    writeln("utf16 length: ", utf16.length);
    writeln("utf32 length: ", utf32.length);

    foreach (item; utf8)
    {
        auto c = cast(ubyte) item;
        write(c, " ");
    }
    writeln();

    // Because the specified the element type is
    // dchar, look-ahead is used to encode the
    // string to UTF-32 code points.
    // For non-strings, a simple cast is used
    foreach (dchar item; utf16)
    {
        auto c = cast(ushort) item;
        write(c, " ");
    }
    writeln();

    // a result of auto-decoding
    static assert(
        is(typeof(utf8[0]) == immutable(char))
    );
    static assert(
        is(typeof(utf8.front) == dchar)
    );
}
```
