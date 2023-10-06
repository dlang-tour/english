# Unit Testing

Tests are an excellent way to help ensure stable, bug-free applications.
They serve as interactive documentation and allow the modification
of code without fear of breaking functionality. D provides a convenient
and native syntax for `unittest` blocks as part of the D language.
Anywhere in a D module `unittest` blocks can be used to test
functionality.

    // Block for my function
    unittest
    {
        assert(myAbs(-1) == 1);
        assert(myAbs(1)  == 1);
    }

This allows straightforward [Test-driven development](https://en.wikipedia.org/wiki/Test-driven_development)
on demand.

### Run & execute `unittest` blocks

`unittest` blocks can contain arbitrary code which is
compiled in and run *only* when the command line flag `-unittest`
is passed to the DMD compiler. DUB also features compiling
and running unittests with the `dub test` command.

### Verify examples with `assert`

Typically `unittest`s contain `assert` expressions that test
the functionality of a given function. `unittest` blocks
are typically located near the definition of a function
which might be at the top level of the source, or even
within classes or structs.

### Increasing code coverage

Unit tests are a powerful tool to help ensure reliable applications.
A common measure of how much of a program's
code is tested, is its _code coverage_.
This is the ratio of executed versus existing lines of code.
The DMD compiler makes generating code coverage reports easy
with the `-cov` flag. Use of this flag will cause a corresponding `.lst` file 
to be generated for every D module that's compiled. Each `.lst` file contains
detailed coverage statistics.

Since the compiler is able to infer attributes for templated code
automatically, it is a common pattern to add annotations to `unittest`s
to ensure matching attributes for the tested code:

    @safe @nogc nothrow pure unittest
    {
        assert(myAbs() == 1);
    }

### In-depth

- [Unit Testing in _Programming in D_](http://ddili.org/ders/d.en/unit_testing.html)
- [Unittesting in D](https://dlang.org/spec/unittest.html)

## {SourceCode}

```d
import std.stdio : writeln;

struct Vector3 {
    double x;
    double y;
    double z;

    double dot(Vector3 rhs) const {
        return x*rhs.x + y*rhs.y + z*rhs.z;
    }

    // That's okay!
    unittest {
        assert(Vector3(1,0,0).dot(
          Vector3(0,1,0)) == 0);
    }

    string toString() const {
        import std.string : format;
        return format("x:%.1f y:%.1f z:%.1f",
          x, y, z);
    }

    // .. and that too!
    unittest {
        assert(Vector3(1,0,0).toString() ==
          "x:1.0 y:0.0 z:0.0");
    }
}

void main()
{
    Vector3 vec = Vector3(0,1,0);
    writeln(`This vector has been tested: `,
      vec);
}

/*
Or just somewhere else.
Nothing is compiled in and just
ignored in normal mode. Run dub test
locally or compile with dmd -unittest
to actually test your modules.
*/
unittest {
    import std.math : isNaN;
    Vector3 vec;
    // .init a special built-in property that
    // returns the initial value of type,
    // a NaN for floating points values.
    assert(vec.x.init.isNaN);
}
```
