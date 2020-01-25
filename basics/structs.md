# Structs

One way to define compound or custom types in D is to
use a `struct`:

    struct Person {
        int age;
        int height;
        float ageXHeight;
    }

By default `struct`s are constructed on the stack (unless created
with `new`) and are copied **by value** in assignments or
as parameters to function calls.

    auto p = Person(30, 180, 3.1415);
    auto t = p; // copy

When a new object of a `struct` type is created, its members can be initialized
in the order they are defined in the `struct`. A custom constructor can be defined through
a `this(...)` member function. If needed to avoid name conflicts, the current instance
can be explicitly accessed with `this`:

    struct Person {
        this(int age, int height) {
            this.age = age;
            this.height = height;
            this.ageXHeight = cast(float)age * height;
        }
            ...

    Person p = Person(30, 180); // initialization
    p = Person(30, 180);  // assignment to new instance

A `struct` may contain any number of member functions. By default
they are `public` and accessible from the outside. They could
also be `private` and thus only be callable by other
member functions of the same `struct`, or other code in the same
module.

    struct Person {
        void doStuff() {
            ...
        private void privateStuff() {
            ...

    // In another module:
    p.doStuff(); // call method doStuff
    p.privateStuff(); // forbidden

### Const member functions

If a member function is declared with `const`, it won't be allowed
to modify any of its members. This is enforced by the compiler.
Making a member function `const` makes it callable on any `const`
or `immutable` object, but also guarantees to callers that
the member function will never change the state of the object.

### Static member functions

If a member function is declared as `static`, it will be callable
without an instantiated object (e.g. `Person.myStatic()`) but it
cannot be called by non-`static` members.  It can be used if a
method doesn't need to access any of the object member fields but logically
belongs to the same class. Also it can be used to provide some functionality
without creating an explicit instance, for example, some Singleton
design pattern implementations use `static`.

### Inheritance

Note that a `struct` can't inherit from another `struct`.
Hierachies of types can only be built using classes,
which we will see in a later section.
However, with `alias this` or `mixins` one can easily achieve
polymorphic inheritance.

### In-depth

- [Structs in _Programming in D_](http://ddili.org/ders/d.en/struct.html)
- [Struct specification](https://dlang.org/spec/struct.html)

### Exercise

Given the `struct Vector3`, implement the following functions and make
the example application run successfully:

* `length()` - returns the vector's length
* `dot(Vector3)` - returns the dot product of two vectors
* `toString()` - returns a string representation of this vector.
  The function [`std.string.format`](https://dlang.org/phobos/std_format.html)
  returns a string using `printf`-like syntax:
  `format("MyInt = %d", myInt)`. Strings will be explained in detail in a later
  section.

## {SourceCode:incomplete}

```d
struct Vector3 {
    double x;
    double y;
    double z;

    double length() const {
        import std.math : sqrt;
        // TODO: implement the length of Vector3
        return 0.0;
    }

    // rhs will be copied
    double dot(Vector3 rhs) const {
        // TODO: implement the dot product
        return 0.0;
    }
}

void main() {
    auto vec1 = Vector3(10, 0, 0);
    Vector3 vec2;
    vec2.x = 0;
    vec2.y = 20;
    vec2.z = 0;

    // If a member function has no parameters,
    // the calling braces () may be omitted
    assert(vec1.length == 10);
    assert(vec2.length == 20);

    // Test the functionality for dot product
    assert(vec1.dot(vec2) == 0);

    // 1 * 1 + 2 * 1 + 3 * 1
    auto vec3 = Vector3(1, 2, 3);
    assert(vec3.dot(Vector3(1, 1, 1)) == 6);

    // 1 * 3 + 2 * 2 + 3 * 1
    assert(vec3.dot(Vector3(3, 2, 1)) == 10);
}
```
