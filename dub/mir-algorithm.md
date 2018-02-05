# Mir Algorithm

Dlang core library for math, finance and a home for Dlang multidimensional array package - ndslice.

## Links

 - [API Documentation](http://docs.algorithm.dlang.io)
 - [GitHub](https://github.com/libmir/mir-algorithm)
 - [Lubeck](https://github.com/kaleidicassociates/lubeck) - Linear Algebra Library based on NDSlice API.

## See Also

[Magic Square on Wikipedia](https://en.wikipedia.org/wiki/Magic_square).

## {SourceCode}

```d
/+dub.sdl:
dependency "mir-algorithm" version="~>0.7"
+/
import mir.math.sum;
// Most of the API works for n-dimensional
// case too.
import mir.ndslice: magic, byDim, map, as, each,
    repeat, diagonal, reversed, slice;

import std.stdio: writefln;

void main()
{
    auto n = 3;

    auto matrix = n
        // creates lazy Magic Square,
        .magic
        // Converts elements type to double
        // precision FP numbers
        .as!double
        // allocates data to a mutable ndslice
        .slice;

    assert (matrix.isMagic);
    "%(%s\n%)\n".writefln(matrix);

    // negate diagonal elements
    matrix.diagonal.each!"a = -a";
    "%(%s\n%)\n".writefln(matrix);
}

// Checks if the matrix is Magic Square.
bool isMagic(S)(S matrix)
{
    auto n = matrix.length;
    auto c = n * (n * n + 1) / 2;// magic number
    return matrix.length!0 > 0   // check shape
        && matrix.length!0 == matrix.length!1
        //each row sum
        && matrix.byDim!0.map!sum == c.repeat(n)
        //each columns sum
        && matrix.byDim!1.map!sum == c.repeat(n)
        //diagonal sum
        && matrix.diagonal.sum == c
        //antidiagonal sum
        && matrix.reversed!1.diagonal.sum == c;
}
```
