test_that("lint success message works", {
  dest <- tempfile(fileext = ".R")
  cat("1 + 1", file = dest)
  expect_message(lint(dest), "No lints detected.")
})

test_that("fix success message works", {
  dest <- tempfile(fileext = ".R")
  cat("1 + 1", file = dest)
  expect_message(fix(dest), "No fixes needed.")
})
