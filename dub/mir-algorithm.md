# mir-algorithm

Play with [mir-algorithm](http://docs.algorithm.dlang.io/latest/index.html).

## {SourceCode}

```d
/+dub.sdl:
dependency "mir-algorithm" version="~>0.6.14"
+/
import std.stdio;
void main(string[] args)
{
    import mir.ndslice.topology : iota;
    import mir.ndslice.algorithm : reduce;
    auto sl = iota(2, 3);
    size_t(0).reduce!"a + b"(sl).writeln;
}
```
