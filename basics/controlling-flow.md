# Control flow

An application's flow can be controlled conditionally with `if` and `else`
statements:

    if (a == 5) {
        writeln("Condition is met");
    } else if (a > 10) {
        writeln("Another condition is met");
    } else {
        writeln("Nothing is met!");
    }

When an `if` or `else` block only contains one statement,
the braces can be omitted.

D provides the same operators as C/C++ and Java to test
variables for equality or compare them:

* `==` and `!=` for testing equality and inequality
* `<`, `<=`, `>` and `>=` for testing less than (or equal to) and greater than (or equal to)

For combining multiple conditions, the `||` operator represents
the logical *OR*, and `&&` the logical *AND*.

### Switch Statement

D also defines a `switch`..`case` statement which executes one case
depending on the value of *one* variable. `switch`
works with all basic types as well as strings!

    switch (day) {
        case "Friday":
            writeln("Almost weekend");
            break;
        case "Saturday", "Sunday":
            writeln("Weekend!");
            break;
        default:
            writeln("Not weekend");
    }

It's even possible to define ranges for integral types
using the `case START: .. case END:` syntax.

### While Loop

D contains the typical `while` and `do-while` looping constructs. These loops repeat as long as their conditions holds `True`. The `do-while` loop will however runs at least once, _before_ evaluating whether it's looping condition holds `True`:

    while (condition) {...}
    do {...} while (condition);

### For Loop

D provides the typical `for` loop statement known from C/C++ or Java, containing three `;` delimited parts.

Using the example below, the first part of the `for` statement is used to initialize a looping variable (`int i = 0`).
The body of the loop is repeated for as long as the second part, the looping condition, holds `True` (`i < 10`).
At the end of every loop iteration, the third part is evaluated (`i+=1`), incrementing the looping variable:

    for (int i = 0; i < 10; i+=1) {
        ... // body
    }

Thus this example repeats its body 10 times.

### Foreach Loop

The [`foreach` loop](basics/foreach) will be introduced in more detail in a later section. It is used to iterate over rangers/arrays:

    foreach (element; array) {
        ... // body
    }

### In-depth

- Logical expressions in [_Programming in D_](http://ddili.org/ders/d.en/logical_expressions.html), [specification](https://dlang.org/spec/expression.html#logical_expressions)
- `if` statement in [_Programming in D_](http://ddili.org/ders/d.en/if.html), [specification](https://dlang.org/spec/statement.html#if-statement)
- Ternary conditional expressions in [_Programming in D_](http://ddili.org/ders/d.en/ternary.html), [specification](https://dlang.org/spec/expression.html#conditional_expressions)
- `switch` in [_Programming in D_](http://ddili.org/ders/d.en/switch_case.html), [specification](https://dlang.org/spec/statement.html#switch-statement)
- `for` in [_Programming in D_](http://ddili.org/ders/d.en/for.html), [specification](https://dlang.org/spec/statement.html#ForStatement)
- `while` in [_Programming in D_](http://ddili.org/ders/d.en/while.html), [specification](https://dlang.org/spec/statement.html#WhileStatement)
- `do-while` in [_Programming in D_](http://ddili.org/ders/d.en/do_while.html), [specification](https://dlang.org/spec/statement.html#do-statement)


## {SourceCode}

```d
import std.stdio : write, writeln;

bool isPrime(int n) {
	if (n <= 1)
		return false;
	for (int i = 2; i < n; i += 1) {
		if (n % i == 0)
			return false;
	}
	return true;
}

void main() {
	int i = 1;
	while (i < 10) {
		write(i);
		write(" is prime: ");
		writeln(isPrime(i) ? "True" : "False");
		i += 1;
	}
}
```
