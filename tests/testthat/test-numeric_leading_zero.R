test_that("numeric_leading_zero_linter skips allowed usages", {
  linter <- numeric_leading_zero_linter()

  expect_lint("a <- 0.1", NULL, linter)
  expect_lint("b <- -0.2", NULL, linter)
  expect_lint("c <- 3.0", NULL, linter)
  expect_lint("d <- 4L", NULL, linter)
  expect_lint("e <- TRUE", NULL, linter)
  expect_lint("f <- 0.5e6", NULL, linter)
  expect_lint("g <- 0x78", NULL, linter)
  expect_lint("h <- 0.9 + 0.1i", NULL, linter)
  expect_lint("h <- 0.9+0.1i", NULL, linter)
  expect_lint("h <- 0.9 - 0.1i", NULL, linter)
  expect_lint("i <- 2L + 3.4i", NULL, linter)
})

test_that("numeric_leading_zero_linter blocks simple disallowed usages", {
  linter <- numeric_leading_zero_linter()
  lint_msg <- "Include the leading zero for fractional numeric constants."

  expect_lint("a <- .1", lint_msg, linter)
  expect_lint("b <- -.2", lint_msg, linter)
  expect_lint("c <- .3 + 4.5i", lint_msg, linter)
  expect_lint("d <- 6.7 + .8i", lint_msg, linter)
  expect_lint("d <- 6.7+.8i", lint_msg, linter)
  expect_lint("e <- .9e10", lint_msg, linter)
})

test_that("fix works", {
  expect_snapshot(fix_text("0.1 + .22-0.3-.2"))
  expect_snapshot(fix_text("d <- 6.7 + .8i"))
  expect_snapshot(fix_text(".7i + .2 + .8i"))
  expect_snapshot(fix_text("'some text .7'"))
})
