test_that("expect_named_linter skips allowed usages", {
  linter <- expect_named_linter()

  # colnames(), rownames(), and dimnames() tests are not equivalent
  expect_lint("expect_equal(colnames(x), 'a')", NULL, linter)
  expect_lint("expect_equal(rownames(x), 'a')", NULL, linter)
  expect_lint("expect_equal(dimnames(x), 'a')", NULL, linter)

  expect_lint("expect_equal(nrow(x), 4L)", NULL, linter)
  # NB: also applies to tinytest, but it's sufficient to test testthat
  expect_lint("testthat::expect_equal(nrow(x), 4L)", NULL, linter)

  # only check the first argument. yoda tests in the second argument will be
  #   missed, but there are legitimate uses of names() in argument 2
  expect_lint("expect_equal(colnames(x), names(y))", NULL, linter)
})

test_that("expect_equal(names(x), NULL) lints with expect_null, not expect_named", {
  linter_named <- expect_named_linter()
  linter_null <- expect_null_linter()

  expect_lint("expect_equal(names(xs), NULL)", NULL, linter_named)
  expect_lint("expect_identical(names(xs), NULL)", NULL, linter_named)

  expect_lint("expect_equal(names(xs), NULL)", "expect_null(x) is better", linter_null)
  expect_lint("expect_identical(names(xs), NULL)", "expect_null(x) is better", linter_null)
})

test_that("expect_named_linter blocks simple disallowed usages", {
  linter <- expect_named_linter()
  lint_msg <- "expect_named(x, n) is better than expect_equal(names(x), n)"

  expect_lint("expect_equal(names(x), 'a')", lint_msg, linter)
  # TODO: don't understand this one
  # expect_lint("testthat::expect_equal(names(DF), names(old))", lint_msg, linter)
  expect_lint("expect_equal('a', names(x))", lint_msg, linter)
})

test_that("expect_named_linter blocks expect_identical usage as well", {
  expect_lint(
    "expect_identical(names(x), 'a')",
    "expect_named(x, n) is better than expect_identical(names(x), n)",
    expect_named_linter()
  )
})

test_that("fix works for expect_named", {
  # basic
  expect_snapshot(fix_text("expect_identical(names(x), c('a', 'b'))"))
  expect_snapshot(fix_text("expect_identical('a', names(x))"))
  expect_snapshot(fix_text("expect_equal('a', names(x))"))
  expect_snapshot(fix_text("expect_equal(names(x), c('a', 'b'))"))

  # double quote
  expect_snapshot(fix_text("expect_identical(names(x), c(\"a\", \"b\"))"))

  # with testthat::
  expect_snapshot(fix_text("testthat::expect_equal('a', names(x))"))

  # only fix with expect_null(), not expect_named()
  expect_snapshot(fix_text("expect_identical(names(xs), NULL)"))
})
