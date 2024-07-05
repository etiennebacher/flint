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
  txts2 <- data.table::data.table(text = unlist(txts, recursive = TRUE, use.names = FALSE))

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


get_tests_from_lintr <- function(name) {
  url <- paste0("https://raw.githubusercontent.com/r-lib/lintr/main/tests/testthat/test-", name, "_linter.R")
  download.file(url, destfile = paste0("tests/testthat/test-", name, ".R"))
}

resolve_linters <- function(linters, exclude_linters) {
  if (!is.null(linters) && !all(linters %in% list_linters())) {
    stop(paste0("Unknown linters: ", toString(setdiff(linters, list_linters()))))
  } else if (is.null(linters)) {
    linters <- list_linters()
  } else if (is.list(linters)) {
    # for compat with lintr
    linters <- unlist(linters)
  }
  setdiff(linters, exclude_linters)
}

resolve_path <- function(path, exclude_path) {
  if (all(fs::is_dir(path))) {
    r_files <- list.files(path, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
    excluded <- file.path(path, exclude_path)
    r_files <- setdiff(r_files, excluded)
  } else {
    r_files <- path
  }
  r_files
}

resolve_rules <- function(linters, path) {
  if (is_flint_package() || identical(Sys.getenv("TESTTHAT"), "true")) {
    fs::path(system.file(package = "flint"), "rules/", paste0(linters, ".yml"))
  } else {
    fs::path("flint/rules/", paste0(linters, ".yml"))
  }
}

resolve_hashes <- function() {
  if (is_flint_package() || identical(Sys.getenv("TESTTHAT"), "true")) {
    readRDS(file.path(getwd(), "inst/cache_file_state.rds"))
  } else {
    readRDS(file.path(getwd(), "flint/cache_file_state.rds"))
  }
}

is_flint_package <- function() {
  if (!fs::file_exists("DESCRIPTION")) {
    return(FALSE)
  }
  read.dcf("DESCRIPTION")[, "Package"] == "flint"
}
