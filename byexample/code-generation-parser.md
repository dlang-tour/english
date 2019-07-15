# Code generation (Parser)

In this example, a configuration parser is generated at compile-time.
Let's assume our program has a couple of configuration options,
summarized in a settings `struct`:

```d
struct Config
{
    int runs, port;
    string name;
}
```

While writing a parser for this struct, wouldn't be difficult, we would have to
constantly update the parser, whenever we modify the `Config` object.
Hence, we are interested in writing a generic `parse` function that can
read arbitrary configuration options. For simplicity, `parse` will accept
a very simple format of `key1=value1,key2=value2` configuration options, but the same technique
can be used for any arbitrary configuration format. For many popular
configuration format, of course, readers already exist on the [DUB registry](https://code.dlang.org).

Reading the configuration
-------------------------

Let's assume the user has "name=dlang,port=8080" as a configuration string.
We then directly split the configuration options by comma and call `parse` with each
individual configuration setting.
After all configuration options have been parsed, the entire configuration
object is printed.

Parse
-----

`parse` is where the real magic happens, but first we split the given configuration option
(e.g. "name=dlang") by "=" into key ("name") and value ("dlang").
The switch statement is executed with the parsed key, but the interesting bit is that
the switch cases have been statically generated. `c.tupleof` returns a list of all members
in the `(idx, name)` format. The compiler detects that the `c.tupleof` is known at compile-time
and will unroll the foreach loop at compile-time.
Hence, `Conf.tupleof[idx].stringof` will yield the individual members of the struct object
and generate a case statement for each member.
Equally, while being in the static loop, the individual members can be accessed by their index:
`c.tupleof[idx]` and thus we can assign the respective member the parsed value from the given
configuration string. Moreover, `dropOne` is necessary, because the splitted range still
points at the key and thus `dropOne.front` will return the second element.
Furthermore, `to!(typeof(field))` will do the actual parsing of the input string
to the respective type of the member of the configuration struct.
Finally, as the foreach loop is unrolled at compile-time a `break` would stop this loop.
However, after a configuration option has been successfully parsed, we don't want to jump
to the next case in the switch statement and thus a labeled break is used to break out the
switch statement.


## {SourceCode}

```d
import std.algorithm, std.conv, std.range,
        std.stdio, std.traits;
struct Config
{
    int runs, port;
    string name;
}
void main()
{
    Config conf;
    // use the generated parser for each entry
    "runs=1,port=2,name=hello"
        .splitter(",")
        .each!(e => conf.parse(e));
    conf.writeln;
}
void parse(Conf)(ref Conf c, string entry)
{
    auto r = entry.splitter("=");
    auto key = r.front, value = r.dropOne.front;
    Switch: switch (key)
    {
        static foreach(idx, field; Conf.tupleof)
        {
            case field.stringof:
                c.tupleof[idx] =
                    value.to!(typeof(field));
                break Switch;
        }
        default:
        assert (0, "Unknown member name.");
    }
}
```
