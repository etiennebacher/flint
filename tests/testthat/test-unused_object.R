test_that("unused_object_linter skips allowed usages", {
  linter <- unused_object_linter()

  expect_lint("x <- any(y)\nx", NULL, linter)
  expect_lint("x <- any(y)\n 1 + 1\nx", NULL, linter)

  # functions are not linted: they could be used in other files
  expect_lint("x <- function() 1 + 1", NULL, linter)
})

test_that("unused_object_linter blocks simple usage", {
  linter <- unused_object_linter()
  msg <- "Object x is unused in the rest of the code"

  expect_lint("x <- any(y)", msg, linter)
  expect_lint("x <- any(y)\nprint(y)", msg, linter)
  expect_lint("x = any(y)", msg, linter)
  expect_lint("x = any(y)\nprint(y)", msg, linter)
})

test_that("unused_object_linter works when object is used in function", {
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

test_that("unused_object_linter works when object is used in loop", {
  linter <- unused_object_linter()
  msg <- "Object x is unused in the rest of the code"

  code <- "
  x <- 1
  for (i in x) print('a')
  "
  expect_lint(code, NULL, linter)

  code <- "
  x <- 1
  if (i in x) print('a')
  "
  expect_lint(code, NULL, linter)

  code <- "
  x <- 1
  while (x < 1) print('a')
  "
  expect_lint(code, NULL, linter)

  # ===============================

  code <- "
  x <- 1
  for (i in 1:2) print('a')
  "
  expect_lint(code, msg, linter)

  code <- "
  x <- 1
  if (i in 1:2) print('a')
  "
  expect_lint(code, msg, linter)

  code <- "
  x <- 1
  while (2 < 1) print('a')
  "
  expect_lint(code, msg, linter)
})
