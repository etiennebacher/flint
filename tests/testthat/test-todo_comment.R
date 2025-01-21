test_that("returns the correct linting", {
  linter <- todo_comment_linter()
  lint_msg <- "Remove TODO comments."

  expect_lint('a <- "you#need#to#fixme"', NULL, linter)
  expect_lint("# tadatodo", NULL, linter)
  expect_lint("# something todo", NULL, linter)
  expect_lint("#todo", lint_msg, linter)
  expect_lint("cat(x) ### fixme", lint_msg, linter)
  expect_lint(
    "x <- \"1.0\n2.0 #FIXME\n3 #TODO 4\"; y <- 2; z <- 3 # todo later",
    lint_msg,
    linter
  )
  expect_lint(
    trim_some(
      "
      function() {
        # TODO
        function() {
          # fixme
        }
      }
    "
    ),
    lint_msg,
    linter
  )
})
