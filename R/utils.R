clean_lints <- function(lints_raw) {
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
  lints[with(lints, order(file, line_start)), ]
}
