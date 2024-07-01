clean_lints <- function(lints_raw, file) {
  locs <- astgrepr::node_range_all(lints_raw)
  txts <- astgrepr::node_text_all(lints_raw)

  locs_reorg <- lapply(seq_along(locs), function(x) {
    dat <- locs[[x]]
    res <- data.table::rbindlist(lapply(dat, function(y) {
      # locations are 0-indexed
      list(
        line_start = y$start[1] + 1,
        col_start = y$start[2] + 1,
        line_end = y$end[1] + 1,
        col_end = y$end[2] + 1
      )
    }), use.names = TRUE)
    if (nrow(res) > 0) {
      res[["id"]] <- names(locs)[x]
    }
    res
  })
  locs_reorg <- Filter(function(x) length(x) > 0, locs_reorg)

  locs2 <- data.table::rbindlist(locs_reorg, use.names = TRUE)
  txts2 <- data.table::rbindlist(lapply(txts, function(x) {
    data.frame(text = unlist(x))
  }), use.names = TRUE)

  other_info <- lapply(seq_along(lints_raw), function(x) {
    res <- attributes(lints_raw[[x]])[["other_info"]]
    res[["language"]] <- NULL
    res[["id"]] <- names(lints_raw)[x]
    res
  })

  other_info <- data.table::rbindlist(other_info, fill = TRUE, use.names = TRUE)

  lints <- cbind(txts2, locs2)
  lints <- merge(lints, other_info, by = "id", all.x = TRUE)
  lints[["file"]] <- file

  lints[order(line_start)]
}
