test_that("config.yml is taken into account", {
  create_local_package()
  setup_flint()

  cat("a = 1", file = "R/foo.R")
  expect_equal(nrow(lint()), 1)

  # Only keep one linter, not the one about assignment symbols
  cat("keep:\n  - class_equals", file = "flint/config.yml")
  expect_equal(nrow(lint()), 0)
})
