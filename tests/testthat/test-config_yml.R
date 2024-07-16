test_that("config.yml is taken into account", {
  create_local_package()
  setup_flint()

  cat("a = 1", file = "R/foo.R")
  expect_equal(nrow(lint()), 1)

  # Only keep one linter, not the one about assignment symbols
  cat("keep:\n  - class_equals", file = "flint/config.yml")
  expect_equal(nrow(lint()), 0)

  # commented out linter not taken into account
  cat("keep:\n  - class_equals\n#  - equal_assignment", file = "flint/config.yml")
  expect_equal(nrow(lint()), 0)
})

test_that("config.yml errors when it doesn't contain any rule", {
  create_local_package()
  setup_flint()

  # Only keep one linter, not the one about assignment symbols
  cat("keep:", file = "flint/config.yml")
  expect_error(lint(), "doesn't contain any rule")

  # commented out linter not taken into account
  cat("keep:\n#  - equal_assignment", file = "flint/config.yml")
  expect_error(lint(), "doesn't contain any rule")
})
