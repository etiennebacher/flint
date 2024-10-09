test_that("lint() works with multiple paths", {
  create_local_package()
  cat("x = 1", file = "R/foo.R")
  cat("x = 1", file = "R/foo2.R")
  expect_equal(nrow(lint(c("R/foo.R", "R/foo2.R"))), 2)
})

test_that("fix() works with multiple paths", {
  create_local_package()
  cat("x = 1", file = "R/foo.R")
  cat("x = 1", file = "R/foo2.R")
  fix(c("R/foo.R", "R/foo2.R"), force = TRUE)
  expect_true(grepl("x <- 1", readLines("R/foo.R"), fixed = TRUE))
  expect_true(grepl("x <- 1", readLines("R/foo2.R"), fixed = TRUE))
})
