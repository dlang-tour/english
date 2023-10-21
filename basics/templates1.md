# Templates in D, Part 1

## Function templates

### Template longhand and shorthand declarations

There are two ways of declaring function templates. The longhand template notation, for example:

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

The shorthand notation for this same template is:

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

Shorthand templates are *always* eponymous.

Template functions are used with the form `dot!(T...)(T args)` for example:

    import std.stdio: writeln;
    void main()
    {
      auto x = [1., 2, 3, 4];
      auto y = [4., 3, 2, 1];
      writeln("dot product: ", dot!(double)(x, y));
    }

### Access patterns for template internals

Functions contained within a template, can have a different name from the template itself. For example:

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

We access the functions in the template like this:

    writeln("gaussian kernel: ", Kernel!(double).gaussian(x, y));

### Variadic template functions

Variadic template functions in D, are very similar in design to those in C++. The type sequence, is specified with an ellipsis `T...`. The template function below, can sum a variable number of inputs, each potentially of a different type:

    auto sum(T)(T x)
    {
      return x;
    }
    auto sum(F, T...)(F first, T tail)
    {
      return first + sum!(T)(tail);
    }

Usage:

    auto num = sum(1, 2.3f, 9.5L, 5.7);

### The `is()` directive

`is()` is a compile time directive, that converts expressions on types, into boolean constants.

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

the expression `if(is(T == float) || is(T == double) || is(T == real))`, *constrains* the template to be valid for conditions were `T` is one of `float`, `double`, or `real`.

## {SourceCode}
```d
template dot(T)
if(!(is(T == float) || is(T == double) || is(T == real)))
{
  static assert(false, "Type: " ~ T.stringof ~ " not value for the dot function");
}

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

enum isFloat(T) = is(T == float) || is(T == double) || is(T == real);
template promote(T, U)
if(isFloat!T && isFloat!U)
{
  static if(T.sizeof > U.sizeof)
    alias promote = T;
  else
    alias promote = U;
}

auto sum(T)(T x){
  return x;
}
auto sum(F, T...)(F first, T tail)
{
  return first + sum!(T)(tail);
}

import std.stdio: writeln;
void main()
{
  double[4] x = [1., 2, 3, 4];
  double[4] y = [4., 3, 2, 1];
  writeln("dot product: ", dot!(double)(x, y) );

  writeln("promote: ", promote!(real, double).stringof);
  auto num = sum(1, 2.3f, 9.5L, 5.7);
  writeln("Sum: ", num);
  writeln("Sum: ", typeof(num).stringof);
}
```
