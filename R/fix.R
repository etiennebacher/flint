#' @export
fix <- function(path = ".") { # TODO: add a "linter" arg
  system2("ast-grep", paste("scan --update-all", paste(path, collapse = " ")), stdout = tmp)
}

#' @export
fix_text <- function(text) {
  tmp <- tempfile(fileext = ".R")
  text <- trimws(text)
  cat(text, file = tmp)

  system2("ast-grep", paste("scan --update-all", tmp), stdout = FALSE)

  out <- readLines(tmp, warn = FALSE)
  attr(out, "tinylint_output") <- out
  class(out) <- c("tinylint", class(out))
  out
}
