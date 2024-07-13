#' List all lints in a file or a directory
#'
#' `lint()`, `lint_text()` and `lint_dir()` all produce a data.frame containing
#' the lints, their location, and potential fixes. The only difference is in the
#' input they take:
#' * `lint()` takes path to files or directories
#' * `lint_text()` takes some text input
#' * `lint_dir()` takes a path to one directory
#' * `lint_package()` takes a path to the root of a package and looks at the
#' following list of folders: `R`, `tests`, `inst`, `vignettes`, `data-raw`,
#' `demo`, `exec`.
#'
#' @param path A valid path to a file or a directory. Relative paths are
#'   accepted.
#' @param linters A character vector with the names of the rules to apply. See
#'   the entire list of rules with `list_linters()`.
#' @param exclude_path One or several paths that will be ignored from the `path`
#'   selection.
#' @param exclude_linters One or several linters that will not be checked.
#'   Values can be the names of linters (such as `"any_is_na"`) or its
#'   associated function, such as `any_is_na_linter()` (this is mostly for
#'   compatibility with `lintr`).
#' @param open If `TRUE` (default) and if this is used in the RStudio IDE, lints
#'   will be shown with markers.
#' @param use_cache Do not re-parse files that haven't changed since the last
#'   time this function ran.
#'
#' @section Ignoring lines:
#'
#' `flint` supports ignoring single lines of code with `# flint-ignore`. For
#' example, this will not warn:
#'
#' ```r
#' # flint-ignore
#' any(duplicated(x))
#' ```
#'
#' However, this will warn for the second `any(duplicated())`:
#'
#' ```r
#' # flint-ignore
#' any(duplicated(x))
#' any(duplicated(y))
#' ```
#'
#' To ignore more than one line of code, use `# flint-ignore-start` and
#' `# flint-ignore-end`:
#'
#' ```r
#' # flint-ignore-start
#' any(duplicated(x))
#' any(duplicated(y))
#' # flint-ignore-end
#' ```
#'
#'
#' @return A dataframe where each row is a lint. The columns show the text, its
#'   location (both the position in the text and the file in which it was found)
#'   and the severity.
#'
#' @export
#' @examples
#' # `lint_text()` is convenient to explore with a small example
#' lint_text("any(duplicated(rnorm(5)))")
#'
#' lint_text("any(duplicated(rnorm(5)))
#' any(is.na(x))
#' ")
#'
#' # Setup for the example with `lint()`
#' destfile <- tempfile()
#' cat("
#' x = c(1, 2, 3)
#' any(duplicated(x), na.rm = TRUE)
#'
#' any(duplicated(x))
#'
#' if (any(is.na(x))) {
#'   TRUE
#' }
#'
#' any(
#'   duplicated(x)
#' )", file = destfile)
#'
#' lint(destfile)

lint <- function(
    path = ".",
    linters = NULL,
    exclude_path = NULL,
    exclude_linters = NULL,
    open = TRUE,
    use_cache = TRUE
) {

  if (is_testing()) {
    use_cache <- FALSE
  }

  linters2 <- resolve_linters(linters, exclude_linters)
  r_files <- resolve_path(path, exclude_path)
  rule_files <- resolve_rules(linters_is_null = is.null(linters), linters2, path)
  lints <- list()
  hashes <- resolve_hashes(path, use_cache)

  for (i in r_files) {

    if (use_cache) {
      current_hash <- digest::digest(readLines(i, warn = FALSE))
      if (!is.null(names(hashes)) && i %in% names(hashes)) {
        stored_info <- hashes[[i]]
        if (current_hash == stored_info[["hash"]]) {
          lints[[i]] <- stored_info[["lints"]]
          next
        }
      }
    }

    lints_raw <- astgrepr::tree_new(file = i, ignore_tags = "flint-ignore") |>
      astgrepr::tree_root()|>
      astgrepr::node_find_all(files = rule_files)

    if (all(lengths(lints_raw) == 0)) {
      lints[[i]] <- data.table()
    } else {
      lints[[i]] <- clean_lints(lints_raw, file = i)
    }

    if (use_cache) {
      hashes[[i]][["hash"]] <- current_hash
      hashes[[i]][["lints"]] <- lints[[i]]
    }
  }

  if (use_cache) {
    if (is_flint_package() || is_testing()) {
      saveRDS(hashes, file.path(getwd(), "inst/cache_file_state.rds"))
    } else if (uses_flint(path)) {
      saveRDS(hashes, file.path(getwd(), "flint/cache_file_state.rds"))
    }
  }
  lints <- data.table::rbindlist(lints, use.names = TRUE, fill = TRUE)

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

#' @param text Text to analyze.
#'
#' @rdname lint
#' @export

lint_text <- function(text, linters = NULL, exclude_linters = NULL) {
  tmp <- tempfile(fileext = ".R")
  text <- trimws(text)
  cat(text, file = tmp)

  # one pass to get a clean dataframe, one pass to get the default ast-grep
  # output that is used in the custom print method. It's also easier to have a
  # dataframe output in tests.
  # We're only parsing a small text in general so passing twice is not an issue.
  out <- lint(tmp, linters = linters, exclude_linters = exclude_linters, open = FALSE)
  if (length(out) == 0) {
    return(invisible())
  }

  class(out) <- c("flint_lint", class(out))
  out
}
