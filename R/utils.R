clean_lints <- function(lints_raw, file) {
  locs <- astgrepr::node_range_all(lints_raw)
  txts <- astgrepr::node_text_all(lints_raw)

  locs_reorg <- lapply(locs, function(x) {
    data.table::rbindlist(lapply(x, function(y) {
      # locations are 0-indexed
      list(
        line_start = y$start[1] + 1,
        col_start = y$start[2] + 1,
        line_end = y$end[1] + 1,
        col_end = y$end[2] + 1
      )
    }))
  })
  locs_reorg <- Filter(function(x) length(x) > 0, locs_reorg)

  locs2 <- data.table::rbindlist(locs_reorg)
  txts2 <- data.table::rbindlist(lapply(txts, function(x) {
    data.frame(text = unlist(x))
  }))

  lints <- cbind(txts2, locs2)
  lints[["file"]] <- file

  # TODO: find a way to remove this
  lints[["severity"]] <- "warning"
  lints[["message"]] <- "hi there"

  lints
}
