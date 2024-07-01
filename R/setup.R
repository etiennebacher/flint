#' Setup tinylint
#'
#' This stores the default rules and internal files in `inst/tinylint`. It also
#' imports `sgconfig.yml` that is used by `ast-grep`. This file must live at the
#' root of the project and cannot be renamed.
#'
#' @return Imports files necessary for `tinylint` to work but doesn't return any
#' value in R.
#' @export

setup_tinylint <- function() {
  if (fs::file_exists(".Rbuildignore")) {
    already_in <- any(grepl("inst/tinylint", readLines(".Rbuildignore", warn = FALSE)))
  } else {
    already_in <- FALSE
  }
  if (!already_in) {
    cat(
      "# tinylint files
^inst/tinylint",
      file = ".Rbuildignore",
      append = TRUE
    )
  }
  invisible(
    fs::dir_copy(system.file("tinylint/rules", package = "tinylint"), "inst/tinylint/rules")
  )
}
