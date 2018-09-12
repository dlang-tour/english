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
dependency "mir-algorithm" version="~>2.0"
+/

void main()
{
    import mir.ndslice;

    auto matrix = slice!double(3, 4);
    matrix[] = 0;
    matrix.diagonal[] = 1;

    auto row = matrix[2];
    row[3] = 6;
    // D & C index order
    assert(matrix[2, 3] == 6);

    import std.stdio;
    matrix.writeln;
}
```
