# Multidimensional arrays with mir-algorithm

[`mir-algorithm`](https://github.com/libmir/mir-algorithm) provides support
for multidimensional arrays.
It allows fast iteration, access and manipulation of multidimensional
data. In comparison to popular software packages in other languages (e.g. `ndarray`
in NumPy), it doesn't become slow for computations not
covered by preexisting functionality in a bound C-library nor forces the user
to escape into another language. Additionally, due to its compile-time introspection
capabilities, D enables further optimizations for superior performance.

## Slices

A `Slice` is a view on a multidimensional view on usually an underlying raw,
one-dimensional array. With the `sliced` function a multidimensional array can
be constructed - in this example a `2x3` matrix is created:

```d
import mir.algorithm;
auto arr = new double[6];       // allocate one-dimensional array
auto matrix = arr.sliced(2, 3); // construct view onto array
```

As the two part process of 1) allocating an array of the right size and 2) slicing it can get a bit tedious,
the `ndslice` package provides a shorthand that does the whole trick in one go:

```d
import mir.algorithm;
auto arr = new double[6];       // allocate one-dimensional array
auto matrix = slice!int(2, 3);
```

### Row/column styles

For the more common row-major index-style (C, D) square brackets can be used `a[]`,
whereas the column-major index style (Matlab, Fortran) uses parenthesis `a()`.
A row or column is also a `Slice` and thus all operations that work on slices
work on selections, for example we can assign a value or values.

```d
import mir.algorithm;
// [0, 1, 2]
// [3, 4, 5]
// [6, 7, 8]
auto matrix = iotaSlice(3, 3).slice; // `slice` allocates from the iotaSlice
matrix[1, 0] = 42; // column-major, has value `3` before
matrix(1, 0) = 42; // row-major,    has value `1` before
```

### Selections

[`ndslice`](http://docs.algorithm.dlang.io/latest/mir_ndslice.html) provides many
selection views.
A simple example is `diagonal`, which select the diagonal of a matrix.
A more complex operation is `pack`, which creates a slice of slices.

A packed slice doesn't cost any overhead and can be reversed with `unpack`.

## More features

Unfortunately is a sole section not enough to cover all the features of `ndslice`.
There are many [iteration methods](http://dlang.org/phobos/std_experimental_ndslice_iteration.html)
like [matrix transposition](http://dlang.org/phobos/std_experimental_ndslice_iteration.html#.transposed),
[rotation](http://dlang.org/phobos/std_experimental_ndslice_iteration.html#.rotated)
and many more. Moreover all routines (except `slice`) don't allocate and
thus can be used in `@nogc` code.

## In-depth

- [mir-algorithm](http://docs.algorithm.dlang.io/latest)

## {SourceCode}

```d
/+dub.sdl:
name "foo"
dependency "mir-algorithm" version="0.6.14"
+/
import std.algorithm.comparison : equal;
import mir.algorithm;
import std.range : iota;
import std.stdio : writeln;

void main()
{
    auto matrix = [
		0,  1,  2,
    	3,  4,  5,
    	6,  7,  8,
    	9, 10, 11,
	].sliced(4, 3);

	//
	writeln(matrix);

    assert(matrix.diagonal == [0, 4, 8]);
    // it's just a pointer
    matrix.diagonal[1] = 42;
    assert(matrix[1, 1] == 42);

    // change the shape
    // [ 0, 1,  2,  3]
    // [42, 5,  6,  7]
    // [ 8, 9, 10, 11]
    assert(matrix.reshape(3, 4)[1, 0] == 42);

    // flatten
    assert(matrix.byElement[2..5]
                  .equal([2, 3, 42]));

    // windowing
    // [
    //	 [0, 1]
    //   [1, 2]
	  // ], [
    //	 [3, 42]
    // 	 [42, 5]
	  // ], [
    // ...
	assert(matrix
		.windows(1, 2)[1, 0]
		.byElement
		.equal([3, 42]));
}
```
