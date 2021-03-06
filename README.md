# ppx_sh [![Version](https://img.shields.io/badge/version-v0.1.1-orange.svg?style=flat)](https://github.com/yuanqing/ppx_sh/releases) [![Build Status](https://img.shields.io/travis/yuanqing/ppx_sh.svg?branch=master&style=flat)](https://travis-ci.org/yuanqing/ppx_sh)

> An OCaml [syntax extension](http://caml.inria.fr/cgi-bin/viewvc.cgi/ocaml/trunk/experimental/frisch/extension_points.txt?view=log) for invoking shell commands.

*Requires OCaml >= 4.02.*

## Example

`ppx_sh` converts the following:

```ocaml
let str = "foo" in
let exit_code, output = [%sh "echo" str]
```

&hellip;into:

```ocaml
let str = "foo" in
let exit_code, output = Sh.exec ["echo"; str]
```

The `Sh.exec` function returns a tuple of type `int * string list`.
- `int` is the exit code of the shell command.
- `string list` are the lines of output of the shell command.

Our example is analogous to:

```
$ echo foo
```

## Usage

To compile a file `foo.ml` into `foo.out`, passing `foo.ml` through the `ppx_sh` preprocessor, simply do:

```
$ make foo.out
```

## Tests

First, install [OUnit](http://opam.ocaml.org/packages/ounit/ounit.2.0.0/) with [OPAM](https://opam.ocaml.org):

```
$ opam install ounit
```

Then do:

```
$ make
```

## Changelog

- 0.1.0
  - Initial release

## License

[MIT](https://github.com/yuanqing/ppx_sh/blob/master/LICENSE)
