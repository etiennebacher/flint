test_that("no lints found message works", {
  skip_if_not_installed("withr")
  withr::local_envvar(list(TESTTHAT = FALSE, GITHUB_ACTIONS = FALSE))
  dest <- tempfile(fileext = ".R")
  cat("1 + 1", file = dest)
  expect_snapshot(invisible(lint(dest)))
})

test_that("found lint message works when no lint can be fixed", {
  skip_if_not_installed("withr")
  withr::local_envvar(list(TESTTHAT = FALSE, GITHUB_ACTIONS = FALSE))
  temp_dir <- withr::local_tempdir()
  dest <- withr::local_tempfile(fileext = ".R", tmpdir = temp_dir)
  cat("x <<- 1", file = dest)
  expect_snapshot(invisible(lint(temp_dir)))
})

test_that("found lint message works when lint can be fixed", {
  skip_if_not_installed("withr")
  withr::local_envvar(list(TESTTHAT = FALSE, GITHUB_ACTIONS = FALSE))
  temp_dir <- withr::local_tempdir()
  dest <- withr::local_tempfile(fileext = ".R", tmpdir = temp_dir)
  cat("1 + 1\nany(is.na(1))\nany(duplicated(x))", file = dest)
  expect_snapshot(invisible(lint(temp_dir)))

  dest2 <- withr::local_tempfile(fileext = ".R", tmpdir = temp_dir)
  cat("1 + 1\nany(is.na(1))", file = dest)
  cat("any(duplicated(x))", file = dest2)
  expect_snapshot(invisible(lint(temp_dir)))
})

test_that("no fixes needed message works", {
  skip_if_not_installed("withr")
  withr::local_envvar(list(TESTTHAT = FALSE, GITHUB_ACTIONS = FALSE))
  dest <- tempfile(fileext = ".R")
  cat("1 + 1", file = dest)
  expect_snapshot(fix(dest))
})

test_that("fix needed message works", {
  skip_if_not_installed("withr")
  withr::local_envvar(list(TESTTHAT = FALSE, GITHUB_ACTIONS = FALSE))
  temp_dir <- withr::local_tempdir()
  dest <- withr::local_tempfile(fileext = ".R", tmpdir = temp_dir)
  cat("1 + 1\nany(is.na(1))\nany(duplicated(x))", file = dest)
  expect_snapshot(fix(temp_dir))

  dest2 <- withr::local_tempfile(fileext = ".R", tmpdir = temp_dir)
  cat("1 + 1\nany(is.na(1))", file = dest)
  cat("any(duplicated(x))", file = dest2)
  expect_snapshot(fix(temp_dir, force = TRUE))
})
