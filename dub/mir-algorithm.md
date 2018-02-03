# Mir Algorithm

Dlang core library for math, finance and a home for Dlang multidimensional array package - ndslice.

## Links

 - [API Documentation](http://docs.algorithm.dlang.io)
 - [GitHub](https://github.com/libmir/mir-algorithm)
 - [Lubeck](https://github.com/kaleidicassociates/lubeck) - Linear Algebra Library based on NDSlice API.

## {SourceCode}

```d
/+dub.sdl:
dependency "mir-algorithm" version="~>0.8.0-alpha5"
+/
import mir.math.sum;
// Most of the API works for n-dimensional case too.
import mir.ndslice: magic, byDim, map, each, repeat, diagonal, antidiagonal;

import std.stdio: writeln;

void main()
{
    auto n = 3;

    auto matrix = n
        // creates lazy Magic Square,
        // https://en.wikipedia.org/wiki/Magic_square
        .magic
        // Converts elements type to double precision FP numbers
        .as!double
        // allocates data to a mutable ndslice
        .slice;

    assert (matrix.isMagic);
    "Magic Square is here".writeln;
    "%(%s\n%)\n".writeln(matrix);

    // negate diagonal elements
    matrix.diagonal.each!"a = -a";
    "%(%s\n%)\n".writeln(matrix);
}

// Checks if the matrix is Magic Square.
bool isMagic(S)(S matrix)
{
    auto n = matrix.length;
    auto c = n * (n * n + 1) / 2; // magic number
    return // check shape
        matrix.length!0 > 0 && matrix.length!0 == matrix.length!1
        && // each row sum should equal magic number
        matrix.byDim!0.map!sum == c.repeat(n)
        && // each columns sum should equal magic number
        matrix.byDim!1.map!sum == c.repeat(n)
        && // diagonal sum should equal magic number
        matrix.diagonal.sum == c
        && // antodiagonal sum should equal magic number
        matrix.antidiagonal.sum == c;
}
```
