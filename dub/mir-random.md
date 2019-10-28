# Mir Random

Advanced random number generators.

## Links

 - [API Documentation](http://mir-random.libmir.org)
 - [GitHub](https://github.com/libmir/mir-random)
 - [Mir Algorithm Documentation](http://mir-algorithm.libmir.org)

## {SourceCode}

```d
/+dub.sdl:
dependency "mir-random" version="~>2.2"
+/
import mir.random;
import mir.random.algorithm: randomSlice;
import mir.random.variable: normalVar;
import std.stdio: writeln;

void main()
{
    auto sample = normalVar.randomSlice(10);
    writeln(sample);

    // prints random element from the sample
    writeln(sample[$.randIndex]);
}
```
