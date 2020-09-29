# Lubeck

High level linear algebra library based on CBLAS, LAPACK and Mir Algorithm.

## Dependencies
Lubeck depends on CBLAS and LAPACK API. You may need to install them and update `dub.sdl`.
CBLAS and LAPACK are preinstalled on MacOS.
[OpenBLAS](http://www.openblas.net) or [Intel MKL](https://software.intel.com/en-us/mkl)
backends are recommeded for Linux and Windows.

## Links

 - [GitHub](https://github.com/kaleidicassociates/lubeck)
 - [Mir Algorithm API](http://mir-algorithm.libmir.org)
 - [Mir Random API](http://mir-random.libmir.org)
 - [Mir API](http://mir.libmir.org)

## {SourceCode:incomplete}

```d
/+dub.sdl:
dependency "lubeck" version="~>1.1"
+/
import kaleidic.lubeck: mtimes;
import mir.algorithm.iteration: each;
import mir.ndslice: magic, repeat, as,
    slice, byDim;
import std.stdio: writeln;

void main()
{
    auto n = 5;
    // Magic Square
    auto matrix = n.magic.as!double.slice;
    // [1 1 1 1 1]
    auto vec = 1.repeat(n).as!double.slice;
    // Uses CBLAS for multiplication
    matrix.mtimes(vec).writeln;
    "-----".writeln;
    matrix.mtimes(matrix).byDim!0.each!writeln;
}
```
