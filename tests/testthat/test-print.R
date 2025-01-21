test_that("print for lint works fine with single-line code", {
  temp_rule <- tempfile(fileext = ".yml")
  foo <- "rule:
  kind: call
  has:
    regex: ^suppressPackageStartupMessages
message: foo"
  cat(foo, file = temp_rule)
  expect_snapshot(
    lint_text(
      "suppressPackageStartupMessages(library(dplyr))",
      linters = temp_rule
    )
  )
})

test_that("print for lint works fine with multi-line code", {
  temp_rule <- tempfile(fileext = ".yml")
  foo <- "rule:
  kind: call
  has:
    regex: ^suppressPackageStartupMessages
message: foo"
  cat(foo, file = temp_rule)
  expect_snapshot(
    lint_text(
      "suppressPackageStartupMessages({
  library(dplyr)
  library(knitr)
})",
      linters = temp_rule
    )
  )
})

test_that("print for lint works fine with multi-line code", {
  temp_rule <- tempfile(fileext = ".yml")
  foo <- "rule:
  pattern: unique(length($VAR))
fix: |
  length(
    unique(~~VAR~~)
  )"
  cat(foo, file = temp_rule)
  expect_snapshot(
    fix_text("unique(length(x))", linters = temp_rule)
  )
  expect_snapshot(
    fix_text(
      "unique(
  length(x)
)",
      linters = temp_rule
    )
  )
})
