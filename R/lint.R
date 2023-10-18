#' @export
lint <- function(path = ".", open = TRUE) { # TODO: add a "linter" arg

  # run ast-grep and export the result to a JSON file that I can parse
  tmp <- tempfile(fileext = ".json")
  system2("ast-grep", paste("scan --json=compact", paste(path, collapse = " ")), stdout = tmp)

  lints_raw <- RcppSimdJson::fload(tmp)

  if (is.null(lints_raw)) {
    return(invisible())
  }
  lints <- clean_lints(lints_raw)

  if (isTRUE(open) &&
      requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::isAvailable()) {
    rstudio_source_markers(lints)
    return(invisible(lints))
  } else {
    lints
  }
}

#' @export
lint_diff <- function(path = ".", open = TRUE) {
  changed_files <- system2("git", paste("diff --name-only", path), stdout = TRUE)
  lint(path = changed_files, open = open)
}

#' @export
lint_text <- function(text) {
  tmp <- tempfile(fileext = ".R")
  tmp_out <- tempfile()
  text <- trimws(text)
  cat(text, file = tmp)

  # one pass to get a clean dataframe, one pass to get the default ast-grep
  # output that is used in the custom print method. It's also easier to have a
  # dataframe output in tests.
  # We're only parsing a small text in general so passing twice is not an issue.
  system2("ast-grep", paste("scan", tmp), stdout = tmp_out)
  out <- lint(tmp, open = FALSE)
  if (length(out) == 0) return(invisible())

  attr(out, "tinylint_output") <- readLines(tmp_out)
  class(out) <- c("tinylint", class(out))
  out
}
