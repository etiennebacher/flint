
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tinylint

`tinylint` is a small R package to detect lints in R code and optionally
replace them.

- Lint detections with `lint()`
- Automatic replacement of lints with `fix()`
- Compatibility with `{lintr}` rules
- Extremely fast
- Low-dependency

`tinylint` is powered by the Rust crate
[`ast-grep`](https://ast-grep.github.io/).

## Usage

Start by setting up `tinylint` with `tinylint::setup_tinylint()`. This
imports `sgconfig.yml` and stores a set of rules in
`inst/tinylint/rules`.

`tinylint` provides two families of functions:

- those for linting: `lint()`, `lint_text()`.
- those for replacing lints: `fix()`, `fix_text()`

## Comparison with existing tools

The most used tool for lints detection in R is `lintr`. However,
`lintr`’s performance is not optimal when it is applied on medium to
large packages. Also, `lintr` cannot perform automatic replacement of
lints.

`styler` is a package to clean code by fixing indentation and other
things, but doesn’t perform code replacement based on lints.

`tinylint` is extremely performant:

\[TODO\]
