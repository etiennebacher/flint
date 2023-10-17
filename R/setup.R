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
    already_in <- any(grepl("sgconfig\\.yml", readLines(".Rbuildignore", warn = FALSE)))
  } else {
    already_in <- FALSE
  }
  if (!already_in) {
    cat(
      "# tinylint files
^inst/tinylint
sgconfig.yml",
      file = ".Rbuildignore",
      append = TRUE
    )
  }
  invisible(
    fs::dir_copy(system.file("tinylint/rules", package = "tinylint"), "inst/tinylint/rules")
  )
  invisible(
    fs::file_copy(system.file("tinylint/sgconfig.yml", package = "tinylint"), "./sgconfig.yml")
  )
  invisible(
    fs::file_copy(system.file("tinylint/r.so", package = "tinylint"), "inst/tinylint/r.so")
  )
}

add_to_rbuildignore <- function(x) {
  cat(
    "# tinylint files
    ^inst/tinylint
    sgconfig.yml",
    file = ".Rbuildignore",
    append = TRUE
  )
}
