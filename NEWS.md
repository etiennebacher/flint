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
