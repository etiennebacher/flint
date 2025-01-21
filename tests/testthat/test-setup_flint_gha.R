test_that("setup_flint_gha basic use works", {
  create_local_package()
  expect_no_error(suppressMessages(setup_flint_gha()))
  expect_true(file.exists(".github/workflows/flint.yaml"))

  expect_error(setup_flint_gha(), "file already exists")
  expect_no_error(setup_flint_gha(overwrite = TRUE))
})
