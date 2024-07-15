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
    fs::dir_copy(system.file("rules", package = "flint"), flint_dir)
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
#' When `flint` is updated, it can ship new built-in rules. `update_flint()` will
#' automatically add those new rules in the `flint/rules` folder. New rules are
#' only determined by their names and rules that already exist in `flint/rules`
#' are not affected.
#'
#' For instance, if you added a custom rule `use_paste.yml`, then it will never
#' be removed by `update_flint()`, even if `flint` later adds a built-in rule
#' also named `use_paste.yml`.
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
  existing_rules <- list.files(file.path(flint_dir, "rules"), pattern = "\\.yml$")
  built_in_rules <- list.files(system.file("rules", package = "flint"), pattern = "\\.yml$")
  new_built_in_rules <- system.file(
    paste0("rules/", setdiff(built_in_rules, existing_rules)),
    package = "flint"
  )
  cat("New rules:\n", paste0("- ", basename(new_built_in_rules), "\n"))
  fs::file_copy(new_built_in_rules, paste0(flint_dir, "/rules/", basename(new_built_in_rules)))
}
