# Install D locally

The D language reference compiler is called DMD (Digital Mars D).
Also available are "GCD" (a [GCC](https://gcc.gnu.org/)-based D
compiler) and "LDC" (an [LLVM](http://llvm.org)-based D compiler).
See [the Compilers wiki page](https://wiki.dlang.org/Compilers) for
more detailed information, but if you're new to D and aren't sure
which to install, install DMD.

## Download and Install

The [D downloads page](https://dlang.org/download.html) provides an
overview of the various D implementations, and contains links to
pre-built OS-specific DMD packages ready to download and install.

As an alternative to the OS-specific packages, there's also an install
script there for use with GNU/Linux|FreeBSD|MacOS that can install the
various implementations (including multiple versions of them) right
into your home directory. Running the `curl` command as shown there
will install DMD into ~/dlang. After successful completion of the
command you'll be instructed to run the provided `activate` script to
prepare your terminal and you'll be ready to roll.

## Configure your editor

The beauty about D is that you don't need a fancy IDE as boilerplate code is very rare.
However, using D is nicer when you are in the comfortable zone of your favorite editor.
There are D plugins for at least the following editors:

- [Atom](https://github.com/Pure-D/atomize-d)
- [Eclipse](http://ddt-ide.github.io)
- [Emacs](https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode)
- [IntelliJ](https://github.com/intellij-dlanguage/intellij-dlanguage)
- [Sublime Text](https://github.com/yazd/DKit)
- [Vim](https://wiki.dlang.org/D_in_Vim)
- [VS Code](https://marketplace.visualstudio.com/items/webfreak.code-d)
- [Visual Studio](http://rainers.github.io/visuald/visuald/StartPage.html)

You may also want to try an IDE dedicated to D:

- [Coedit](https://github.com/BBasile/Coedit)
- [Dlang IDE](https://github.com/buggins/dlangide)

The D wiki contains a more detailed overview of available [editors](https://wiki.dlang.org/Editors) and [IDEs](https://wiki.dlang.org/IDEs).
