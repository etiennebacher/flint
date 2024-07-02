
<!-- README.md is generated from README.Rmd. Please edit that file -->

# flint

`flint` is a small R package to find and replace linters in R code.

- Lint detections with `lint()`
- Automatic replacement of lints with `fix()`
- Compatibility with `{lintr}` rules
- Extremely fast
- Low-dependency

`flint` is powered by
[`astgrepr`](https://github.com/etiennebacher/astgrepr/), which is
itself built on the Rust crate
[`ast-grep`](https://ast-grep.github.io/).

## Usage

Start by setting up `flint` with `flint::setup_flint()`. This stores a
set of rules in `inst/flint/rules`. You can then extend those rules if
you want more control.

`flint` provides two families of functions:

- those for linting: `lint()`, `lint_text()`.
- those for replacing lints: `fix()`, `fix_text()`

## Comparison with existing tools

The most used tool for lints detection in R is `lintr`. However,
`lintr`’s performance is not optimal when it is applied on medium to
large packages. Also, `lintr` cannot perform automatic replacement of
lints.

`styler` is a package to clean code by fixing indentation and other
things, but doesn’t perform code replacement based on lints.

`flint` is extremely performant. This is a small benchmark on 3.5k lines
of code with only three linters:

``` r
library(bench)
library(lintr)
library(flint, warn.conflicts = FALSE)

file <- system.file("bench/test.R", package = "flint")

bench::mark(
  lintr::lint(file, linters = list(any_duplicated_linter(), any_is_na_linter(), matrix_apply_linter())),
  flint::lint(file, linters = c("any_duplicated", "any_na", "matrix_apply"), open = FALSE),
  check = FALSE
)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 2 × 6
#>   expression                            min  median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                        <bch:t> <bch:t>     <dbl> <bch:byt>    <dbl>
#> 1 "lintr::lint(file, linters = lis…   3.01s   3.01s     0.332  314.34MB     9.63
#> 2 "flint::lint(file, linters = c(\… 59.82ms 69.06ms    13.5      6.61MB     1.93
```

One can also experiment with `flint::lint_text()`:

``` r
lint_text("
any(is.na(x))
any(duplicated(y))
")
#> Original code: any(is.na(x)) 
#> Suggestion: anyNA(x) is better than any(is.na(x)). 
#> 
#> Original code: any(duplicated(y)) 
#> Suggestion: anyDuplicated(x, ...) > 0 is better than any(duplicated(x), ...).
```
