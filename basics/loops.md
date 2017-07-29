# Loops

D provides four loop constructs.

### 1) `while`

`while`  loops execute the given code block
while a certain condition is met:

    while (condition)
    {
        foo();
    }

### 2) `do ... while`

The `do .. while` loops execute the given code block
while a certain condition is met, but in contrast to `while`
the _loop block_ is executed before the loop condition is
evaluated for the first time.

    do
    {
        foo();
    } while (condition);

### 3) Classical `for` loop

The classical `for` loop known from C/C++ or Java
with _initializer_, _loop condition_ and _loop statement_:

    for (int i = 0; i < arr.length; i++)
    {
        ...

### 4) `foreach`

The [`foreach` loop](basics/foreach) which will be introduced in more detail
in the next section:

    foreach (el; arr)
    {
        ...
    }

#### Special keywords and labels

The special keyword `break` will immediately abort the current loop.
In a nested loop a _label_ can be used to break out of any outer loop:

    outer: for (int i = 0; i < 10; ++i)
    {
        for (int j = 0; j < 5; ++j)
        {
            ...
            break outer;

The keyword `continue` starts with the next loop iteration.

### In-depth

- `for` loop in [_Programming in D_](http://ddili.org/ders/d.en/for.html), [specification](https://dlang.org/spec/statement.html#ForStatement)
- `while` loop in [_Programming in D_](http://ddili.org/ders/d.en/while.html), [specification](https://dlang.org/spec/statement.html#WhileStatement)
- `do-while` loop in [_Programming in D_](http://ddili.org/ders/d.en/do_while.html), [specification](https://dlang.org/spec/statement.html#do-statement)

## {SourceCode}

```d
import std.stdio : writeln;

/*
Computes the average of
the elements of an array.
*/
double average(int[] array)
{
    immutable initialLength = array.length;
    double accumulator = 0.0;
    while (array.length)
    {
        // this could be also done with .front
        // with import std.array : front;
        accumulator += array[0];
        array = array[1 .. $];
    }

    return accumulator / initialLength;
}

void main()
{
    auto testers = [ [5, 15], // 20
          [2, 3, 2, 3], // 10
          [3, 6, 2, 9] ]; // 20

    for (auto i = 0; i < testers.length; ++i)
    {
      writeln("The average of ", testers[i],
        " = ", average(testers[i]));
    }
}
```
