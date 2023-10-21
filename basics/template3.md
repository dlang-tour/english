# Templates in D, Part 3

## Variadic template objects

In the same way as in function templates, variadic templates can be used in structs, classes, and interfaces. An example of a variadic struct is given below. The implementation for classes and interfaces follow the same pattern:

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

## Traits

`pragma(msg, "...")` is a compile time directive for printing messages. Enumerations are templatable, they are a great way of defining expressions in compile time predicates, for template constraints. These types of expressions, are used extensively in the [std.traits](https://dlang.org/phobos/std_traits.html) standard library. We can combine these predicate expressions *traits*, to form other expressions:

    enum isSignedInteger(T) = is(T == short) || is(T == int) || is(T == long);
    enum isUnsignedInteger(T) = is(T == ushort) || is(T == uint) || is(T == ulong);
    enum isInteger(T) = isSignedInteger!(T) || isUnsignedInteger!(T);
    enum isFloat(T) = is(T == float) || is(T == double) || is(T == real);
    enum isNumeric(T) = isInteger!(T) || isFloat!(T);

These compile time expressions, can be used in template constraints with the `if()` directive. An example for template functions:

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

## static if

The `static if` directive allows us to carry out conditional compilation. The code in its scope is compiled if the condition is met, otherwise other commands can be executed, or further conditions given. This means that if the condition is not met, the respective code in scope is not compiled.

Recall the previous example for the `dot` kernel function template but this time with possiby different type array inputs:

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


The problem is that we don't really know if the return type `T`, is more suitable than type `U`. We would like to return which ever value is most accurate, meaning is the larger float type.

We can use `static if` with `alias` to create a `promote` template expression:

    template promote(T, U)
    {
      static if(T.sizeof > U.sizeof)
        alias promote = T;
      else
        alias promote = U;
    }

We can apply it to our template function:

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


