
<!-- README.md is generated from README.Rmd. Please edit that file -->

# flint

<!-- badges: start -->

[![R-CMD-check](https://github.com/etiennebacher/flint/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/etiennebacher/flint/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`flint` is a small R package to find and replace lints in R code.

- Lints detection with `lint()`
- Automatic replacement of lints with `fix()`
- Compatibility with (some) `{lintr}` rules
- Fast
- Low-dependency

`flint` is powered by
[`astgrepr`](https://github.com/etiennebacher/astgrepr/), which is
itself built on the Rust crate
[`ast-grep`](https://ast-grep.github.io/).

## Installation

### Windows or macOS

``` r
install.packages(
  'flint', 
  repos = c('https://etiennebacher.r-universe.dev', getOption("repos"))
)
```

### Linux

``` r
install.packages(
  'flint', 
  repos = c('https://etiennebacher.r-universe.dev/bin/linux/jammy/4.3', getOption("repos"))
)
```

## Usage

Optional setup:

- `setup_flint()`: creates the folder `flint` and populates it with
  built-in rules as well as a cache file. You can modify those rules or
  add new ones if you want more control.

You can use `flint` as-is, without any setup. However, running
`setup_flint()` enables the use of caching, meaning that the subsequent
runs will be faster. It is also gives you a place where you can store
custom rules for your project/package.

The everyday usage consists of two functions:

- `lint()` looks for lints in R files;
- `fix()` looks for lints in R files and automatically applies their
  replacement (if any).

One can also experiment with `flint::lint_text()` and
`flint::fix_text()`:

``` r
flint::lint_text("
any(is.na(x))
any(duplicated(y))
")
#> Original code: any(is.na(x)) 
#> Suggestion: anyNA(x) is better than any(is.na(x)). 
#> 
#> Original code: any(duplicated(y)) 
#> Suggestion: anyDuplicated(x, ...) > 0 is better than any(duplicated(x), ...).
flint::fix_text("
any(is.na(x))
any(duplicated(y))
")
#> Old code:
#> any(is.na(x))
#> any(duplicated(y))
#> 
#> New code:
#> anyNA(x)
#> anyDuplicated(y) > 0
```

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
file <- system.file("bench/test.R", package = "flint")

bench::mark(
  lintr = lintr::lint(
    file, linters = list(lintr::any_duplicated_linter(), lintr::any_is_na_linter(),
                         lintr::matrix_apply_linter())
  ),
  flint = flint::lint(
    file, linters = list(flint::any_duplicated_linter(), flint::any_is_na_linter(),
                         flint::matrix_apply_linter()), 
    open = FALSE
  ),
  check = FALSE
)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 lintr         3.01s    3.01s     0.333  318.44MB    11.0 
#> 2 flint       64.13ms  73.24ms    13.3      1.09MB     1.90
```
