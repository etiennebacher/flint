clean_json <- function(lints_raw) {
  # using vapply() because it guarantees type strictness. However, it's not
  # faster than sapply() on large examples (only at the microsecond level).
  # It's a bit more memory efficient than sapply.
  lints <- data.frame(
    text = vapply(lints_raw, function(x) x$text, FUN.VALUE = character(1L)),
    range_start_byteOffset = vapply(lints_raw, function(x) x$range$byteOffset$start, FUN.VALUE = numeric(1L)),
    range_end_byteOffset = vapply(lints_raw, function(x) x$range$byteOffset$end, FUN.VALUE = numeric(1L)),
    line_start = vapply(lints_raw, function(x) x$range$start$line, FUN.VALUE = numeric(1L)),
    col_start = vapply(lints_raw, function(x) x$range$start$column, FUN.VALUE = numeric(1L)),
    line_end = vapply(lints_raw, function(x) x$range$end$line, FUN.VALUE = numeric(1L)),
    col_end = vapply(lints_raw, function(x) x$range$end$column, FUN.VALUE = numeric(1L)),
    file = vapply(lints_raw, function(x) x$file, FUN.VALUE = character(1L)),
    language = vapply(lints_raw, function(x) x$language, FUN.VALUE = character(1L)),
    ruleId = vapply(lints_raw, function(x) x$ruleId, FUN.VALUE = character(1L)),
    severity = vapply(lints_raw, function(x) x$severity, FUN.VALUE = character(1L)),
    message = vapply(lints_raw, function(x) x$message, FUN.VALUE = character(1L))
  )

  replacement <- sapply(lints_raw, function(x) x$replacement)
  if (length(replacement) > 0) {
    lints$replacement <- replacement
  }
  lints
}
