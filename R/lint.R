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

  if (all(fs::is_dir(path))) {
    r_files <- list.files(path, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
  } else {
    r_files <- path
  }
  rule_files <- fs::path(system.file(package = "flint"), "rules/", paste0(linters, ".yml"))
  lints <- list()

  for (i in r_files) {
    root <- astgrepr::tree_new(file = i) |>
      astgrepr::tree_root()

    lints_raw <- astgrepr::node_find_all(root, files = rule_files)

    if (all(lengths(lints_raw) == 0)) {
      next
    }

    lints[[i]] <- clean_lints(lints_raw, file = i)
  }

  lints <- data.table::rbindlist(lints, fill = TRUE)

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

lint_dir <- function(path = ".", linters = NULL, open = TRUE) {
  if (!fs::is_dir(path)) {
    stop("`path` must be a directory.")
  }
  lint(path, linters = linters, open = open)
}

#' @rdname lint
#' @export

lint_package <- function(path = ".", linters = NULL, open = TRUE) {
  if (!fs::is_dir(path)) {
    stop("`path` must be a directory.")
  }
  paths <- fs::path(path, c("R", "tests", "inst", "vignettes", "data-raw", "demo", "exec"))
  paths <- paths[fs::dir_exists(paths)]
  lint(path, linters = linters, open = open)
}

#' @rdname lint
#' @export

lint_text <- function(text, linters = NULL) {
  tmp <- tempfile(fileext = ".R")
  text <- trimws(text)
  cat(text, file = tmp)

  # one pass to get a clean dataframe, one pass to get the default ast-grep
  # output that is used in the custom print method. It's also easier to have a
  # dataframe output in tests.
  # We're only parsing a small text in general so passing twice is not an issue.
  out <- lint(tmp, linters = linters, open = FALSE)
  if (length(out) == 0) {
    return(invisible())
  }

  class(out) <- c("flint", class(out))
  out
}
