English base language version of the DLang Tour
==============================================

[![sanitycheck build status](https://github.com/dlang-tour/english/actions/workflows/d.yml/badge.svg)](https://github.com/dlang-tour/english/actions/workflows/d.yml)

Found a typo or want to improve the content?
Just click on "edit" and send us a pull request.
If you want to discuss an idea for a change first,
don't hesitate to open an [issue](https://github.com/dlang-tour/english/issues).

You might also be looking for the [base repository](https://github.com/dlang-tour/core)
that hosts the content.

Run locally
-----------

You will need to fetch the [base repository](https://github.com/dlang-tour/core) via DUB once:

```sh
dub fetch dlang-tour
```

Now you can execute `dlang-tour` in the root directory of this repository:

```sh
dub run dlang-tour -- --lang-dir .
```
