#' @export
lint <- function(path = ".", open = TRUE) { # TODO: add a "linter" arg

  # run ast-grep and export the result to a JSON file that I can parse
  tmp <- tempfile(fileext = ".json")
  system2("ast-grep", paste("scan --json=compact", path), stdout = tmp)

  lints <- rjson::fromJSON(file = tmp)
  browser()
  lints <- rbindlist(lints)
  lints[, labels := NULL]
  lints[, metaVariables := NULL]
  print(lints$range)
  print(lints[, list(range = unlist(range)), by = setdiff(names(lints), 'range')])

  # clean names
  if (length(lints) == 0) return(invisible())
  to_select <- c("text", "range.start.line", "range.start.column",
                 "range.end.line", "range.end.column", "file",
                 "severity", "message")
  new_names <- c("text", "line_start", "col_start", "line_end",
                 "col_end", "file", "severity",
                 "message")
  if ("replacement" %in% names(lints)) {
    to_select <- c(to_select, "replacement")
    new_names <- c(new_names, "replacement")
  }
  lints <- lints[, .(to_select)]
  names(lints) <- new_names

  # lines and columns locations are 0-indexed so I need to bump them
  locs <- c("line_start", "col_start", "line_end", "col_end")
  lints[locs] <- lapply(locs, function(x) lints[[x]] + 1)
  lints <- lints[with(lints, order(file, line_start)), ]

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
lint_text <- function(text, open = TRUE) {
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
