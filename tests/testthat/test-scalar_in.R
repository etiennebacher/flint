test_that("scalar_in_linter skips allowed usages", {
  linter <- scalar_in_linter()

  expect_lint("x %in% y", NULL, linter)
  expect_lint("y %in% c('a', 'b')", NULL, linter)
  expect_lint("c('a', 'b') %in% x", NULL, linter)
  expect_lint("z %in% 1:3", NULL, linter)
  # scalars on LHS are fine (often used as `"col" %in% names(DF)`)
  expect_lint("3L %in% x", NULL, linter)
  # this should be is.na(x), but it more directly uses the "always TRUE/FALSE, _not_ NA"
  #   aspect of %in%, so we delegate linting here to equals_na_linter()
  expect_lint("x %in% NA", NULL, linter)
  expect_lint("x %in% NA_character_", NULL, linter)
})

test_that("scalar_in_linter blocks simple disallowed usages", {
  linter <- scalar_in_linter()
  lint_msg <- "Use != or == to match length-1 scalars, not %in%."

  expect_lint("x %in% 1", lint_msg, linter)
  expect_lint("x %chin% 'a'", lint_msg, linter)
  expect_lint("x %notin% 1", lint_msg, linter)
})

test_that("scalar_in_linter blocks or skips based on configuration", {
  linter_default <- scalar_in_linter()

  lint_msg <- "Use != or == to match length-1 scalars, not %in%."

  # default
  expect_lint("x %in% 1", lint_msg, linter_default)
  expect_lint("x %notin% 1", lint_msg, linter_default)
  expect_lint("x %notin% y", NULL, linter_default)
})

test_that("fix works for scalar_in", {
  expect_snapshot(fix_text("x %in% 1"))
  expect_snapshot(fix_text("x %in% 'a'"))
})
