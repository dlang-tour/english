# Metaprogramming in D, Part 2

## Template mixins, CTFE, and import

### Template mixins

A template `mixin` allows code blocks to be inserted at any relevant point in our script. Consider the following code using our previous kernel functions, but this time they are expressed as template mixins. We can choose which kernel function to compile by selecting the relevant `mixin`:

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

### CTFE

Compile Time Function Evaluation (CTFE) is a feature where a function can be evaluated at compile time, either explicitly by making its output an enumeration, or implicitly by the compiler opting to evaluate an immutable variable at compile time for efficiency purposes. Following from the mixins declared above we can use CTFE to calculate a value for the `kernel`.

    //Inputs available at compile time
    enum x = [1., 2, 3, 4];
    enum y = [4., 3, 2, 1];
    // CTFE
    enum calc = kernel!(double)(x, y);
    //Output
    pragma(msg, "kernel: ", calc);

### import("code.d")

If we put the template mixin code and CTFE evaluations above into a file named `code.d`, we could load them all in another D module at compile time by using the `import` directive:

    //myModule.d
    enum code = import("code.d");
    mixin(code);

Now compile:

    dmd myModule.d -J="." -o-

In this case we add the `-o-` flag because we don't use the `main` function in the scripts (there's no runtime execution). The `-J` flag must be used when we import in this way. It is used to specify a relative path to where the `code.d` file is located.

## {SourceCode}
```d
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

mixin gaussian!();

enum x = [1., 2, 3, 4];
enum y = [4., 3, 2, 1];
enum calc = kernel!(double)(x, y);
pragma(msg, "kernel: ", calc);
```
