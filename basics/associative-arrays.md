# Associative Arrays

D has built-in *associative arrays* also known as hash maps or dictionaries.
D's documentation often abbreviates *associative array* as _AA_.

An associative array with a key type of `string` and a value type
of `int` is declared as follows:

    int[string] arr;

This can be thought of as an associative array of `int` values, each
accessed by a `string` key.

It is perfectly possible to use different key and value types,
e.g., `double[string]` could be used to hold `double`'s
accessed by `string` names, or `int[int]` to create some kind
of index table that uses one `int` to find another.

The value can be accessed by its key and thus be set:

    arr["key1"] = 10; // insert or update
    auto value = arr["key1"]; // get: value == 10
    
In the first statement above, if `"key1"` is _not_ in the associative
array, it will be inserted with a value of `10`. Otherwise, it will
have its value replaced with `10`.

To test whether a key is contained in an associative array, use an
`in` expression:

    if ("key1" in arr)
        writeln("Yes");

The `in` expression returns a pointer to the value corresponding
to the key - or a `null` pointer if the key isn't in the
associative array. This makes it possible to combine an existence
check with an update:

    if (auto val = "key1" in arr)
        *val = 20;

Attempting to access a key which doesn't exist yields a `RangeError`
that immediately aborts the application. For safe access
with a default value, `get(key, defaultValue)` can be used.

Associative array's have a `.length` property that returns how many
key-value items it has. Associative arrays also provide
a `.remove(key)` member to remove entries by their key.
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
