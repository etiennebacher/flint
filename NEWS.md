# flint 0.0.5

## New features

* Deactivated `absolute_path_linter` in default use as there are too many false
  positives.
* New linter `unnecessary_nesting_linter`.
* Add messages for `lint()` and `fix()` showing the number of files checked, lints
  found and/or fixed.
  
## Bug fixes

* More robust detection of allowed usage of `T` and `F` in formulas.
* Use the pipe in the replacement for `lengths_linter` if it was already present
  in code.
  
## Misc

* Add links to `lintr` documentation in the manual pages.

# flint 0.0.4

## New features

* New linters: `for_loop_index`,`missing_argument`.
* `fix()` has a new argument `force` (`FALSE` by default). This is useful if Git
  was not detected, `fix()` would modify several files, and it is run in a 
  non-interactive context. In this situation, set `force = TRUE` to apply the 
  fixes anyway.
* Add `cli` messages informing how many files are checked, and how many contain
  lints (for `lint_*` functions) or were modified (for `fix_*` functions).
* Better coverage of the `length_test` linter.

## Bug fixes

* Allow usage of `T` and `F` in formulas (#33).

# flint 0.0.3

## New features

* New linters: `absolute_path`, `duplicate_argument`, `empty_assignment`, 
  `expect_length`, `expect_not`, `expect_null`, `expect_true_false`, 
  `expect_type`, `literal_coercion`, `nested_ifelse`, `sort`, 
  `undesirable_operator`.
* Added a contributing guide.
* Better docs for `fix()` and its variants.
* Using `fix()` on several files without using Git now opens an interactive
  menu so that the user confirms they want to run `fix()`. In case of 
  non-interactive use, this errors.
* Ignore lines following `# nolint` for compatibility with `lintr`.

## Bug fixes

* Fix a few false positives (#23, #24, #27).

# flint 0.0.2

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
