test_that("setup_flint works for packages", {
  create_local_package()
  expect_no_error(setup_flint())

  # TODO: test cache exists
  # expect_true(fs::file_exists("flint/"))
  expect_true(fs::dir_exists("flint/rules"))

  # lint
  cat("any(duplicated(x))", file = "R/foo.R")
  expect_equal(nrow(lint()), 1)

  # fix
  fix()
  expect_equal(
    readLines("R/foo.R", warn = FALSE),
    "anyDuplicated(x) > 0"
  )
})

test_that("setup_flint works for projects", {
  create_local_project()
  expect_no_error(setup_flint())

  # TODO: test cache exists
  # expect_true(fs::file_exists("flint/"))
  expect_true(fs::dir_exists("flint/rules"))

  # lint
  cat("any(duplicated(x))", file = "R/foo.R")
  expect_equal(nrow(lint()), 1)

  # fix
  fix()
  expect_equal(
    readLines("R/foo.R", warn = FALSE),
    "anyDuplicated(x) > 0"
  )
})
