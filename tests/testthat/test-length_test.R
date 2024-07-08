test_that("skips allowed usages", {
  linter <- length_test_linter()

  expect_lint("length(x) > 0", NULL, linter)
  expect_lint("length(DF[key == val, cols])", NULL, linter)
})

test_that("blocks simple disallowed usages", {
  linter <- length_test_linter()
  lint_msg_stub <- "Checking the length of a logical vector is likely a mistake"

  expect_lint("length(x == 0)", lint_msg_stub, linter)
  expect_lint("length(x == y)", lint_msg_stub, linter)
  expect_lint("length(x + y == 2)", lint_msg_stub, linter)
})

# TODO: this works but the operator is not replaced accordingly with fix()
# test_that("blocks simple disallowed usages", {
#   linter <- length_test_linter()
#   lint_msg_stub <- "Checking the length of a logical vector is likely a mistake"

  # expect_lint("length(x != 0)", lint_msg_stub, linter)
  # expect_lint("length(x >= 0)", lint_msg_stub, linter)
  # expect_lint("length(x <= 0)", lint_msg_stub, linter)
  # expect_lint("length(x > 0)", lint_msg_stub, linter)
  # expect_lint("length(x < 0)", lint_msg_stub, linter)
  # expect_lint("length(x < 0)", lint_msg_stub, linter)
# })


test_that("fix works", {
  expect_fix("length(x == 0)", "length(x) == 0")

  # expect_fix("length(x != 0)", "length(x) != 0")
  # expect_fix("length(x >= 0)", "length(x) >= 0")
  # expect_fix("length(x <= 0)", "length(x) <= 0")
  # expect_fix("length(x > 0)", "length(x) > 0")
  # expect_fix("length(x < 0)", "length(x) < 0")
})
