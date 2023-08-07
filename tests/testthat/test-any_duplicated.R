lint_message <- "anyDuplicated(x, ...) > 0 is better than any(duplicated(x), ...)."

test_that("any_duplicated_linter skips allowed usages", {
  linter <- NULL

  expect_lint("x <- any(y)", NULL, linter)
  expect_lint("y <- duplicated(z)", NULL, linter)
})

test_that("any_duplicated_linter blocks simple disallowed usages", {
  linter <- NULL

  expect_lint(
    "any(duplicated(x))",
    lint_message,
    NULL
  )

  expect_lint(
    "any(duplicated(foo(x)))",
    lint_message,
    NULL
  )

  expect_lint("any(duplicated(y), b)", lint_message, linter)
  expect_lint("any(b, duplicated(y))", lint_message, linter)

  # na.rm doesn't really matter for this since duplicated can't return NA
  expect_lint(
    "any(duplicated(x), na.rm = TRUE)",
    lint_message,
    NULL
  )

  # also catch nested usage
  expect_lint(
    "foo(any(duplicated(x)))",
    lint_message,
    NULL
  )
})

lint_message <- "anyDuplicated(x) == 0L is better than length(unique(x)) == length(x)."

test_that("any_duplicated_linter catches length(unique()) equivalencies too", {
  # non-matches
  ## different variable
  expect_lint("length(unique(x)) == length(y)", NULL, NULL)
  ## different table
  expect_lint("length(unique(DF$x)) == nrow(DT)", NULL, NULL)
  expect_lint("length(unique(l1$DF$x)) == nrow(l2$DF)", NULL, NULL)

  # lintable usage
  expect_lint(
    "length(unique(x)) == length(x)",
    lint_message,
    NULL
  )
  # argument order doesn't matter
  expect_lint(
    "length(x) == length(unique(x))",
    lint_message,
    NULL
  )
  # TODO:
  # # nrow-style equivalency
  # expect_lint(
  #   "nrow(DF) == length(unique(DF$col))",
  #   rex::rex("anyDuplicated(DF$col) == 0L is better than length(unique(DF$col)) == nrow(DF)"),
  #   NULL
  # )
  # expect_lint(
  #   "nrow(DF) == length(unique(DF[['col']]))",
  #   rex::rex("anyDuplicated(DF$col) == 0L is better than length(unique(DF$col)) == nrow(DF)"),
  #   NULL
  # )
  # # match with nesting too
  # expect_lint(
  #   "nrow(l$DF) == length(unique(l$DF[['col']]))",
  #   rex::rex("anyDuplicated(DF$col) == 0L is better than length(unique(DF$col)) == nrow(DF)"),
  #   NULL
  # )

  # !=, <, and > usages are all alternative ways of writing a test for dupes
  #   technically, the direction of > / < matter, but writing
  #   length(unique(x)) > length(x) doesn't seem like it would ever happen.
  expect_lint(
    "length(unique(x)) != length(x)",
    rex::rex("Use anyDuplicated(x) != 0"),
    NULL
  )
  # expect_lint(
  #   "length(unique(x)) < length(x)",
  #   rex::rex("anyDuplicated(x) == 0L is better than length(unique(x)) == length(x)"),
  #   NULL
  # )
  # expect_lint(
  #   "length(x) > length(unique(x))",
  #   rex::rex("anyDuplicated(x) == 0L is better than length(unique(x)) == length(x)"),
  #   NULL
  # )

  # TODO(michaelchirico): try and match data.table- and dplyr-specific versions of
  #   this, e.g. DT[, length(unique(col)) == .N] or
  #   > DT %>% filter(length(unique(col)) == n())
})

test_that("any_duplicated_linter catches expression with two types of lint", {
  expect_lint(
    "table(any(duplicated(x)), length(unique(x)) != length(x)",
    "anyDuplicated",
    NULL
  )
})
