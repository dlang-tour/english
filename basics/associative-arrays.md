# Associative Arrays

D has built-in *associative arrays* also known as hash maps.
An associative array with a key type of `string` and a value type
of `int` is declared as follows:

    int[string] arr;

The value can be accessed by its key and thus be set:

    arr["key1"] = 10;

To test whether a key is located in the associative array, the
`in` expression can be used:

    if ("key1" in arr)
        writeln("Yes");

The `in` expression returns a pointer to the value if it
can be found or a `null` pointer otherwise. Thus existence check
and writes can be conveniently combined:

    if (auto val = "key1" in arr)
        *val = 20;

Access to a key which doesn't exist yields a `RangeError`
that immediately aborts the application. For safe access
with a default value, `get(key, defaultValue)` can be used.

AA's have the `.length` property like arrays and provide
a `.remove(val)` member to remove entries by their key.
It is left as an exercise to the reader to explore
the special `.byKey` and `.byValue` ranges.

### In-depth

- [Associative arrays in _Programming in D_](http://ddili.org/ders/d.en/aa.html)
- [Associative arrays specification](https://dlang.org/spec/hash-map.html)
- [std.array.byPair](http://dlang.org/phobos/std_array.html#.byPair)

## {SourceCode}

```d
import std.array : assocArray;
import std.algorithm.iteration: each, group,
    splitter, sum;
import std.string: toLower;
import std.stdio : writefln, writeln;

void main()
{
    string text = "Rock D with D";

    // Iterate over all words and count
    // each word once
    int[string] words;
    text.toLower()
        .splitter(" ")
        .each!(w => words[w]++);

    foreach (key, value; words)
        writefln("key: %s, value: %d",
                       key, value);

    // `.keys` and `.values` return arrays
    writeln("Words: ", words.keys);

    // `.byKey`, `.byValue` and `.byKeyValue`
    // return lazy, iteratable ranges
    writeln("# Words: ", words.byValue.sum);

    // A new associative array can be created
    // with `assocArray` by passing a
    // range of key/value tuples;
    auto array = ['a', 'a', 'a', 'b', 'b',
                  'c', 'd', 'e', 'e'];

    // `.group` groups consecutively equivalent
    // elements into a single tuple of the
    // element and the number of its repetitions
    auto keyValue = array.group;
    writeln("Key/Value range: ", keyValue);
    writeln("Associative array: ",
             keyValue.assocArray);
}
```
