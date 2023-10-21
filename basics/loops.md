# Loops

D provides four loop constructs.

### 1) `while`

`while`  loops execute the given code block while a certain condition is `true`.
(If the condition starts out `false` the code block isn't executed at all,
and the flow of control continues from the statement following the loop's block.)

    while (condition)
    {
        foo();
    }

### 2) `do ... while`

A `do .. while` loop unconditionally executes the given code block once,
and _then_ checks the condition.
So long as the condition is `true`, the code block is executed again, and the process
(check the condition, execute the code if the condition is `true`) is repeated.

    do
    {
        foo();
    } while (condition);

### 3) Classical `for` loop

The classical `for` loop known from C/C++ or Java
with _initializer_; _loop condition_; _loop statement_:

    for (int i = 0; i < arr.length; i++)
    {
        ...

### 4) `foreach`

The [`foreach` loop](basics/foreach) which will be introduced in more detail
in the next section:

    foreach (element; arr)
    {
        ...
    }

#### Special keywords and labels

If a `break` statement is encountered, the flow of control will immediately
jump to the statement following the loop's block.
If a _labelled_ `break` statement is encountered, the flow of control will
jump to the statement following the labelled loop's block. This allows us
to immediately break out of two or more nested loops if required.

    outer: for (int i = 0; i < 10; ++i)
    {
        for (int j = 0; j < 5; ++j)
        {
            ...
            break outer; // control jumps to (A)
            ...
        }
    }
    // (A) execution resumes here

A `continue` statement immediately moves the flow of control to the start of the loop's
next iteration e.g., to the top of a `while` loop to reevaluate the condition, to the top of a
`foreach` loop to get the next item,or to the _loop statement_ in a classic `for` loop.


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
