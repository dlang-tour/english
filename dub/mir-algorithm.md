# Mir Algorithm

Dlang Core Library and a home for multidimensional array package - ndslice.

## Links

 - [API Documentation](http://mir-algorithm.libmir.org)
 - [GitHub](https://github.com/libmir/mir-algorithm)
 - [Lubeck](https://github.com/kaleidicassociates/lubeck) - Linear Algebra Library based on NDSlice API.

## See Also

[Magic Square on Wikipedia](https://en.wikipedia.org/wiki/Magic_square).

## {SourceCode}

```d
/+dub.sdl:
dependency "mir-algorithm" version="~>3.6"
+/
import mir.algorithm.iteration: each;
import mir.ndslice;
import std.stdio: writeln;

void main()
{
    auto matrix = slice!double(3, 4);
    matrix[] = 0;
    matrix.diagonal[] = 1;

    auto row = matrix[2];
    row[3] = 6;
    // D & C index order
    assert(matrix[2, 3] == 6);

    matrix.byDim!0.each!writeln;
}
```
