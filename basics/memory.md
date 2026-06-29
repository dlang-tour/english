# Memory

D is a system programming language and thus allows manual
memory management. However, manual memory management is prone to memory-safety errors
and thus D uses a *garbage collector* by default to manage memory allocation.

D provides pointer types `T*` like in C:

    int a;       // a is on the stack
    int* b = &a; // b contains address of a
    auto c = &a; // c is int* and contains address of a

A new memory block on the heap is allocated using a
[`new T` expression](https://dlang.org/spec/expression.html#new_expressions),
which returns a pointer to the managed memory (when T is a value type):

    int* a = new int;

Once the memory referenced by `a` isn't referenced anywhere
through any variable in the program, the next garbage collection
cycle will free its memory. By default, the garbage collector may only
run when allocating memory with the GC - for example when evaluating
a `new` expression.

* A GC cycle can be manually invoked with `GC.collect` (from
  [`core.memory`](https://dlang.org/phobos/core_memory.html#.GC))
* Collections can be disabled with `GC.disable` (and re-enabled with `GC.enable`)

### Memory-safe subset

Memory-safety violations can:

* Cause hard to reproduce bugs
* Allow unauthorized access to sensitive data
* Corrupt memory

To prevent these, D has a memory-safe subset.

D has three different security levels for functions: `@system`, `@trusted`, and `@safe`.
Unless specified otherwise, the default is `@system`, which does not check memory-safety.

`@safe` enforces a subset of D that prevents memory bugs from occurring by design.
`@safe` code can only call other `@safe` or `@trusted` functions.
Moreover, explicit pointer arithmetic is forbidden in `@safe` code:

    void main() @safe {
        int a = 5;
        int* p = &a;
        int* c = p + 5; // error
    }

`@trusted` functions are manually verified functions, which must have
a memory-safe interface.
Internally they can perform `@system` operations.
These allow a bridge between SafeD and the underlying dirty low-level world.

### In-depth

* [Garbage Collection](https://dlang.org/spec/garbage.html)
* [SafeD article](https://dlang.org/safed.html)
* [Memory-safe spec](https://dlang.org/spec/memory-safe-d.html)

## {SourceCode}

```d
import std.stdio : writeln;

void safeFun() @safe
{
    writeln("Hello World");
    // allocating memory with the GC is safe too
    int* p = new int;
}

void unsafeFun()
{
    int* p = new int;
    int* fiddling = p + 5;
}

// try declaring this @safe to get an error
void main()
{
    safeFun();
    unsafeFun();
}
```
