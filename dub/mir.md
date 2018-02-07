# Mir

The package includes:

 - [mir-algorithm package](dub/mir-algorithm). Dlang core library for math, finance and a home for Dlang multidimensional array package - ndslice.
 - [mir-random package](dub/mir-random). Advanced random number generators.
 - Sparse tensors
 - Combinatorics
 - Hoffman

## Links

 - [Mir Algorithm API](http://docs.algorithm.dlang.io)
 - [Mir Random API](http://docs.random.dlang.io)
 - [Mir API](http://docs.mir.dlang.io)
 - [GitHub](https://github.com/libmir/mir)
 - [Lubeck](https://github.com/kaleidicassociates/lubeck) - Linear Algebra Library based on NDSlice API.

## {SourceCode}

```d
/+dub.sdl:
dependency "mir" version="~>1.1"
+/
import std.stdio;
import mir.combinatorics;
void main(string[] args)
{
    writeln([1, 2].combinations);
}
```
