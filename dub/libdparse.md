# libdparse

Play with [libdparse](https://github.com/dlang-community/libdparse)

## {SourceCode:fullWidth:incomplete}

```d
/+dub.sdl:
dependency "libdparse" version="~>0.7"
+/
import dparse.ast;
import std.stdio;

class TestVisitor : ASTVisitor
{
    alias visit = ASTVisitor.visit;

    override void visit(const FunctionDeclaration decl)
    {
        decl.name.text.writeln;
    }
}

void main()
{
    import dparse.lexer;
    import dparse.parser : parseModule;
    import dparse.rollback_allocator : RollbackAllocator;
    import std.array : array;
    import std.string : representation;

    auto sourceCode = q{
        void foo() @safe {}
    }.dup;
    LexerConfig config;
    auto cache = StringCache(StringCache.defaultBucketCount);
    auto tokens = getTokensForParser(sourceCode.representation, config, &cache);

    RollbackAllocator rba;
    auto m = parseModule(tokens.array, "test.d", &rba);
    auto visitor = new TestVisitor();
    visitor.visit(m);
}
```
