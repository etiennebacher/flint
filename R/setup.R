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
  if (fs::file_exists(".Rbuildignore")) {
    already_in <- any(grepl("sgconfig\\.yml", readLines(".Rbuildignore", warn = FALSE)))
  } else {
    already_in <- FALSE
  }
  if (!already_in) {
    cat(
      "# flint files
^inst/flint
sgconfig.yml",
      file = ".Rbuildignore",
      append = TRUE
    )
  }
  invisible(
    fs::dir_copy(system.file("flint/rules", package = "flint"), "inst/flint/rules")
  )
  invisible(
    fs::file_copy(system.file("flint/sgconfig.yml", package = "flint"), "./sgconfig.yml")
  )
  invisible(
    fs::file_copy(system.file("flint/r.so", package = "flint"), "inst/flint/r.so")
  )
}

add_to_rbuildignore <- function(x) {
  cat(
    "# flint files
    ^inst/flint
    sgconfig.yml",
    file = ".Rbuildignore",
    append = TRUE
  )
}
