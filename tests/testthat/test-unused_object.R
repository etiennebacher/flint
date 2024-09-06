test_that("unused_object_linter skips allowed usages", {
  linter <- unused_object_linter()

  expect_lint("x <- any(y)\nx", NULL, linter)
  expect_lint("x <- any(y)\n 1 + 1\nx", NULL, linter)
})

test_that("unused_object_linter blocks simple usage", {
  linter <- unused_object_linter()
  msg <- "Object x is unused in the rest of the code"

  expect_lint("x <- any(y)", msg, linter)
  expect_lint("x <- any(y)\nprint(y)", msg, linter)
})

test_that("unused_object_linter works with nested usage", {
  linter <- unused_object_linter()
  msg <- "Object x is unused in the rest of the code"

  code <- "
  x <- 1
  y <- function() {
    print(x)
  }
  "
  expect_lint(code, NULL, linter)

  code <- "
  x <- 1
  y <- function() {
    print('a')
  }
  "
  expect_lint(code, msg, linter)
})
