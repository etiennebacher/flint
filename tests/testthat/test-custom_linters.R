test_that("users can define custom linters", {
  create_local_package()
  setup_flint()
  fs::dir_create("flint/rules/custom")

  cat("id: foobar
language: r
severity: warning
rule:
  pattern: unique(length($VAR))
fix: length(unique(~~VAR~~))
message: Most likely an error
", file = "flint/rules/custom/AAAAAAAAA.yml")

  cat("x <- function() { \nunique(length(x))\n}", file = "R/foo.R")

  config <- yaml::read_yaml("flint/config.yml")
  config$keep <- c(config$keep, "AAAAAAAAA")
  yaml::write_yaml(config, "flint/config.yml")
  withr::with_envvar(
    new = c("TESTTHAT" = FALSE, "GITHUB_ACTIONS" = FALSE),
    {
      expect_equal(nrow(lint(use_cache = FALSE, verbose = FALSE)), 1)
      expect_equal(nrow(lint(use_cache = FALSE, linters = list_linters(), verbose = FALSE)), 0)
      fix(verbose = FALSE)
    }
  )
  expect_true(
    any(grepl(
      "length(unique(x))", readLines("R/foo.R", warn = FALSE), 
      fixed = TRUE
    ))
  )
})
