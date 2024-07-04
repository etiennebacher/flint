expect_lint <- function(x, message, linter) {
  if (is.null(linter)) {
    linter <- list_linters()
  }
  withr::with_envvar(
    new = c("FLINT_TESTING" = TRUE),
    out <- lint_text(x, linters = linter)
  )
  if (is.null(message)) {
    testthat::expect_true(length(out) == 0)
  } else {
    testthat::expect_true(
      nrow(out) > 0 && any(message == out$message | grepl(message, out$message, perl = TRUE))
    )
  }
}

expect_fix <- function(x, replacement) {
  withr::with_envvar(
    new = c("TINYLINT_TESTING" = TRUE),
    out <- fix_text(x)
  )
  testthat::expect_equal(as.character(out), replacement)
}

trim_some <- function(x, num = NULL) {
  x <- rex::re_substitutes(
    x,
    rex::rex(list(start, any_blanks, newline) %or% list(newline, any_blanks, end)),
    replacement = "",
    global = TRUE
  )

  if (is.null(num)) {
    ms <- rex::re_matches(x, "^\\s+", locations = TRUE, global = TRUE, options = "multi-line")[[1L]]
    num <- min(ms$end - ms$start) + 1L
  }

  rex::re_substitutes(x, rex::rex(start, n_times(any, num)), "", global = TRUE, options = "multi-line")
}
