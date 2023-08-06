expect_lint <- function(x, message, linter = NULL) {
  out <- lint_text(x)
  if (is.null(message)) {
    testthat::expect_true(length(out) == 0)
  } else {
    testthat::expect_true(
      nrow(out) > 0 && message == out$message
    )
  }
}
