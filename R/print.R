#' @export
print.flint_lint <- function(x, ...) {
  for (i in seq_along(x$text)) {
    cat("Original code:", crayon::red(x$text[i]), "\n")
    cat("Suggestion:", crayon::green(x$message[i]), "\n\n")
  }
}

#' @export
print.flint_fix <- function(x, ...) {
  cat("Old code:", crayon::red(attr(x, "original")), "\n")
  cat("New code:", crayon::green(x), "\n")
}
