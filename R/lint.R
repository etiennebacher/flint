#' @export
lint <- function(path = ".", open = TRUE) { # TODO: add a "linter" arg

  # run ast-grep and export the result to a JSON file that I can parse
  tmp <- tempfile(fileext = ".json")
  system2("ast-grep", paste("scan --json=compact", paste(path, collapse = " ")), stdout = tmp)

  lints_raw <- RcppSimdJson::fload(tmp)

  if (is.null(lints_raw)) {
    return(invisible())
  }
  lints <- lints_raw[, setdiff(names(lints_raw), c("metaVariables", "labels"))]
  data.table::setDT(lints)

  ranges <- data.table::rbindlist(lints$range)
  cols <- c("byteOffset", "start", "end")
  ranges[, (cols) := lapply(.SD, unlist), .SDcols = cols]
  ranges[, id := rep(seq_len(nrow(ranges)/2), each = 2)]
  ranges[, type := rep(c("row", "col"), nrow(ranges)/2)]
  ranges <- data.table::dcast(ranges, id ~ type, value.var = cols)
  ranges[, c("id", "byteOffset_col", "byteOffset_row") := NULL]
  data.table::setnames(ranges, c("start_col", "start_row", "end_col", "end_row"),
                       c("col_start", "line_start", "col_end", "line_end"))

  lints[, range := NULL]
  lints <- cbind(lints, ranges)

  # clean names
  to_select <- c("text", "line_start", "col_start", "line_end",
                 "col_end", "file", "severity",
                 "message")
  if ("replacement" %in% names(lints)) {
    to_select <- c(to_select, "replacement")
  }

  lints <- lints[, ..to_select]

  # lines and columns locations are 0-indexed so I need to bump them
  locs <- c("line_start", "col_start", "line_end", "col_end")
  lints[, (locs) := lapply(.SD, function(x) x + 1), .SDcols = locs]
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
lint_diff <- function(path = ".", open = TRUE) {
  changed_files <- system2("git", paste("diff --name-only", path), stdout = TRUE)
  lint(path = changed_files, open = open)
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
