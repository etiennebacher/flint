test_that("dirs and files are accepted", {
  create_local_project()
  fs::dir_create("R")
  cat("a <- 1", file = "R/lint.R")
  cat("a <- 1", file = "R/fix.R")
  expect_no_error(lint("R", exclude_path = "R/lint.R"))
  expect_no_error(lint(c("R/lint.R", "R/fix.R"), exclude_path = "R")) # no file remaining

  expect_no_error(fix("R", exclude_path = "R/lint.R"))
  expect_no_error(fix(c("R/lint.R", "R/fix.R"), exclude_path = "R")) # no file remaining
})

test_that("error on non existing path", {
  expect_error(
    lint("abcdefghij.R"),
    "The following files don't exist: abcdefghij.R",
    fixed = TRUE
  )
  expect_error(
    fix("abcdefghij.R"),
    "The following files don't exist: abcdefghij.R",
    fixed = TRUE
  )

  # Different printing for > 3 files
  expect_error(
    lint(c("abcde.R", "abcde2.R", "abcde3.R", "abcde4.R")),
    "The following files don't exist (only first 3 shown): abcde.R, abcde2.R, abcde3.R",
    fixed = TRUE
  )
  expect_error(
    fix(c("abcde.R", "abcde2.R", "abcde3.R", "abcde4.R")),
    "The following files don't exist (only first 3 shown): abcde.R, abcde2.R, abcde3.R",
    fixed = TRUE
  )
})

test_that("error on non-R files", {
  expect_error(
    lint("abcdefghij.py"),
    "Files must have a .r or .R extension.",
    fixed = TRUE
  )
  expect_error(
    fix("abcdefghij.py"),
    "Files must have a .r or .R extension.",
    fixed = TRUE
  )

  # Different printing for > 3 files
  expect_error(
    lint(c("abcde.py", "abcde2.py", "abcde3.py", "abcde4.py")),
    "The following files are problematic (only first 3 shown): abcde.py, abcde2.py, abcde3.py",
    fixed = TRUE
  )
  expect_error(
    fix(c("abcde.py", "abcde2.py", "abcde3.py", "abcde4.py")),
    "The following files are problematic (only first 3 shown): abcde.py, abcde2.py, abcde3.py",
    fixed = TRUE
  )
})
