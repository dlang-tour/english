# Mir Random

Advanced random number generators.

## Links

 - [API Documentation](http://docs.random.dlang.io)
 - [GitHub](https://github.com/libmir/mir-random)
 - [Mir Algorithm Documentation](http://docs.algorithm.dlang.io)

## {SourceCode}

```d
/+dub.sdl:
dependency "mir-random" version="~>0.3"
+/
import mir.random: rne;
import mir.random.variable: NormalVariable;
import mir.random.algorithm: range;

import std.range: array, take;
import std.stdio;

void main()
{
    auto sample_size = 10;
    auto rvar = NormalVariable!double(0, 1); // Random Variable: ~N(0, 1)
    auto sample = range!rne(rvar).take(sample_size).array;

    writeln(sample);
}
```
