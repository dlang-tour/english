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