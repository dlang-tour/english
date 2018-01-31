# mir

Play with [mir](http://docs.mir.dlang.io/latest/index.html)

## {SourceCode}

```d
/+dub.sdl:
dependency "mir" version="~>1.1.1"
+/
import std.stdio;
import mir.combinatorics;
void main(string[] args)
{
    writeln([1, 2].combinations);
}
```
