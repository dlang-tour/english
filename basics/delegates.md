# Delegates

### Functions as arguments

D supports *first class functions*, that is, D's functions can be
passed to other functions and can also be stored in variables.

Here is an example of a *higher order function*, that is, a
function which has a function parameter:

    void doSomething(int function(int, int) doer) {
        // call passed function
        doer(5,5);
    }

    doSomething(&add); // use global function `add` here
                       // add must have 2 int parameters

The passed in function (e.g.,`doer` in this example),
can then be called like any other normal function.

### Local functions with context

The above example uses the `function` type which is
a pointer to a global function. As soon as a member
function or a local function is referenced, `delegate`'s
must be used instead. A `delegate` is a function pointer
that additionally contains information about its
context - or *enclosure*. (These are called **closure**s
in other languages.) For example a `delegate`
that points to a member function of a class also includes
a pointer to the class object. And a `delegate` created inside
a nested function includes a link to the enclosing context
instead. However, the D compiler may automatically make a copy of
the context on the heap if it is necessary for memory safety -
then a delegate will link to this heap area.

    void foo() {
        void local() {
            writeln("local");
        }
        auto f = &local; // f is of type delegate()
    }

The same function `doSomething` taking a `delegate`
would look like this:

    void doSomething(int delegate(int, int) doer);

`delegate` and `function` objects cannot be mixed. But the
standard function
[`std.functional.toDelegate`](https://dlang.org/phobos/std_functional.html#.toDelegate)
converts a `function` to a `delegate`.

### Anonymous functions and Lambdas

Functions that are stored in variables or passed to other functions
don't really need their own names (since the variable or parameter
name is used to call them). Furthermore, many such functions are
rather short. To support these use cases, D supports nameless (anonymous)
functions, and one-line _lambda_ functions.

    auto f = (int lhs, int rhs) { // Nameless function assigned to variable f
        return lhs + rhs;
    };
    auto f = (int lhs, int rhs) => lhs + rhs; // Lambda - internally converted to the above

It is also possible to pass-in strings as template arguments to functional parts
of D's standard library. For example they offer a convenient way
to define a fold (reduce) function:

    [1, 2, 3].reduce!`a + b`; // 6

String functions are only possible for _one or two_ arguments and use `a`
as the first and `b` as the second argument.

### In-depth

- [Delegate specification](https://dlang.org/spec/function.html#closures)

## {SourceCode}

```d
import std.stdio : writeln;

enum IntOps {
    add = 0,
    sub = 1,
    mul = 2,
    div = 3
}

/**
Provides a math calculuation
Params:
    op = selected math operation
Returns: delegate which does a math operation
*/
auto getMathOperation(IntOps op)
{
    // Define 4 lambda functions for
    // 4 different mathematical operations
    auto add = (int lhs, int rhs) => lhs + rhs;
    auto sub = (int lhs, int rhs) => lhs - rhs;
    auto mul = (int lhs, int rhs) => lhs * rhs;
    auto div = (int lhs, int rhs) => lhs / rhs;

    // we can ensure that the switch covers
    // all cases
    final switch (op) {
        case IntOps.add:
            return add;
        case IntOps.sub:
            return sub;
        case IntOps.mul:
            return mul;
        case IntOps.div:
            return div;
    }
}

void main()
{
    int a = 10;
    int b = 5;

    auto func = getMathOperation(IntOps.add);
    writeln("The type of func is ",
        typeof(func).stringof, "!");

    // run the delegate func which does all the
    // real work for us!
    writeln("result: ", func(a, b));
}
```
