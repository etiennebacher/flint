#' @export
print.tinylint <- function(x, ...) {
  cat("Original code:", crayon::red(x$text), "\n")
  cat("Suggestion:", crayon::green(x$message))
}
