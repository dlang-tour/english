# Templates and Compile Time Programming

## Motivation

The ability to have generality, specificity, and to generate code, provides the programmer with power and brevity. Here, we focus on [generic](https://en.wikipedia.org/wiki/Generic_programming) and [metaprogramming](https://en.wikipedia.org/wiki/Metaprogramming), both of which are resolved at compile time. In the sections dedicated to generic programming, we show how templates with type and value parameters, can increase the flexibility and reusability of code, how they can be made to have generality, and be used to target specific conditions. In the sections dedicated to metaprogramming, we introduce an array of tools that allows us to generate and manipulate code, which can be executed not only at run time, but also at compile time.

## Templates in D

Templates are the primary tool of generic programming in D, and can contain any mixture of the following entities:

* Functions.
* Structs, classes, and interfaces.
* Enumerations.
* Aliases.
* Any context-valid D declaration.
* Template expression. These may include statements such as:
  * `static if`. An expression for conditional compilation.
  * `static foreach`. An expression for iterating over a range at compile time.

At compile time, any parameters associated with templates must be known, and all parameters and variables created are constants.


## Function templates

### Function template longhand and shorthand declarations

There are two ways of declaring function templates. First the longhand template notation, for example:

```
template dot(T)
{
  auto dot(T[] x, T[] y)
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      dist += x[i] * y[i];
    }
    return dist;
  }
}
```

Another aspect of the above template, is that it is *eponymous*, because it contains members that have the same name as the template itself. The shorthand notation for this same template is:

```
auto dot(T)(T[] x, T[] y)
{
  T dist = 0;
  auto m = x.length;
  for(size_t i = 0; i < m; ++i)
  {
    dist += x[i] * y[i];
  }
  return dist;
}
```

Shorthand templates are *always* eponymous. The long and shorthand forms are treated exactly the same by the compiler. Therefore, you can only resolve one of them in any given scope.

Template functions are used with the form `dot!(T...)(T args)` for example:

```
import std.stdio: writeln;
void main()
{
  auto x = [1., 2, 3, 4];
  auto y = [4., 3, 2, 1];
  writeln("dot product: ", dot!(double)(x, y));
}
```

Gives the output:

```
dot product: 20
```

Note that `dot` is a template, `dot!(double)` is a function, and the next set of brackets is where the arguments go. In addition, when there is only one parameter in the template, we don't need the template brackets. So `dot!double(x, y)` is the same as `dot!(double)(x, y)`. Be aware, that template parameters change the type of the entity created, for example `is(typeof(dot!(double)) == typeof(dot!(float)))` is `false`.

### Inference of parameter types

The D compiler is smart enough to do type inference of template functions. We can omit the type identifier, and call the template function, just like any other D function, on `x` and `y`. This means that `dot(x, y)`, will produce the same result as `dot!(double)(x, y)`. However in the case where `x` and `y` are of different types:

```
double[] x = [1., 2, 3, 4];
float[] y = [4.0f, 3.0f, 2.0f, 1.0f];
```
we get an error message:

```
Error: function functions.dot!double.dot(double[] x, double[] y) 
        is not callable using argument types (double[], float[])
```

To remedy this, we can use two template parameters:

```
template dot(T, U)
{
  auto dot(T[] x, U[] y)
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      dist += x[i] * y[i];
    }
    return dist;
  }
}
```

At the moment, the output `dist` uses whatever `T` is as the return type. Later, we discuss a way of deciding which template parameter `T` or `U` is used. We can do this, by building a promotion rule, using traits and a template expression.

### Access patterns for template internals

Functions contained within a template, can have a different name from the template itself. For example:

```
template Kernel(T)
{
  auto dot(T[] x, T[] y)
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      dist += x[i] * y[i];
    }
    return dist;
  }
  import std.math: exp, sqrt;
  auto gaussian(T[] x, T[] y)
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      auto tmp = x[i] - y[i];
      dist += tmp * tmp;
    }
    return exp(-sqrt(dist));
  }
}
```

We access the functions in the template like this:

```
writeln("gaussian kernel: ", Kernel!(double).gaussian(x, y));
```

So the *eponymous template* notation, can be viewed as a special case access pattern. However, the eponymous access pattern: 

```
dot!(double)(x, y)
``` 

is **not** shorthand for this: 

```
dot!(double).dot(x, y)
```

which will fail.

Templates in D can have value parameters, for instance the code below, restricts the arrays to static types of a specific length `N`:

```
import std.math: exp, sqrt;
auto gaussian(long N = 4, T)(T[N] x, T[N] y)
{
  T dist = 0;
  auto m = x.length;
  for(size_t i = 0; i < m; ++i)
  {
    auto tmp = x[i] - y[i];
    dist += tmp * tmp;
  }
  return exp(-sqrt(dist));
}
```

`x` and `y` have to be static arrays. Our template parameter `N` of type `long` has a *default value* of `4`. *Since templates are resolved during compile time, all template parameters **must** be known then and **all** compile time parameters are constants.*

### Alias template parameter

Our implementation of the `gaussian` kernel function, is missing a parameter `theta`. We can include this in its template argument as an `alias` parameter:

```
import std.math: exp, sqrt;
template gaussian(alias theta) //alias template parameter
{
  alias T = typeof(theta); //alias for type assignment
  auto gaussian(T[] x, T[] y)
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      auto tmp = x[i] - y[i];
      dist += tmp * tmp;
    }
    return exp(-sqrt(dist)/theta);
  }
}
```

which is then executed as:

```
writeln("gaussian kernel: ", gaussian!(0.75)(x, y));
```

with the output:

```
gaussian kernel: 0.00257257
```

The `alias` directive in the template declaration, `template gaussian(alias theta)` allows us to pass any item that isn't a type. In this case, since we want the type of `theta` to be the same as the element type of arrays `x` and `y`, we use `alias T = typeof(theta);`, to capture the type, and use it as an identifier, for the arguments of the `gaussian` function.

### Variadic template functions

Variadic template functions in D, are very similar in design to those in C++. The type sequence, is specified with an ellipsis `T...`. The template function below, can sum a variable number of inputs, each potentially of a different type:

```
auto sum(T)(T x)
{
  return x;
}
auto sum(F, T...)(F first, T tail)
{
  return first + sum!(T)(tail);
}
```

the first `sum` function gives the case for a single item `T x`, and the second (recursive) function gives the case for more than one item. Function selection occurs by overloading. These different implementations of templates, and not only function overloads, but are also **template specializations**. The template parameters in the second specialization `(F, T...)` are an example of using *pattern matching* in templates.

Usage:

```
auto num = sum(1, 2.3f, 9.5L, 5.7);// type inference
writeln("Sum: ", num);
```

output:

```
Sum: 18.5
```

also:

```
writeln("typeof(num): ", typeof(num).stringof);
```

output:

```
typeof(num): real
```

The above example, shows that D carries out sensible numeric type promotions by default.

### The `is()` directive

`is()` is a compile time directive, that converts expressions on types, into boolean constants. It can be used within template expressions, but also as a **template constraint**. For example we can restrict the `dot` template we created earlier to floating point types:

```
template dot(T)
if(is(T == float) || is(T == double) || is(T == real))
{
  auto dot(T[] x, T[] y)
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      dist += x[i] * y[i];
    }
    return dist;
  }
}
```

the expression `if(is(T == float) || is(T == double) || is(T == real))`, *constrains* the template to be valid for conditions were `T` is one of `float`, `double`, or `real`. Below, we have implemented a template overload for the converse case:


```
template dot(T)
if(!(is(T == float) || is(T == double) || is(T == real)))
{
  static assert(false, "Type: " ~ T.stringof ~ " not value for the dot function");
}
```
and this:

```
dot!(string) z;
```

produces the requisite error:

```
Error: static assert:  "Type: string not value for the dot function"
      instantiated from here: dot!string
```

### More on template constraints and partial specialization

We next explore template constraints and specializations, by considering code for calculating [vector norms](https://en.wikipedia.org/wiki/Lp_space). In the code snippet below, we import functions from the [core.stdc.math](https://dlang.org/phobos/core_stdc_math.html) module, and define an enumeration template `isFloat`. Predicates like this, are implemented in the [std.traits](https://dlang.org/phobos/std_traits.html) module of the D standard library. *(We shall revisit these enumeration templates later.)*

```
import std.stdio: writeln;
import core.stdc.math: abs = fabs, abs = fabsf, abs = fabsl,
                       sqrt, sqrt = sqrtf, sqrt = sqrtl,
                       max = fmax, max = fmaxf, max = fmaxl;

enum isFloat(T) = is(T == float) || is(T == double) || is(T == real);
```

Using a boolean statement, we can create a template constraint, that selects which cases our implementation applies to. In this case, we only want floating point types, where `p == 1`, and where the type of `p`, matches the element type of `x`.

```
template norm(alias p, T)
if((p == 1) && isFloat!(T) && is(typeof(p) == T))
{
  auto norm(T[] x)
  {
    T ret = 0;
    foreach(el; x)
    {
      ret += abs(el);
    }
    return ret;
  }
}
```

Below is the implementation for `p == 2`:

```
template norm(alias p, T)
if((p == 2) && isFloat!(T) && is(typeof(p) == T))
{
  auto norm(T[] x)
  {
    T ret = 0;
    foreach(el; x)
    {
      ret += sqrt(abs(el));
    }
    return ret;
  }
}
```

Below is the implementation for `infinity` norm:

```
template norm(alias p, T)
if((p == T.infinity) && isFloat!(T) && is(typeof(p) == T))
{
  auto norm(T[] x)
  {
    T ret = 0;
    foreach(el; x)
    {
      ret = max(abs(ret), abs(el));
    }
    return ret;
  }
}
```

Below is the implementation for all other cases:

```
template norm(alias p, T)
if(((p != 1) && (p != 2) && (p != T.infinity)) && isFloat!(T) && is(typeof(p) == T))
{
  auto norm(T[] x)
  {
    T ret = 0;
    foreach(el; x)
    {
      ret += abs(el)^^(1/p); //the double caret is not an mistake
    }
    return ret;
  }
}
```

we can create a **partial template specialization** for `p = 2.0/3.0`:


```
alias astroid(T) = norm!(2.0/3.0, T);
```

which can be called with:

```
writeln("astroid: ", astroid!(double)([0.1, 0.2, 0.3, 0.4, 0.5, 0.6]));
```

```
astroid: 1.35668
```

## Struct, class, and interface templates

### Struct template longhand and shorthand declarations

The longhand way of declaring a `struct` is:

```
template Data(T)
{
  struct Data
  {
    T[] x;
    T[] y;
  }
}
```

and the shorthand syntax is:

```
struct Data(T)
{
  T[] x;
  T[] y;
}
```

To the compiler, these two forms are interpreted as the same.

Usage:

```
double[] x = [1., 2, 3, 4];
double[] y = [4., 3, 2, 1];
writeln("Data: ", Data!double(x, y));
```

```
Data: Data!double([1, 2, 3, 4], [4, 3, 2, 1])
```

In the same way that function templates with different parameters, are of different types, structs with different templates parameters, also have different types. This means that `is(Data!(double) == Data!(float))` is `false`.

The above template is an eponymous template, meaning that one of its members, has the same name as the template itself. This is in contrast to the template below:

```
template LineSegment(T)
{
  struct Point
  {
    T x;
    T y;
    T z;
  }
  struct Line
  {
    Point from;
    Point to;
  }
}
```

usage:

```
alias F = double;
alias ls = LineSegment!(F);
auto from = ls.Point(0., 0., 0.);
auto to = ls.Point(1., 1., 1.);
auto line = ls.Line(from, to);
writeln("Line: ", line);
```
output:
```
Line: Line(Point(0, 0, 0), Point(1, 1, 1))
```

Class and interface templates, are declared in the same way as struct templates:

```
import std.stdio: writeln;
enum double pi = 3.14159265359;

interface Shape(T)
{
  string name();
  T volume();
}

class Box(T): Shape!(T)
{
  T length;
  T width;
  T height;
  this(T length, T width, T height)
  {
    this.length = length;
    this.width = width;
    this.height = height;
  }
  this(T length)
  {
    this.length = length;
    this.width = length;
    this.height = length;
  }
  T volume()
  {tup[3]
    return length * width * height;
  }
  string name()
  {
    return "Box";
  }
}
class Sphere(T): Shape!(T)
{
  T radius;
  this(T radius)
  {
    this.radius = radius;
  }
  T volume()
  {
    return (4/3)*pi*(radius^^3);
  }
  string name()
  {
    return "Sphere";
  }
}
class Cylinder(T): Shape!(T)
{
  T radius;
  T height;
  this(T radius, T height)
  {
    this.radius = radius;
    this.height = height;
  }
  T volume()
  {
    return pi*height*(radius^^2);
  }
  string name()
  {
    return "Cylinder";
  }
}
```

Note how the parameter (`T`) of the interface template, is the same as in the subclasses, for example `class Cylinder(T): Shape!(T){\*... Code ...*\}`. This **must** be the case in this instance. We can **not** have `class Cylinder(T): Shape!(U){\*... Code ...*\}`, where `is(T == U)` is `false`, because the signatures of the methods defined in the interface, will not match their implementation in the subclasses. So care must be taken, when implementing inheritance patterns, for interface and class templates.

```
alias F = double;
Shape!(F) box = new Box!(F)(2., 3., 4.);
Shape!(F) cube = new Box!(F)(2.);
Shape!(F) ball = new Sphere!(F)(5);
Shape!(F) tube = new Cylinder!(F)(3, 6);
Shape!(F)[] shapes = [box, cube, ball, tube];
foreach(shape; shapes)
{
  writeln("Shape: ", shape.name, ", volume: ", shape.volume);
}
```
output:
```
Shape: Box, volume: 24
Shape: Box, volume: 8
Shape: Sphere, volume: 392.699
Shape: Cylinder, volume: 169.646
```

### Variadic template objects

In the same way as in function templates, variadic templates can be used in structs, classes, and interfaces. An example of a variadic struct is given below. The implementation for classes and interfaces follow the same pattern:

```
import std.conv: to;
import std.stdio: writeln;

struct Tuple(T...)
{
  enum length = T.length;
  alias data = T;
  auto opIndex()(long i)
  {
    return data[i];
  }
}

void main()
{
  alias tup = Tuple!(2020, "August", "Friday", 28).data;
  writeln(tup[2] ~ ", " ~ to!(string)(tup[3]) ~ ", " ~ tup[1] ~ 
                  " " ~ to!(string)(tup[0]));
}
```
output: 
```
Friday, 28, August 2020
```

### Template constraints and specialization 

Below is the implementation of a pair data structure:

```
import std.conv: to;
import std.stdio: writeln;

template Pair(F, S)
{
  struct Pair
  {
    F first;
    S second;
    string toString()
    {
      return "Pair!(" ~ F.stringof ~ ", " ~ S.stringof ~ 
          ")(" ~ to!(string)(first) ~ ", " ~ to!(string)(second) ~ ")";
    }
  }
}
```

Checking the functionality:

```
writeln(Pair!(string, long)("Height", 196));
```
output:
```
Pair!(string, long)(Height, 196)
```

We can partially specialize setting `F` to `string`:

```
alias Dimension(S) = Pair!(string, S);
```

Usage:

```
writeln(Dimension!(long)("Width", 80));
```
output:
```
Pair!(string, long)(Width, 80)
```

As with function templates, we can constrain structs, classes, and interfaces. Here we amend the implementation of the template `Pair!(F, S)` such that `S` can only be an unsigned integer.

```
template Pair(F, S)
if(is(S == ushort) || is(S == uint) || is(S == ulong))
{
  struct Pair
  {
    F first;
    S second;
    string toString()
    {
      return "Pair!(" ~ F.stringof ~ ", " ~ S.stringof ~ 
          ")(" ~ to!(string)(first) ~ ", " ~ to!(string)(second) ~ ")";
    }
  }
}
```

Below is a specialization for `F` as `char`:

```
template Pair(F: char, S)
{
  struct Pair
  {
    F first;
    S second;
    string toString()
    {
      return "Pair!(Specialization: " ~ F.stringof ~ ", " ~ S.stringof ~ 
          ")(" ~ to!(string)(first) ~ ", " ~ to!(string)(second) ~ ")";
    }
  }
}
```

Usage:

```
writeln(Pair!(char, ulong)('D', 50));
```
output:
```
Pair!(Specialization: char, ulong)(D, 50)
```

## Enumeration templates

Enumerations in D can be used to denote constants, and in compile time they are a useful way to declare data items. As with other templatable forms, enumerations have a longhand:

```
template isSignedInteger(T)
{
  enum isSignedInteger = is(T == short) || is(T == int) || is(T == long);
}
```

and a shorthand form:

```
enum isSignedInteger(T) = is(T == short) || is(T == int) || is(T == long);
```

usage:

```
pragma(msg, "isSignedInteger!ulong: ", isSignedInteger!ulong);
pragma(msg, "isSignedInteger!long: ", isSignedInteger!long);
```

output:

```
isSignedInteger!ulong: false
isSignedInteger!long: true
```

### Traits

`pragma(msg, "...")` is a compile time directive for printing messages. Enumerations are templatable, they are a great way of defining expressions in compile time predicates, for template constraints. These types of expressions, are used extensively in the [std.traits](https://dlang.org/phobos/std_traits.html) standard library. We can combine these predicate expressions *traits*, to form other expressions:

```
enum isSignedInteger(T) = is(T == short) || is(T == int) || is(T == long);
enum isUnsignedInteger(T) = is(T == ushort) || is(T == uint) || is(T == ulong);
enum isInteger(T) = isSignedInteger!(T) || isUnsignedInteger!(T);
enum isFloat(T) = is(T == float) || is(T == double) || is(T == real);
enum isNumeric(T) = isInteger!(T) || isFloat!(T);
```

These compile time expressions, can be used in template constraints with the `if()` directive. An example for template functions:

```
template dot(T)
if(isFloat!(T))// template constraint is here
{
  auto dot(T[] x, T[] y)
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      dist += x[i] * y[i];
    }
    return dist;
  }
}
```

Structs, classes, and interfaces follow a similar pattern:

```
template LineSegment(T)
if(isFloat(T))// template constraint is here
{
  struct Point
  {
    T x;
    T y;
    T z;
  }
  struct Line
  {
    Point from;
    Point to;
  }
}
```

## Alias templates

The `alias` keyword in this context, is used for creating new symbols that are an *alias* for another type. However, as far as the compiler is concerned, they are identical. Consider `myFloat` below, it is just another name for the `float` type.

```
alias myFloat = float;
```

you may also see notation like this:

```
alias float myFloat;
```

which does the same thing. 

An alias template in longhand for a pointer type is given below:

```
template P(T)
{
  alias P = T*;
}
```

shorthand:

```
alias P(T) = T*;
```

usage:

```
double x0 = 2.99792458E8;
P!(double) x1 = &x0;
import std.stdio: writeln;
writeln("Speed of light: ", *x1, " m/s");
```

output:

```
Speed of light: 2.99792e+08 m/s
```

### static if

The `static if` directive allows us to carry out conditional compilation. The code in its scope is compiled if the condition is met, otherwise other commands can be executed, or further conditions given. This means that if the condition is not met, the respective code in scope is not compiled.

Recall the previous example for the `dot` kernel function template:

```
template dot(T, U)
if(isFloat!(T) && isFloat!(U))
{
  auto dot(T[] x, U[] y)
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      dist += x[i] * y[i];
    }
    return dist;
  }
}
```

The problem was that we don't really know if type `T` the return type, is more suitable than type `U`. We would like to return which ever value is most accurate, meaning is the larger float type.

We can use `static if` with `alias` to create a `promote` template expression:

```
template promote(T, U)
{
  static if(T.sizeof > U.sizeof)
    alias promote = T;
  else
    alias promote = U;
}
```

Notice also that eponymous naming of items in a template is a way of "returning" them. Let's go back to the `dot` example of template functions, which allows entries of different float types:

```
template isFloat(T)
{
  enum isFloat = is(T == float) || is(T == double) || is(T == real);
}

template dot(T, U)
if(isFloat!(T) && isFloat!(U))
{
  auto dot(T[] x, U[] y)
  {
    promote!(T, U) dist = 0; // result type is now defined by promote
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      dist += x[i] * y[i];
    }
    return dist;
  }
}
```

## Metaprogramming in D

### Introduction

At compile time, D code and data is generated and translated into object code, to be executed at runtime. This process can be viewed as a phase transition from a fluid state (compile time), where the program is still malleable, to a solid state (runtime), where all the rules are "baked-in", and the program runs in accordance with them.

Metaprogramming in D is processed at compile time. When we write compile time code, we are actually writing code that is interpreted by the compiler, which in turn creates more code or data. When code is executed at compile time, we are using D as a kind of interpreter that processes our inputs. All this occurs before any object files are created and executed. All variables created at compile time are constants. They can not be changed, but can be scoped.

The main tools available for metaprogramming in D are:

* Templates - have already been covered. They provide the ability to produce flexible and well targeted generic code. Recursion is a significant part of working with templates, and we often use eponymous naming as a way of "returning" items.
* Compile time data structures such as sequences and lookups. A wide variety of data objects can be used at compile time by assigning them as enumerations (constant data types).
* `static if` gives us the ability to create conditional compilation code.
* `static foreach` allows us to iterate over ranges at compile time.
* `static assert` allows us to throw an error at compile time if specific conditions are not met.
* String mixins use concatenated strings to form legal D code at compile time. They can generate code to be executed at runtime or compile time. They can be inserted anywhere in a script, so long as the code generated is valid in the context.
* Template mixins are code blocks that can have template parameters, and can be inserted anywhere in a script, so long as the code is valid in the context.
* The `import("code.d")` directive. The `import` keyword is more commonly used to load modules, or parts of modules. For example `import std.stdio: writeln;`, will import the `writeln` function for IO purposes. However, the `import` keyword can also be used to load scripts or data at compile time.
* Compile Time Function Evaluation (CTFE). In a similar way to `constexpr` in C++, this is a feature, where regular functions written in D, can be made to execute at compile time. It can be a convenient and easy alternative, to template expressions.

These tools provide the programmer with an extensive capability, these tools enables them to create highly flexible and powerful programs.


### AliasSeq!(T) compile time sequences

`AliasSeq!(T)` is implemented in the `std.meta` library of Phobos; it allows us to create compile time sequences of types and data. Its implementation is simple:


```
alias AliasSeq(T...) = T;
```

The `Nothing` template is also defined in the same module:

```
alias Nothing = AliasSeq!();
```

We can create a compile time sequence like this:

```
alias tSeq = AliasSeq!(ushort, short, uint, int, ulong, long);
pragma(msg, "Type sequence: ", tSeq);
```

output:

```
Type sequence: (ushort, short, uint, int, ulong, long)
```

#### Append, prepend and concatenating compile time lists

`AliasSeq(T...)` type sequences are not a traditional "container"; when they are input into templates they "spread out", or expand and become like separate arguments of a function, as if they were not contained but input individually. One consequence is that there is no need to define operations for Append, Prepend, and Concatenate because they is already implied in the definition. The following examples show this applied.

##### Append

Here, we append `string` to the end of our type sequence:

```
alias appended = AliasSeq!(tSeq, string);
pragma(msg, appended);
```
output:
```
Append: (ushort, short, uint, int, ulong, long, string)
```

##### Prepend

Here, we prepend  `string` to the front of our type sequence:

```
alias appended = AliasSeq!(string, tSeq);
pragma(msg, "Append: ", appended);
```
Output:
```
Prepend: (string, ushort, short, uint, int, ulong, long)
```

##### Concatenate

Here, we concatenate `AliasSeq!(ubyte, byte)` with our original type sequence:

```
alias bytes = AliasSeq!(ubyte, byte);
alias concat = AliasSeq!(bytes, tSeq);
pragma(msg, "Concatenate: ", concat);
```

Output:

```
Concatenate: (ubyte, byte, ushort, short, uint, int, ulong, long)
```

Looking carefully at the code, above you may observe that each new sequence we create has a new identifier. This is because as mentioned before, compile time variables are constants, so we can not amend a previous identifier to a new item.

Let's take a closer look at what is happening with `AliasSeq` type sequences. Let's say we wanted to join (concatenate) two type sequences, we would do this:

```
alias AliasSeq(T...) = T;

alias lhs = AliasSeq!(byte, ubyte);
alias rhs = AliasSeq!(short, ushort);

template Join(L, R...)
{
  pragma(msg, "L: ", L);
  pragma(msg, "R: ", R);
  alias Join = AliasSeq!(L, R);
}

alias joined = Join!(lhs, rhs);
pragma(msg, "Join!(lhs, rhs): ", joined);

void main(){}
```

**Compiler-interpreter:**
*Note we can leave the `main` function empty because all our code is compile time, and runtime execution occurs under `main`. In fact we could skip including the `main` function altogether and use the `-o-` flag, to suppress the creation of an object (executable) file with the dmd compiler (`dmd script.d -o-`). At this point, there is nothing to "run" because all our code is executed at compile time. This is a little like what occurs in an interpreted language.*

The output we get is:

```
L: byte
R: (ubyte, short, ushort)
Join!(lhs, rhs): (byte, ubyte, short, ushort)
```

Meaning that the parameters expand, and `L` is now pattern matched to a single item in the type sequence, while the rest of the sequence is denoted in `R`. If we try to use this template instead:

```
template Join(L, R)
{
  alias Join = AliasSeq!(L, R);
}
```

we will get a compiler error:

```
Error: template instance Join!(byte, ubyte, short, ushort) 
            does not match template declaration Join(L, R)
```

Meaning that if no variadic symbols are used, D will assume single entities for the arguments. If we try

```
template Join(L..., R...)
{
  alias Join = AliasSeq!(L, R);
}
```

we will get... `Error: variadic template parameter must be last`. So we can not define more than one variadic symbol.


### Replacing items in compile time sequences

We can manipulate compile time sequences, and some *functional* modes of manipulation are given in the [std.meta](https://dlang.org/phobos/std_meta.html) module. Below, a template expression is implemented that allows us to replace an item in a compile time sequence `T...`, with a type `S`:

```
template Replace(size_t idx, S, Args...)
{
  static if (Args.length > 0 && idx < Args.length)
    alias Replace = AliasSeq!(Args[0 .. idx], S, Args[idx + 1 .. $]);
  else
    static assert(0);
}
```

Let's see if this works:

```
alias replace0 = Replace!(0, int, tSeq);
pragma(msg, "Modify (bool @ 0) => int: ", replace0);
alias replace1 = Replace!(1, byte, tSeq);
pragma(msg, "Modify (string @ 1) => byte: ", replace1);
alias replace2 = Replace!(tSeq.length - 1, uint, tSeq);
pragma(msg, "Modify (ushort @ end) => uint: ", replace2);
// Below gives us an error as it should
//alias replace3 = Replace!(0, int, Nothing);
pragma(msg, "Modify individual item: ", Replace!(0, double, AliasSeq!(int)));
```

Output:

```
Modify (bool @ 0) => int: (int, short, uint, int, ulong, long)
Modify (string @ 1) => byte: (ushort, byte, uint, int, ulong, long)
Modify (ushort @ end) => uint: (ushort, short, uint, int, ulong, uint)
Modify individual item: (double)
```

### Replacing multiple items with an individual type

#### String mixins

String mixins allow us to create runtime and compile time code by concatenating strings together, and they can be inserted any valid context. They are a little like macros in C, however unlike C's macros, "[string mixins] in text must form complete declarations, statements, or expressions", and they have other added protections that make them inherently safer than C macros.

Note: In D the usual method for concatenating strings is the `'~'` operator, but we have to be careful with this; `'~'` will interpret a number such as 0 as a null byte, so we use the `text` function in the `std.conv` module to concatenate safely.

The code below implements a `Replace` template specialization. It uses mixins to create compile time code "on the fly". These commands facilitate multiple replacements at locations in `Args` given by the sequence `indices`:

```
import std.conv: text;
template Replace(alias indices, S, Args...)
if(Args.length > 0)
{
  enum N = indices.length;
  static foreach(i; 0..N)
  {
    static if(i == 0)
    {
      mixin(text(`alias x`, i, ` = Replace!(indices[i], S, Args);`));
    }else{
      mixin(text(`alias x`, i, ` = Replace!(indices[i], S, x`, (i - 1), `);`));
    }
  }
  mixin(text(`alias Replace = x`, N - 1, `;`));
}
```

We traverse `indices` using a `static foreach` loop, and use `static if` to compile different code at each iteration, mixins are used to create new constants at each iteration.

Under the condition `static if(i == 0)` we have:

```
mixin(text(`alias x`, i, ` = Replace!(indices[i], S, Args);`));
```

which translates to:

```
alias x0 = Replace!(indices[i], S, Args);
```

and under the else condition, we have:

```
mixin(text(`alias x`, i, ` = Replace!(indices[i], S, x`, (i - 1), `);`));
```

which for `i == 1` translates to:

```
alias x1 = Replace!(indices[i], S, x0);
```

With successive iterations, we replace all the items specified by indices in `Args` with `S`. The template calls the first implementation of `Replace` at each index. Note that the back-tick `` ` `` in the mixins, is used as an alternative to the common string quote `"`. We can see that it works:

```
alias replace4 = Replace!([0, 2, 4], string, tSeq);
pragma(msg, "Replace ([0, 2, 4]) => string: ", replace4);
```

Output:

```
Replace ([0, 2, 4]) => string: (string, short, string, int, string, long)
```

#### static foreach

In the static foreach loop example above, the variables at each iteration are **not** scoped, because we use single curly braces `{` `}`. This means that all the variables we generate, `x0..x(N-1)` are all available outside these braces at the last line, where we assign the last variable created to `Replace`, to be "returned". To scope variables created in a `static foreach` loops, we use double curly braces `{{` `}}` like this:

```
static foreach(i; 0..N)
{{
  /* ... code here ... */
}}
```

### Replacing multiple items by a tuple of items

#### Contained type sequences
We have already seen that there if we pass more than one `AliasSeq!(T)` sequence as template parameters, the template expands and we can not recover which items were in which parameter. To remedy this, we can build a tuple type as a container for types. For more information see <a href="https://dlang.org/phobos/std_typecons.html" target="_blank">std.typecons</a> which contains tools for interacting with tuples:

```
struct Tuple(T...)
{
  enum ulong length = T.length;
  alias get(ulong i) = T[i];
  alias getTypes = T;
}
```

So:

* `length` is a constant for the number of items.
* `get(i)` returns whatever item is at the location `i`.
* `getTypes` returns the type sequence `T`.

Next we create a predicate trait that tells us whether something is a `Tuple` or not:

```
enum bool isTuple(Tup...) = false;
enum bool isTuple(Tup: Tuple!T, T...) = true;
```

This is different from the previous predicates we defined. Firstly we do a kind of "catchall" for `false`, and then set Tuple types to `true` in the second declaration.

Let's see if these operations work:

```
alias tupleConcat = AliasSeq!(real, Tuple!(tSeq));
pragma(msg, "Concatenation with Tuple: ", tupleConcat);
```

output:

```
Concatenation with Tuple: (real, Tuple!(ushort, short, uint, int, ulong, long))
```

Now the functionality of `Tuple`:

```
pragma(msg, "\nTuple length: ", Tuple!(tSeq).length);
pragma(msg, "Tuple types: ", Tuple!(tSeq).getTypes);
pragma(msg, "Tuple!(tSeq).get!(0): ", Tuple!(tSeq).get!(0));
pragma(msg, "Tuple!(tSeq).get!(1): ", Tuple!(tSeq).get!(1));
pragma(msg, "Tuple!(tSeq).get!(2): ", Tuple!(tSeq).get!(2), "\n");
```
output:
```
Tuple length: 6LU
Tuple types: (ushort, short, uint, int, ulong, long)
Tuple!(tSeq).get!(0): ushort
Tuple!(tSeq).get!(1): short
Tuple!(tSeq).get!(2): uint
```

and `isTuple`:

```
pragma(msg, "\nisTuple (false): ", isTuple!(real));
pragma(msg, "isTuple (false): ", 
                          isTuple!(AliasSeq!(long, ulong, real)));
pragma(msg, "isTuple (true): ", 
                          isTuple!(Tuple!(long, ulong, real)), "\n");
```

```
isTuple (false): false
isTuple (false): false
isTuple (true): true
```

We are now ready for a template specialization that replaces multiple items in `AliasSeq` by the types in a tuple:

```
template Replace(alias indices, S, Args...)
if((Args.length > 0) && isTuple!(S) && (indices.length == S.length))
{
  enum N = indices.length;
  static foreach(i; 0..N)
  {
    static if(i == 0)
    {
      mixin(text(`alias x`, i, ` = Replace!(indices[i], S.get!(i), Args);`));
    }else{
      mixin(text(`alias x`, i, 
             ` = Replace!(indices[i], S.get!(i), x`, (i - 1), `);`));
    }
  }
  mixin(text(`alias Replace = x`, N - 1, `;`));
}
```

Usage:

```
alias replace6 = Replace!([0, 2, 4], Tuple!(long, ulong, real), tSeq);
pragma(msg, "([0, 2, 4]) => (long, ulong, real): ", replace6);
```
Output:
```
([0, 2, 4]) => (long, ulong, real): (long, short, ulong, int, real, long)
```

The template constraint includes `isTuple`, *so we should go back to our previous implementation of `Replace`, and amend it's constraints to ensure that they are distinguishable*:

```
// Replacing multiple items with an individual type
template Replace(alias indices, S, Args...)
if(Args.length > 0 && !isTuple!(S)){/*... Code ...*/}
```

In addition to the `isTuple!(S)` constraint in the `Replace` template, there is an additional constraint `indices.length == S.length`. We could have used a `static assert(indices.length == S.length, "... message ...");` in the template body to throw an error for that case, but it is a design choice that prevents `indices.length != S.length` from entering the template body altogether. Instead we can create another specialization:

```
template Replace(alias indices, S, Args...)
if((Args.length > 0) && isTuple!(S) && (indices.length != S.length))
{
  static assert(false, 
        "tuple length is not equal to length of replacement indices");
}
```

### Template mixins, CTFE, and import

#### Template mixins

A template `mixin` allows code blocks to be inserted at any relevant point in our script. Consider the following code using our previous kernel functions, but this time they are expressed as template mixins. We can choose which kernel function to compile by selecting the relevant `mixin`:

```
mixin template dot()
{
  auto kernel(T)(T[] x, T[] y)
  if(is(T == float) || is(T == double) || is(T == real))
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      dist += x[i] * y[i];
    }
    return dist;
  }
}

mixin template gaussian()
{
  import std.math: exp, sqrt;
  auto kernel(T)(T[] x, T[] y)
  if(is(T == float) || is(T == double) || is(T == real))
  {
    T dist = 0;
    auto m = x.length;
    for(size_t i = 0; i < m; ++i)
    {
      auto tmp = x[i] - y[i];
      dist += tmp * tmp;
    }
    return exp(-sqrt(dist));
  }
}

mixin gaussian!();//chosing the compile the gaussian kernel
```

#### CTFE

Compile Time Function Evaluation (CTFE) is a feature where a function can be evaluate at compile time, either explicitly by making its output an enumeration, or implicitly by the compiler opting to evaluate an immutable variable at compile time for efficiency purposes. Following from the mixins declared above we can use CTFE to calculate a value for the `kernel`.

```
//Inputs available at compile time
enum x = [1., 2, 3, 4];
enum y = [4., 3, 2, 1];
// CTFE
enum calc = kernel!(double)(x, y);
//Output
pragma(msg, "kernel: ", calc);
```

#### import("code.d")

If we put the template mixin code and CTFE evaluations above into a file named `code.d`, we could load them all in another D module at compile time by using the `import` directive:

```
//myModule.d
enum code = import("code.d");
mixin(code);
```

Now compile:

```
dmd myModule.d -J="." -o-
```

In this case we add the `-o-` flag because we don't use the `main` function in the scripts (there's no runtime execution). The `-J` flag must be used when we import in this way. It is used to specify a relative path to where the `code.d` file is located.


## Summary

We can see that D has an array of powerful tools for generic and metaprogramming. These tools enables programmers to write generic flexible and highly targeted code, as well as to carry out metaprogramming to generate appropriate code for any given application.

### In-depth

- [Tutorial to D Templates](https://github.com/PhilippeSigaud/D-templates-tutorial)
- [Templates in _Programming in D_](http://ddili.org/ders/d.en/templates.html)

#### Advanced

- [D Templates spec](https://dlang.org/spec/template.html)
- [Templates Revisited](http://dlang.org/templates-revisited.html):  Walter Bright writes about how D improves upon C++ templates.
- [Variadic templates](http://dlang.org/variadic-function-templates.html): Articles about the D idiom of implementing variadic functions with variadic templates

## {SourceCode}

```d
import std.stdio: writeln;
enum double pi = 3.14159265359;

interface Shape(T)
{
  string name();
  T volume();
}

class Box(T): Shape!(T)
{
  T length;
  T width;
  T height;
  this(T length, T width, T height)
  {
    this.length = length;
    this.width = width;
    this.height = height;
  }
  this(T length)
  {
    this.length = length;
    this.width = length;
    this.height = length;
  }
  T volume()
  {
    return length * width * height;
  }
  string name()
  {
    return "Box";
  }
}
class Sphere(T): Shape!(T)
{
  T radius;
  this(T radius)
  {
    this.radius = radius;
  }
  T volume()
  {
    return (4/3)*pi*(radius^^3);
  }
  string name()
  {
    return "Sphere";
  }
}
class Cylinder(T): Shape!(T)
{
  T radius;
  T height;
  this(T radius, T height)
  {
    this.radius = radius;
    this.height = height;
  }
  T volume()
  {
    return pi*height*(radius^^2);
  }
  string name()
  {
    return "Cylinder";
  }
}


template Shapes(T)
{
  struct Box
  {
    T length;
    T width;
    T height;
  }
  struct Sphere
  {
    T radius;
  }
  struct Cylinder
  {
    T radius;
    T height;
  }
}

template LineSegment(T)
{
  struct Point
  {
    T x;
    T y;
    T z;
  }
  struct Line
  {
    Point from;
    Point to;
  }
}


void main()
{
  alias F = double;
  
  alias ls = LineSegment!(F);
  auto from = ls.Point(0., 0., 0.);
  auto to = ls.Point(1., 1., 1.);
  auto line = ls.Line(from, to);
  writeln("Line: ", line);

  Shape!(F) box = new Box!(F)(2., 3., 4.);
  Shape!(F) cube = new Box!(F)(2.);
  Shape!(F) ball = new Sphere!(F)(5);
  Shape!(F) tube = new Cylinder!(F)(3, 6);
  Shape!(F)[] shapes = [box, cube, ball, tube];
  foreach(shape; shapes)
  {
    writeln("Shape: ", shape.name, ", volume: ", shape.volume);
  }
}
```
