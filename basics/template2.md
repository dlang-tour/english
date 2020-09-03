# Templates in D, Part 2

## Struct, class, and interface templates

The eponymous `struct` declaration:

    template Data(T)
    {
      struct Data
      {
        T[] x;
        T[] y;
      }
    }

In the same way that function templates with different parameters, are of different types, structs with different templates parameters, also have different types. This means that `is(Data!(double) == Data!(float))` is `false`.

The above template is an eponymous template, meaning that one of its members, has the same name as the template itself. This is in contrast to the template below:

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

usage:

    alias F = double;
    alias ls = LineSegment!(F);
    auto from = ls.Point(0., 0., 0.);
    auto to = ls.Point(1., 1., 1.);
    auto line = ls.Line(from, to);
    writeln("Line: ", line);


Class and interface templates, are declared in the same way as struct templates:

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

Note how the parameter (`T`) of the interface template, is the same as in the subclasses, for example `class Cylinder(T): Shape!(T){\*... Code ...*\}`. This **must** be the case in this instance. We can **not** have `class Cylinder(T): Shape!(U){\*... Code ...*\}`, where `is(T == U)` is `false`, because the signatures of the methods defined in the interface, will not match their implementation in the subclasses. So care must be taken, when implementing inheritance patterns, for interface and class templates.

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

output:


    Shape: Box, volume: 24
    Shape: Box, volume: 8
    Shape: Sphere, volume: 392.699
    Shape: Cylinder, volume: 169.646

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

void main()
{
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
}
```

