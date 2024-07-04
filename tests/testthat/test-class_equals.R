test_that("class_equals_linter skips allowed usages", {
  linter <- NULL

  expect_lint("class(x) <- 'character'", NULL, linter)
  expect_lint("class(x) = 'character'", NULL, linter)

  # proper way to test exact class
  expect_lint("identical(class(x), c('glue', 'character'))", NULL, linter)
  expect_lint("is_lm <- inherits(x, 'lm')", NULL, linter)
})

test_that("class_equals_linter blocks simple disallowed usages", {
  linter <- NULL
  lint_msg <- "use inherits"

  expect_lint("if (class(x) == 'character') stop('no')", lint_msg, linter)
  expect_lint("is_regression <- class(x) == 'lm'", lint_msg, linter)
  expect_lint("is_regression <- 'lm' == class(x)", lint_msg, linter)
})

test_that("class_equals_linter blocks usage of %in% for checking class", {
  linter <- NULL
  lint_msg <- "use inherits"

  expect_lint("if ('character' %in% class(x)) stop('no')", lint_msg, linter)
  expect_lint("if (class(x) %in% 'character') stop('no')", lint_msg, linter)
})

test_that("class_equals_linter blocks class(x) != 'klass'", {
  expect_lint(
    "if (class(x) != 'character') TRUE",
    "use inherits",
    NULL
  )
})

# as seen, e.g. in base R
test_that("class_equals_linter skips usage for subsetting", {
  linter <- NULL

  expect_lint("class(x)[class(x) == 'foo']", NULL, linter)

  # but not further nesting
  expect_lint(
    "x[if (class(x) == 'foo') 1 else 2]",
    "use inherits",
    linter
  )
})

test_that("lints vectorize", {
  lint_msg <- "use inherits"

  expect_lint(
    trim_some("{
      'character' %in% class(x)
      class(x) == 'character'
    }"),
    lint_msg,
    NULL
  )
})
