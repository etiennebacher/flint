test_that("users can define custom linters", {
  create_local_package()
  setup_flint()

  cat("id: foobar
language: r
severity: warning
rule:
  pattern: unique(length($VAR))
fix: length(unique(~~VAR~~))
message: Most likely an error
", file = "flint/rules/AAAAAAAAA.yml")

  cat("x <- function() { \nunique(length(x))\n}", file = "R/foo.R")
  withr::with_envvar(
    new = c("TESTTHAT" = FALSE),
    {
      expect_equal(nrow(lint(use_cache = FALSE)), 1)
      expect_equal(nrow(lint(use_cache = FALSE, linters = list_linters())), 0)
      fix()
    }
  )
  expect_true(any(grepl("length(unique(x))", readLines("R/foo.R", warn = FALSE), fixed = TRUE)))
})
