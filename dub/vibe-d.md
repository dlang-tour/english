# Vibe-d

Play with [vibe.d](http://vibed.org).

## {SourceCode:fullWidth:incomplete}

```d
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
+/
import vibe.d;
import std.stdio;

void main()
{
    listenHTTP(":8080", (req, res) {
        res.writeBody("Hello, World: " ~ req.path);
    });
    runTask({
        scope (exit) exitEventLoop();
        auto req = requestHTTP("http://localhost:8080");
        req.bodyReader.readAllUTF8.writeln;
    });
    runApplication();
}
```
