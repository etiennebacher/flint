# flint (development version)

## New features

* New linters: `expect_named`, `numeric_leading_zero`, `outer_negation`, 
  `redundant_ifelse`, `undesirable_function`, `unreachable_code`.
  
* `fix_dir()`, `fix_package()`, `lint_dir()`, `lint_package()` now have arguments
  to exclude paths, linters, and use cache.
  
* Removed `browser` linter (it is now part of `undesriable_function`).

* Add support for a `flint/config.yml` file that contains the list of linters
  to use so that one doesn't need to constantly specify them in `lint()` or `fix()`.
 

## Bug fixes 

* Do not lint for `x %in% class(y)` where `x` is not a string as this is [not
  equivalent in some cases](https://github.com/vincentarelbundock/marginaleffects/pull/1171#issuecomment-2228497287). Thanks Vincent Arel-Bundock for spotting this.


# flint 0.0.1

* First Github release.
