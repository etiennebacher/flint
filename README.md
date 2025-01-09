
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

`flint` is powered by
[`astgrepr`](https://github.com/etiennebacher/astgrepr/), which is
itself built on the Rust crate
[`ast-grep`](https://ast-grep.github.io/).

## Installation

``` r
install.packages('flint', repos = c('https://etiennebacher.r-universe.dev', 'https://cloud.r-project.org'))
```

**Note:** using `remotes::install_github()`,
`devtools::install_github()`, or `pak::pak()` without specifying the
R-universe repo will require you to [setup
Rust](https://www.rust-lang.org/tools/install) to build the package.

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
#> Rule ID: any_na-1 
#> 
#> Original code: any(duplicated(y)) 
#> Suggestion: anyDuplicated(x, ...) > 0 is better than any(duplicated(x), ...). 
#> Rule ID: any_duplicated-1
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

## Real-life examples

I tested `flint` on several packages while developing it. I proposed
some pull requests for those packages. Here are a few:

- `ggplot2`:
  [\#6050](https://github.com/tidyverse/ggplot2/pull/6050/files) and
  [\#6051](https://github.com/tidyverse/ggplot2/pull/6051/files)
- `marginaleffects`:
  [\#1171](https://github.com/vincentarelbundock/marginaleffects/pull/1171/files)
  and
  [\#1177](https://github.com/vincentarelbundock/marginaleffects/pull/1177/files)
- `targets`:
  [\#1325](https://github.com/ropensci/targets/pull/1325/files)
- `tinytable`:
  [\#325](https://github.com/vincentarelbundock/tinytable/pull/325/files)
- `usethis`: [\#2048](https://github.com/r-lib/usethis/pull/2048/files)

Except for some manual tweaks when the replacement was wrong (I was
testing `flint` after all), all changes were generated by
`flint::fix_package()` or `flint::fix_dir(<dirname>)`.

## Comparison with existing tools

The most used tool for lints detection in R is `lintr`. However,
`lintr`’s performance is not optimal when it is applied on medium to
large packages. Also, `lintr` cannot perform automatic replacement of
lints.

`styler` is a package to clean code by fixing indentation and other
things, but doesn’t perform code replacement based on lints.

`flint` is quite performant. This is a small benchmark on 3.5k lines of
code with a few linters:

``` r
file <- system.file("bench/test.R", package = "flint")

bench::mark(
  lintr = lintr::lint(
    file,
    linters = list(
      lintr::any_duplicated_linter(), lintr::any_is_na_linter(),
      lintr::matrix_apply_linter(), lintr::function_return_linter(),
      lintr::lengths_linter(), lintr::T_and_F_symbol_linter(),
      lintr::undesirable_function_linter(), lintr::expect_length_linter()
    )
  ),
  flint = flint::lint(
    file,
    linters = list(
      flint::any_duplicated_linter(), flint::any_is_na_linter(),
      flint::matrix_apply_linter(), flint::function_return_linter(),
      flint::lengths_linter(), flint::T_and_F_symbol_linter(),
      flint::undesirable_function_linter(), flint::expect_length_linter()
    ),
    verbose = FALSE,
    open = FALSE
  ),
  check = FALSE
)
#> Warning: Some expressions had a GC in every iteration;
#> so filtering is disabled.
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>
#> 1 lintr         3.36s    3.36s     0.298  317.43MB
#> 2 flint      183.07ms 186.15ms     5.39     1.73MB
#> # ℹ 1 more variable: `gc/sec` <dbl>
```

## Contributing

Did you find some bugs or some errors in the documentation? Do you want
`flint` to support more rules?

Take a look at the [contributing
guide](https://flint.etiennebacher.com/CONTRIBUTING.html) for
instructions on bug report and pull requests.

## Acknowledgements

The website theme was heavily inspired by Matthew Kay’s `ggblend`
package: <https://mjskay.github.io/ggblend/>.
