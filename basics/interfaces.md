# Interfaces

D allows defining `interface`s which are technically like
`class` types, but whose member functions must be implemented
by any class inheriting from the `interface`.

    interface Animal {
        void makeNoise();
    }

The `makeNoise` member function must be implemented
by `Dog` because it inherits from the `Animal` interface.
Essentially `makeNoise` behaves like an `abstract` member
function in a base class.

    class Dog : Animal {
        override void makeNoise() {
            ...
        }
    }

    auto dog = new Dog;
    Animal animal = dog; // implicit cast to interface
    animal.makeNoise();

Although a class may only directly inherit from *one* base class,
it may implement *any number* of interfaces.

### NVI (non virtual interface) pattern

The [NVI pattern](https://en.wikipedia.org/wiki/Non-virtual_interface_pattern)
allows _non virtual_ methods for a common interface.
Thus, this pattern prevents the violation of a common execution pattern.
D enables the NVI pattern by
allowing `final` (i.e. non-overridable) functions in an `interface`.
This enforces specific behaviours customized by overriding
other abstract `interface` functions.

    interface Animal {
        void makeNoise();
        final doubleNoise() // NVI pattern
        {
            makeNoise();
            makeNoise();
        }
    }

### In-depth

- [Interfaces in _Programming in D_](http://ddili.org/ders/d.en/interface.html)
- [Interfaces in D](https://dlang.org/spec/interface.html)

## {SourceCode}

```d
import std.stdio : writeln;

interface Animal {
    /*
    Virtual function
    which must be overridden!
    */
    void makeNoise();

    /*
    NVI pattern. Uses makeNoise internally
    to customize behaviour inheriting
    classes.

    Params:
        n =  number of repetitions
    */
    final void multipleNoise(int n) {
        for(int i = 0; i < n; ++i) {
            makeNoise();
        }
    }
}

class Dog: Animal {
    override void makeNoise() {
        writeln("Woof!");
    }
}

class Cat: Animal {
    override void makeNoise() {
        writeln("Meeoauw!");
    }
}

void main() {
    Animal dog = new Dog;
    Animal cat = new Cat;
    Animal[] animals = [dog, cat];
    foreach(animal; animals) {
        animal.multipleNoise(5);
    }
}
```
