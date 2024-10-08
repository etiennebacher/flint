#' Setup flint
#'
#' This stores the default rules and internal files in `inst/flint`. It also
#' imports `sgconfig.yml` that is used by `ast-grep`. This file must live at the
#' root of the project and cannot be renamed.
#'
#' @param path Path to package or project root.
#'
#' @return Imports files necessary for `flint` to work but doesn't return any
#' value in R.
#' @export

setup_flint <- function(path = ".") {
  flint_dir <- file.path(path, "flint")

  ### Check dir
  if (fs::dir_exists(flint_dir) && length(list.files(flint_dir, recursive = TRUE)) > 0) {
    stop("Folder `flint` already exists and is not empty.")
  } else if (!fs::dir_exists(flint_dir)) {
    fs::dir_create(flint_dir)
  }

  ### Check buildignore
  if (fs::file_exists(".Rbuildignore")) {
    already_in <- any(grepl("flint", readLines(".Rbuildignore", warn = FALSE)))
  } else {
    already_in <- FALSE
  }
  if (!already_in) {
    cat(
      "\n\n# flint files
^flint$",
      file = ".Rbuildignore",
      append = TRUE
    )
  }

  ### Files
  invisible(
    fs::dir_copy(system.file("rules/builtin", package = "flint"), fs::path(flint_dir, "rules/builtin"))
  )
  if (!fs::file_exists(file.path(flint_dir, "cache_file_state.rds"))) {
    saveRDS(NULL, file.path(flint_dir, "cache_file_state.rds"))
  }
  config_content <- paste0(
    "keep:\n",
    paste("  -", list_linters(), collapse = "\n")
  )
  writeLines(config_content, file.path(flint_dir, "config.yml"))
}

#' Update the `flint` setup
#'
#' @description
#'
#' When `flint` is updated, it can ship new built-in rules or update existing 
#' ones. `update_flint()` will automatically add those new rules to the 
#' `flint/rules/builtin` folder. Custom rules stored in `flint/rules/custom`
#' are not affected.
#'
#' @inheritParams setup_flint
#'
#' @return Can add new files in the `flint/rules` folder, doesn't return anything.
#' @export
#'
#' @examples
#' \dontrun{
#'   update_flint()
#' }
update_flint <- function(path = ".") {
  flint_dir <- file.path(path, "flint")
  built_in_rules <- list.files(fs::path(flint_dir, "rules/builtin"), pattern = "\\.yml$")
  updated_built_in_rules <- system.file(
    list.files("rules/builtin", pattern = "\\.yml$"),
    package = "flint"
  )
  new_built_in_rules <- setdiff(updated_built_in_rules, built_in_rules)
  
  # Copy everything so that rules that already exist can also be updated.
  fs::file_copy(updated_built_in_rules, paste0(flint_dir, "/rules/builtin/", basename(updated_built_in_rules)))

  cli::cli_alert_success("Updated existing rules.")
  if (length(new_built_in_rules) > 0) {
    cli::cli_alert_success("Added {length(new_built_in_rules)} rule{?s}: {gsub('\\.yml$', '', basename(new_built_in_rules))}.")
    cli::cli_alert_info("Don't forget to add them in flint/config.yml to use them.")
  }
}
