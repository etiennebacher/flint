#' @export
print.flint_lint <- function(x, ...) {
  for (i in seq_along(x$text)) {
    if (grepl("\\n", x$text[i])) {
      cat(paste0("Original code:\n", crayon::red(x$text[i]), "\n"))
      cat(paste0("Suggestion: ", crayon::green(x$message[i]), "\n\n"))
    } else {
      cat("Original code:", crayon::red(x$text[i]), "\n")
      cat("Suggestion:", crayon::green(x$message[i]), "\n")
    }
  }
}

#' @export
print.flint_fix <- function(x, ...) {
  new_code_multilines <- grepl("\\n", attr(x, "original")) | grepl("\\n", x)
  if (grepl("\\n", attr(x, "original"))) {
    cat(paste0("Old code:\n", crayon::red(attr(x, "original")), "\n\n"))
  } else {
    cat("Old code:", crayon::red(attr(x, "original")), "\n")
  }
  if (new_code_multilines) {
    cat(paste0("New code:\n", crayon::green(x), "\n"))
  } else {
    cat("New code:", crayon::green(x), "\n")
  }
}
