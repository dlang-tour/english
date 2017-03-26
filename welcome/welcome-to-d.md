# Welcome to D

Welcome to the interactive tour of the *D Programming language*.

{{#dmanmobile}}

The tour gives an overview of this __powerful__ and __expressive__
language which compiles directly to __efficient__, __native__ machine code.

{{/dmanmobile}}

### What is D?

D is the culmination of _decades of experience implementing compilers_
for many diverse languages and has a unique set of features:

{{#dmandesktop}}

- _high level_ constructs for great modeling power
- _high performance_, compiled language
- static typing
- direct interface to the operating system API's and hardware
- blazingly fast compile-times
- memory-safe subset (SafeD)
- _maintainable_, _easy to understand_ code
- gradual learning curve (C-like syntax, similar to Java and others)
- compatible with C application binary interface
- limited compatibility with C++ application binary interface
- multi-paradigm (imperative, structured, object oriented, generic, functional programming purity, and even assembly)
- built-in error detection (contracts, unittests)

... and many more [features](http://dlang.org/overview.html).

{{/dmandesktop}}

### About the tour

Each section comes with a source code example that can be modified and used
to experiment with D's language features.
Click the run button (or `Ctrl-enter`) to compile and run it.

### Contributing

This tour is [open source](https://github.com/dlang-tour)
and we welcome pull requests making this tour even better.

## {SourceCode}

```d
import std.stdio;
import std.algorithm;
import std.range;

void main()
{
    // Let's get going!
    writeln("Hello World!");
    
    // An example for experienced programmers:
    // Take three arrays, and without allocating
    // any new memory, sort across all the
    // arrays inplace
    int[] arr1 = [4, 9, 7];
    int[] arr2 = [5, 2, 1, 10];
    int[] arr3 = [6, 8, 3];
    sort(chain(arr1, arr2, arr3));
    writefln("%s\n%s\n%s\n", arr1, arr2, arr3);
    // To learn more about this example, see the
    // "Range algorithms" page under "Gems"
}
```
