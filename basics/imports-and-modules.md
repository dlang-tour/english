# Imports and modules

{{#img-right}}turtle.svg{{/img-right}}

One of D's core design decision was to be consistent and avoid corner cases
in the language.
This is called [_turtles all the way down_](https://en.wikipedia.org/wiki/Turtles_all_the_way_down).
One good example for this consistency are `import`s.

## Imports

For a simple hello world program in D, `import`s are needed.
The `import` statement makes all public functions
and types from the given **module** available.

### The turtles start falling down

An `import` statement __does not__ need to appear at the top of a source file.
It can also be used locally within functions or any other scope.
In the following chapters you will see that this applies to almost all concepts in D. The language doesn't impose arbitrary restrictions on you.

### Selective imports

The standard library, called [Phobos](https://dlang.org/phobos/),
is located under the **package** `std`
and its modules are referenced through `import std.MODULE`.

The `import` statement can also be used to selectively
import certain symbols of a module:

    import std.stdio : writeln, writefln;

Selective imports can be used to improve readability by making
it obvious where a symbol comes from, and also as a way to
prevent clashing of symbols with the same name from different modules.

### Imports match directories and files

D's module system — in contrast to other systems — is entirely based on files.
For example, `my.cat` always refers to a file `cat.d` in the folder `my/`.
The folder `my` needs to be in the current working directory or
in one of the explicitly specified directory imports (`-I`).
Lastly, to ease splitting big modules up into multiple smaller files,
instead of `cat.d`, a folder `cat/` could be used as well.
The D compiler would then try to load `my/cat/package.d` instead of `my/cat.d`.

The convention (but not a hard rule) for `package.d` files is to publicly import
all other modules in the same folder.

## {SourceCode}

```d
void main()
{
    import std.stdio;
    // or import std.stdio : writeln;
    writeln("Hello, World!");
}
```
