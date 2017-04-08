# Templates

**D** allows defining templated functions similar to C++ and Java
which is a means to define **generic** functions or objects which work
for any type that compiles with the statements within the function's body:

    auto add(T)(T lhs, T rhs) {
        return lhs + rhs;
    }

The template parameter `T` is defined in a set of parentheses
in front of the actual function parameters. `T` is a placeholder
which is replaced by the compiler when actually *instantiating*
the function using the `!` operator:

    add!int(5, 10);
    add!float(5.0f, 10.0f);
    add!Animal(dog, cat); // won't compile; Animal doesn't implement +

### Implicit Template Parameters

Function templates have two parameter sets - the first is for
compile-time arguments and the second is for run-time arguments.
(Non-templated functions can accept only run-time arguments).
If one or more compile-time arguments are left unspecified when the function is called,
the compiler tries to deduce them from the list of run-time arguments as the types of those arguments.

    int a = 5; int b = 10;
    add(a, b); // T is to deduced to `int`
    float c = 5.0;
    add(a, c); // T is deduced to `float`

### Template properties

A function can have any number of template parameters which
are specified during instantiation using the `func!(T1, T2 ..)`
syntax. Template parameters can be of any basic type
including `string`s and floating point numbers.

Unlike generics in Java, templates in D are compile-time only, and yield
highly optimized code tailored to the specific set of types
used when actually calling the function

Of course, `struct`, `class` and `interface` types can be defined as template
types too.

    struct S(T) {
        // ...
    }

### In-depth

- [Tutorial to D Templates](https://github.com/PhilippeSigaud/D-templates-tutorial)
- [Templates in _Programming in D_](http://ddili.org/ders/d.en/templates.html)

#### Advanced

- [D Templates spec](https://dlang.org/spec/template.html)
- [Templates Revisited](http://dlang.org/templates-revisited.html):  Walter Bright writes about how D improves upon C++ templates.
- [Variadic templates](http://dlang.org/variadic-function-templates.html): Articles about the D idiom of implementing variadic functions with variadic templates

## {SourceCode}

```d
import std.stdio : writeln;

/**
Template class that allows
generic implementation of animals.
Params:
    noise = string to write
*/
class Animal(string noise) {
    void makeNoise() {
        writeln(noise ~ "!");
    }
}

class Dog: Animal!("Woof") {
}

class Cat: Animal!("Meeoauw") {
}

/**
Template function which takes any
type T that implements a function
makeNoise.
Params:
    animal = object that can make noise
    n = number of makeNoise calls
*/
void multipleNoise(T)(T animal, int n) {
    for (int i = 0; i < n; ++i) {
        animal.makeNoise();
    }
}

void main() {
    auto dog = new Dog;
    auto cat = new Cat;
    multipleNoise(dog, 5);
    multipleNoise(cat, 5);
}
```
