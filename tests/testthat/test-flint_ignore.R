test_that("flint-ignore works for a single line", {
  expect_lint("# flint-ignore\nany(duplicated(x))", NULL, NULL)
  expect_fix("# flint-ignore\nany(duplicated(x))", character(0))
})

test_that("also ignore lines that have # nolint for compatibility", {
  expect_lint("# nolint\nany(duplicated(x))", NULL, NULL)
  expect_fix("# nolint\nany(duplicated(x))", character(0))
})

test_that("flint-ignore doesn't ignore more than one line", {
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

test_that("flint-ignore-start and end work", {
  expect_lint(
    "# flint-ignore-start\nany(duplicated(x))\nany(duplicated(y))\n# flint-ignore-end",
    NULL,
    NULL
  )
  expect_fix(
    "# flint-ignore-start\nany(duplicated(x))\nany(duplicated(y))\n# flint-ignore-end",
    character(0)
  )
})

test_that("flint-ignore-start and end error if mismatch", {
  expect_error(
    lint_text("# flint-ignore-start\nany(duplicated(x))\nany(duplicated(y))"),
    "Mismatch: the number of `start` patterns (1) and of `end` patterns (0) must be equal.",
    fixed = TRUE
  )
  expect_error(
    lint_text("any(duplicated(x))\nany(duplicated(y))\n# flint-ignore-end"),
    "Mismatch: the number of `start` patterns (0) and of `end` patterns (1) must be equal.",
    fixed = TRUE
  )
})
