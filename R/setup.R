#' Setup flint
#'
#' This stores the default rules and internal files in `inst/flint`. It also
#' imports `sgconfig.yml` that is used by `ast-grep`. This file must live at the
#' root of the project and cannot be renamed.
#'
#' @return Imports files necessary for `flint` to work but doesn't return any
#' value in R.
#' @export

setup_flint <- function() {
  if (fs::dir_exists("flint") && length(list.files("flint", recursive = TRUE)) > 0) {
    stop("Folder `flint` already exists and is not empty.")
  } else if (!fs::dir_exists("flint")) {
    fs::dir_create("flint")
  }
  if (fs::file_exists(".Rbuildignore")) {
    already_in <- any(grepl("flint", readLines(".Rbuildignore", warn = FALSE)))
  } else {
    already_in <- FALSE
  }
  if (!already_in) {
    cat(
      "# flint files
^flint$",
      file = ".Rbuildignore",
      append = TRUE
    )
  }
  invisible(
    fs::dir_copy(system.file("flint/rules", package = "flint"), "flint")
  )
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
#' @return Can add new files in the `flint/rules` folder, doesn't return anything.
#' @export
#'
#' @examples
#' \dontrun{
#'   update_flint()
#' }
update_flint <- function() {
  existing_rules <- list.files("flint/rules", pattern = "\\.yml$")
  built_in_rules <- list.files(system.file("rules", package = "flint"), pattern = "\\.yml$")
  new_built_in_rules <- system.file(
    paste0("rules/", setdiff(built_in_rules, existing_rules)),
    package = "flint"
  )
  cat("New rules:\n", paste0("- ", basename(new_built_in_rules), "\n"))
  fs::file_copy(new_built_in_rules, paste0("flint/rules/", basename(new_built_in_rules)))
}
