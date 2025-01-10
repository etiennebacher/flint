# flint (development version)

## New features

* New linter `stopifnot_all_linter()` to detect calls to `stopifnot(all(...))`
  since the `all()` is unnecessary. This has an automatic fix available.

* New linter `list_comparison_linter()` to detect a comparison with a list,
  e.g. `lapply(x, sum) > 10`. No automatic fix available.

* Line breaks are removed from multi-line messages reported by `lint*` 
  functions. 

* `matrix_apply_linter` now detects when `1L` and `2L` are used in the `MARGIN`
  argument.

* `any_is_na_linter` now reports cases like `NA %in% x`, and can fix them to be
  `anyNA(x)` instead.

## Bug fixes

* `library_call_linter` no longer reports cases where `library()` calls are
  wrapped in `suppressPackageStartupMessages()`.

* Nested fixes no longer overlap. The `fix*()` functions now run several times
  on the files containing nested fixes until there are no more fixes to apply. 
  This can be deactivated to run only once per file by adding `rerun = FALSE`
  (#61).

* `any_is_na_linter` wrongly reported cases like `any(is.na(x), y)`. Those are
  no longer reported.

# flint 0.1.2

## New features

* `sample(n, m)` is now reported and can be rewritten as `sample.int(n, m)` 
  when `n` is a literal integer.

## Bug fixes

* Rule names have been harmonized to use a dash instead of underscore, e.g.
  `any_duplicated-1` instead of `any_duplicated_1`.

* Replacement of `redundant_ifelse_linter` of the form 
  `ifelse(cond, FALSE, TRUE)` now works (#57).

* `absolute_path_linter` was deactivated in 0.0.5 but was still reported. It is
  now properly ignored.

* Code like `expect_equal(typeof(x), 'class')` was modified twice by
  `expect_identical_linter` and `expect_type_linter`, which lead to a wrong
  rewrite. It is now replaced by `expect_type(x, 'class')`.

# flint 0.1.1

## Bug fixes

* `fix()` and `lint()` now work correctly when several paths are passed.

* `fix_package()` and `lint_package()` used all R files present from the root 
  path, even those in folders that are not typical of an R package.

* `fix_dir()` and `fix_package()` now have the arguments `force` and `verbose`,
  like `fix()`.

# flint 0.1.0

## New features

* New linters: `rep_len_linter()`, `sample_int_linter()` and 
  `which_grepl_linter()`.
* Add a menu or an error if `fix()` and its variants would change some unstaged
  files.
* `update_flint()` now updates all rules and doesn't only add new rules anymore.

# flint 0.0.9

## New features

* New linters: `condition_message_linter()` and `expect_identical_linter()`.
* Rewrote vignette on adding new rules.
* `setup_flint()` now puts built-in rules in `flint/rules/builtin`.


# flint 0.0.8

## New features

* New linters: `expect_comparison_linter` and `package_hooks_linter`.
* Add argument `verbose` to `lint_package()` and `lint_dir()`.
* Better message when no lints can be fixed.
* Add one case in `seq_linter` where `seq_len(x)` is faster than `seq(1, x)`.
* Better handling of `exclude_path`.

# flint 0.0.7

## New features

* Set up the Github Actions workflow for `flint` (#22).
* New linters `function_return_linter` and `todo_comment_linter`.
* Better support for `library_call_linter`.
* Add argument `overwrite` to `setup_flint_gha()`.


# flint 0.0.6

## New features

* New linter `redundant_equals_linter`.
* Better support for `matrix_apply_linter`.

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
