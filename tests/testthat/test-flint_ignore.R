test_that("flint correctly ignores lines", {
  expect_lint("# flint-ignore\nany(duplicated(x))", NULL, NULL)
  expect_fix("# flint-ignore\nany(duplicated(x))", character(0))
})

test_that("flint correctly ignores lines", {
  expect_lint(
    "# flint-ignore\nany(duplicated(x))\nany(duplicated(y))",
    "anyDuplicated(x, ...) > 0 is better than any(duplicated(x), ...).",
    NULL
  )
  expect_fix(
    "# flint-ignore\nany(duplicated(x))\nany(duplicated(y))",
    "# flint-ignore\nany(duplicated(x))\nanyDuplicated(y) > 0"
  )
})
