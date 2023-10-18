#' List all lints in a file or a directory
#'
#' `lint()`, `lint_text()` and `lint_diff()` all produce a list of lints. The
#' only difference is in the input they take:
#' * `lint()` takes path to files or directories
#' * `lint_text()` takes some text input
#' * `lint_diff()` takes a path to a directory but only looks at files that have
#'   changed since the last commit.
#'
#' @param path A valid path to a file or a directory. Relative paths are accepted.
#' @param linters A character vector with the names of the rules to apply. See
#'   the entire list of rules with `list_linters()`.
#' @param open If `TRUE` (default) and if this is used in the RStudio IDE, lints
#'   will be shown with markers.
#'
#' @return A dataframe where each row is a lint. The columns show the text, its
#'   location (both the position in the text and the file in which it was found)
#'   and the severity.
#'
#' @export

lint <- function(path = ".", linters = NULL, open = TRUE) { # TODO: add a "linter" arg

  if (!is.null(linters) && !all(linters %in% list_linters())) {
    stop(paste0("Unknown linters: ", toString(setdiff(linters, list_linters()))))
  } else if (is.null(linters)) {
    linters <- list_linters()
  }

  # run ast-grep and export the result to a JSON file that I can parse
  tmp <- tempfile(fileext = ".json")
  system2(
    "ast-grep",
    paste(
      "scan --json=compact",
      if (length(linters) == length(list_linters())) {
        ""
      } else {
        paste0("--filter ", paste(linters, collapse = "|"))
      } ,
      paste(path, collapse = " ")
    ),
    stdout = tmp
  )

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

#' @rdname lint
#' @export

lint_diff <- function(path = ".", open = TRUE) {
  if (!fs::is_dir(path)) {
    stop("`lint_diff()` only works with path to directories.")
  }
  changed_files <- system2("git", paste("diff --name-only", path), stdout = TRUE)
  lint(path = changed_files, open = open)
}

#' @rdname lint
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
