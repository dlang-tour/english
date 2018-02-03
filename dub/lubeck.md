# Lubeck

High level linear algebra library based on CBLAS, LAPACK and Mir Algorithm.

## Dependencies
Lubeck depends on CBLAS and LAPACK API. You may need to install them and update `dub.sdl`.
CBLAS and LAPACK are preinstalled on MacOS.
[OpenBLAS](http://www.openblas.net) or [Intel MKL](https://software.intel.com/en-us/mkl)
backends are recommeded for Linux and Windows.

## Links

 - [GitHub](https://github.com/kaleidicassociates/lubeck)
 - [Mir Algorithm API](http://docs.algorithm.dlang.io) 
 - [Mir Random API](http://docs.algorithm.dlang.io)
 - [Mir API](http://docs.mir.dlang.io)

## {SourceCode}

```d
/+dub.sdl:
dependency "lubeck" version="~>0.0.4"
libs "lapack" "blas" "cblas"
+/
import std.stdio;
import mir.ndslice: magic, repeat, as, slice;
import lubeck: mtimes;

void main()
{
    auto n = 5;
    auto matrix = n.magic.as!double.slice;  // Magic Square
    auto vec = 1.repeat(n).as!double.slice; // [1 1 1 1 1]
    // Uses CBLAS for multiplication
    matrix.mtimes(vec).writeln;
    matrix.mtimes(matrix).writeln;
}
```
