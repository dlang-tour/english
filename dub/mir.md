# Mir

The package includes:

 - [mir-algorithm package](dub/mir-algorithm). Dlang core library for math, finance and a home for Dlang multidimensional array package - ndslice.
 - [mir-random package](dub/mir-random). Advanced random number generators.
 - Sparse tensors
 - Hoffman

## Links

 - [Mir Algorithm API](http://mir-algorithm.libmir.org)
 - [Mir Random API](http://mir-random.libmir.org)
 - [Mir API](http://mir.libmir.org)
 - [GitHub](https://github.com/libmir/mir)
 - [Lubeck](https://github.com/kaleidicassociates/lubeck) - Linear Algebra Library based on NDSlice API.

## {SourceCode}

```d
/+dub.sdl:
dependency "mir" version="~>3.2"
+/
import mir.sparse;
import std.stdio: writeln;

void main()
{
    // DOK format
    auto sl = sparse!double(5, 8);
    sl[] =
        [[0, 2, 0, 0, 0, 0, 0, 1],
         [0, 0, 0, 0, 0, 0, 0, 4],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [6, 0, 0, 0, 0, 0, 0, 9],
         [0, 0, 0, 0, 0, 0, 0, 5]];

    // CRS/CSR format
    auto crs = sl.compress;
    writeln(crs);
}
```
