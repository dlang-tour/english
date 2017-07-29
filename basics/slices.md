# Slices

Slices are objects from type `T[]` for any given type `T`.
Slices provide a view on a subset of an array
of `T` values - or just point to the whole array.
**Slices and dynamic arrays are the same.**

A slice consists of two members - a pointer to the starting element and the
length of the slice:

    T* ptr;
    size_t length; // unsigned 32 bit on 32bit, unsigned 64 bit on 64bit

### Getting a slice via new allocation

If a new dynamic array is created, a slice to this freshly
allocated memory is returned:

    auto arr = new int[5];
    assert(arr.length == 5); // memory referenced in arr.ptr

Actual allocated memory in this case is completely managed by the garbage
collector. The returned slice acts as a "view" on underlying elements.

### Getting a slice to existing memory

Using a slicing operator one can also get a slice pointing to some already
existing memory. The slicing operator can be applied to another slice, static
arrays, structs/classes implementing `opSlice` and a few other entities.

In an example expression `origin[start .. end]` the slicing operator is used to get
a slice of all elements of `origin` from `start` to the element _before_ `end`:

    auto newArr = arr[1 .. 4]; // index 4 is NOT included
    assert(newArr.length == 3);
    newArr[0] = 10; // changes newArr[0] aka arr[1]

Such slices generate a new view on existing memory. They *don't* create
a new copy. If no slice holds a reference to that memory anymore - or a *sliced*
part of it - it will be freed by the garbage collector.

Using slices, it's possible to write very efficient code for things (like parsers, for example)
that only operate on one memory block, and slice only the parts they really need
to work on. In this way, there's no need to allocate new memory blocks.

As seen in the [previous section](basics/arrays), the `[$]` expression is a shorthand form for
`arr.length`. Hence `arr[$]` indexes the element one past the slice's end, and
thus would generate a `RangeError` (if bounds-checking hasn't been disabled).

### In-depth

- [Introduction to Slices in D](http://dlang.org/d-array-article.html)
- [Slices in _Programming in D_](http://ddili.org/ders/d.en/slices.html)

## {SourceCode}

```d
import std.stdio : writeln;

void main()
{
    int[] test = [ 3, 9, 11, 7, 2, 76, 90, 6 ];
    test.writeln;
    writeln("First element: ", test[0]);
    writeln("Last element: ", test[$ - 1]);
    writeln("Exclude the first two elements: ",
        test[2 .. $]);

    writeln("Slices are views on the memory:");
    auto test2 = test;
    auto subView = test[3 .. $];
    test[] += 1; // increment each element by 1
    test.writeln;
    test2.writeln;
    subView.writeln;

    // Create an empty slice
    assert(test[2 .. 2].length == 0);
}
```
