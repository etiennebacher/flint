
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tinylint

`tinylint` is a small R package to detect lints in R code and optionally
replace them.

- Lint detections with `lint()`
- Automatic replacement of lints with `fix()`
- Compatibility with `{lintr}` rules
- Extremely fast
- Low-dependency

`tinylint` is powered by
[`astgrepr`](https://github.com/etiennebacher/astgrepr/), which is
itself built on the Rust crate
[`ast-grep`](https://ast-grep.github.io/).

## Usage

Start by setting up `tinylint` with `tinylint::setup_tinylint()`. This
stores a set of rules in `inst/tinylint/rules`. You can then extend
those rules if you want more control.

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

`tinylint` is extremely performant. This is a small benchmark on 3.5k
lines of code with only three linters:

``` r
library(bench)
library(lintr)
library(tinylint, warn.conflicts = FALSE)

file <- system.file("bench/test.R", package = "tinylint")

bench::mark(
  lintr::lint(file, linters = list(any_duplicated_linter(), any_is_na_linter(), matrix_apply_linter())),
  tinylint::lint(file, linters = c("any_duplicated", "any_na", "matrix_apply"), open = FALSE),
  check = FALSE
)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 2 × 6
#>   expression                             min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>                          <bch:> <bch:>     <dbl> <bch:byt>    <dbl>
#> 1 "lintr::lint(file, linters = list(…   2.7s   2.7s     0.371  314.34MB    10.7 
#> 2 "tinylint::lint(file, linters = c(… 61.1ms 84.9ms    12.3      7.03MB     5.26
```

One can also experiment with `tinylint::lint_text()`:

``` r
lint_text("any(duplicated(x))")
#> Original code: any(duplicated(x)) 
#> Suggestion: anyDuplicated(x, ...) > 0 is better than any(duplicated(x), ...).
```
