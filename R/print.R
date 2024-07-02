#' @export
print.flint <- function(x, ...) {
  for (i in seq_along(x$text)) {
    cat("Original code:", crayon::red(x$text[i]), "\n")
    cat("Suggestion:", crayon::green(x$message[i]), "\n\n")
  }
}
