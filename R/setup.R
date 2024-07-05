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
