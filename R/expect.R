#' @export
expect_no_lint <- function(x, ...) {
  out <- lint_text(x)
  tinytest::expect_true(length(out) == 0, ...)
}

#' @export
expect_lint <- function(x, message, ...) {
  out <- lint_text(x)
  tinytest::expect_true(
    nrow(out) > 0 && grepl(message, out$message),
    ...
  )
}

test_all_tinylint <- function() {
  tinytest::test_all(testdir = "tests/tinytest")
}
