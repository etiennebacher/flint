clean_lints <- function(lints_raw, file) {
  locs <- astgrepr::node_range_all(lints_raw)
  txts <- astgrepr::node_text_all(lints_raw)

  # for data.table NOTE on undefined objects
  line_start <- NULL

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
  dest <- paste0("tests/testthat/test-", name, ".R")
  utils::download.file(url, destfile = dest)
  rstudioapi::documentOpen(dest)
}

resolve_linters <- function(path, linters, exclude_linters) {
  if (!is.null(linters)) {
    if (is.list(linters)) {
      # for compat with lintr
      linters <- unlist(linters)
    }
    if (!all(linters %in% list_linters())) {
      custom <- setdiff(linters, list_linters())
      custom <- vapply(custom, function(x) {
        if (fs::is_absolute_path(x)) {
          return(x)
        } else if (is_flint_package(path)) {
          fs::path("inst/rules/", paste0(x, ".yml"))
        } else if (is_testing() || !uses_flint(path)) {
          fs::path(system.file(package = "flint"), "rules/", paste0(x, ".yml"))
        } else {
          file.path("flint/rules", paste0(x, ".yml"))
        }
      }, FUN.VALUE = character(1))
      if (!all(fs::file_exists(custom))) {
        stop(paste0("Unknown linters: ", toString(custom[!fs::file_exists(custom)])))
      }
      linters <- custom
    }
  } else {
    if (is_flint_package(path)) {
      config_file <- file.path(path, "inst/config.yml")
    } else {
      config_file <- file.path(path, "flint/config.yml")
    }
    if (fs::file_exists(config_file)) {
      linters <- yaml::read_yaml(config_file, readLines.warn = FALSE)[["keep"]]
      if (length(linters) == 0) {
        stop("`", config_file, "` exists but doesn't contain any rule.")
      }
    } else {
      linters <- list_linters()
    }
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

resolve_rules <- function(linters_is_null, linters, path) {
  if (is_flint_package(path)) {
    vapply(linters, function(x) {
      if (fs::is_absolute_path(x)) {
        x
      } else {
        fs::path("inst/rules/", paste0(x, ".yml"))
      }
    }, FUN.VALUE = character(1))
  } else if (is_testing() || !uses_flint(path)) {
    vapply(linters, function(x) {
      if (fs::is_absolute_path(x)) {
        x
      } else {
        fs::path(system.file(package = "flint"), "rules/", paste0(x, ".yml"))
      }
    }, FUN.VALUE = character(1))
  } else {
    # If the user didn't specify linters, then we use all of them, including the
    # custom ones.
    # However, if the user made a selection in linters, we only respect their
    # choice.
    if (linters_is_null) {
      rules <- fs::path("flint/rules/", list.files("flint/rules", pattern = "\\.yml$"))
    } else {
      rules <- fs::path("flint/rules/", paste0(linters, ".yml"))
    }
    return(rules)
  }
}

resolve_hashes <- function(path, use_cache) {
  if (!use_cache || !uses_flint(path)) {
    NULL
  } else if (is_flint_package(path) || is_testing()) {
    readRDS(file.path("inst/cache_file_state.rds"))
  } else {
    readRDS(file.path("flint/cache_file_state.rds"))
  }
}

is_flint_package <- function(path) {
  path <- file.path(path, "DESCRIPTION")
  if (!fs::file_exists(path)) {
    return(FALSE)
  }
  read.dcf(path)[, "Package"] == "flint"
}

uses_flint <- function(path = ".") {
  flint_dir <- file.path(path, "flint")
  fs::dir_exists(flint_dir) && length(list.files(flint_dir)) > 0
}

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

new_rule <- function(name) {
  dest <- paste0("inst/rules/", name, ".yml")
  cat("id: ...
language: r
severity: warning
rule:
  pattern: ...
fix: ...
message: ...
", file = dest)
  rstudioapi::documentOpen(dest)
}
