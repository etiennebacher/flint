test_that("equals_na_linter skips allowed usages", {
  linter <- equals_na_linter()

  expect_lint("blah", NULL, linter)
  expect_lint("  blah", NULL, linter)
  expect_lint("  blah", NULL, linter)
  expect_lint("x == 'NA'", NULL, linter)
  expect_lint("x <- NA", NULL, linter)
  expect_lint("x <- NaN", NULL, linter)
  expect_lint("x <- NA_real_", NULL, linter)
  expect_lint("is.na(x)", NULL, linter)
  expect_lint("is.nan(x)", NULL, linter)
  expect_lint("x[!is.na(x)]", NULL, linter)

  # equals_na_linter should ignore strings and comments
  expect_lint("is.na(x) # do not flag x == NA if inside a comment", NULL, linter)
  expect_lint("lint_msg <- 'do not flag x == NA if inside a string'", NULL, linter)

  # nested NAs are okay
  expect_lint("x==f(1, ignore = NA)", NULL, linter)
})

skip_if_not_installed("tibble")
patrick::with_parameters_test_that(
  "equals_na_linter blocks disallowed usages for all combinations of operators and types of NAs",
  expect_lint(
    paste("x", operation, type_na),
    "Use is.na for comparisons to NA (not == or !=)",
    NULL
  ),
  .cases = tibble::tribble(
    ~.test_name,                ~operation, ~type_na,
    "equality, logical NA",     "==",       "NA",
    "equality, integer NA",     "==",       "NA_integer_",
    "equality, real NA",        "==",       "NA_real_",
    "equality, complex NA",     "==",       "NA_complex_",
    "equality, character NA",   "==",       "NA_character_",
    "inequality, logical NA",   "!=",       "NA",
    "inequality, integer NA",   "!=",       "NA_integer_",
    "inequality, real NA",      "!=",       "NA_real_",
    "inequality, complex NA",   "!=",       "NA_complex_",
    "inequality, character NA", "!=",       "NA_character_"
  )
)

test_that("equals_na_linter blocks disallowed usages in edge cases", {
  linter <- equals_na_linter()
  lint_msg <- "Use is.na for comparisons to NA (not == or !=)"

  # missing spaces around operators
  expect_lint("x==NA", lint_msg, linter)
  expect_lint("x!=NA", lint_msg, linter)

  # order doesn't matter
  expect_lint("NA == x", lint_msg, linter)

  # correct line number for multiline code
  expect_lint("x ==\nNA", lint_msg, linter)
})
