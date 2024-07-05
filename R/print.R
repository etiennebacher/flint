#' @export
print.flint_lint <- function(x, ...) {
  for (i in seq_along(x$text)) {
    cat("Original code:", crayon::red(x$text[i]), "\n")
    cat("Suggestion:", crayon::green(x$message[i]), "\n\n")
  }
}

#' @export
print.flint_fix <- function(x, ...) {
  if (grepl("\\n", attr(x, "original"))) {
    cat(paste0("Old code:\n", crayon::red(attr(x, "original")), "\n\n"))
    cat(paste0("New code:\n", crayon::green(x), "\n"))
  } else {
    cat("Old code:", crayon::red(attr(x, "original")), "\n")
    cat("New code:", crayon::green(x), "\n")
  }
}
