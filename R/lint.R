#' @export
lint <- function(path = ".", open = TRUE) { # TODO: add a "linter" arg

  # run ast-grep and export the result to a JSON file that I can parse
  tmp <- tempfile(fileext = ".json")
  system2("ast-grep", paste("scan --json=compact", path), stdout = tmp)

  lints_raw <- rjson::fromJSON(file = tmp)
  lints <- data.frame(
    text = sapply(lints_raw, function(x) x$text),
    range_start_byteOffset = sapply(lints_raw, function(x) x$range$byteOffset$start),
    range_end_byteOffset = sapply(lints_raw, function(x) x$range$byteOffset$end),
    line_start = sapply(lints_raw, function(x) x$range$start$line),
    col_start = sapply(lints_raw, function(x) x$range$start$column),
    line_end = sapply(lints_raw, function(x) x$range$end$line),
    col_end = sapply(lints_raw, function(x) x$range$end$column),
    file = sapply(lints_raw, function(x) x$file),
    language = sapply(lints_raw, function(x) x$language),
    ruleId = sapply(lints_raw, function(x) x$ruleId),
    severity = sapply(lints_raw, function(x) x$severity),
    message = sapply(lints_raw, function(x) x$message)
  )

  replacement <- sapply(lints_raw, function(x) x$replacement)
  if (length(replacement) > 0) {
    lints$replacement <- replacement
  }

  # clean names
  if (length(lints) == 0) return(invisible())
  to_select <- c("text", "line_start", "col_start", "line_end",
                 "col_end", "file", "severity",
                 "message", "replacement")

  lints <- lints[, to_select]

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
