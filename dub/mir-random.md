# Mir Random

Advanced random number generators.

## Links

 - [API Documentation](http://docs.random.dlang.io)
 - [GitHub](https://github.com/libmir/mir-random)
 - [Mir Algorithm Documentation](http://docs.algorithm.dlang.io)

## {SourceCode}

```d
/+dub.sdl:
dependency "mir-random" version="~>2.0"
+/
import std.range, std.stdio;

import mir.random;
import mir.random.variable: normalVar;
import mir.random.algorithm: randomSlice;

void main()
{
    auto sample = normalVar
        .randomSlice(10)
        .array;

    // prints random element from the sample
    sample[$.randIndex].writeln;
}
```
