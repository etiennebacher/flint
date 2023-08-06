#' @export
print.tinylint <- function(x, ...) {
  raw <- attributes(x)$tinylint_output
  cat(paste(raw[-c(2, 3)], collapse = "\n"))
}
