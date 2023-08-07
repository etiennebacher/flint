setup_tinylint <- function() {
  if (file.exists(".Rbuildignore")) {
    already_in <- any(grepl("sgconfig\\.yml", readLines(".Rbuildignore", warn = FALSE)))
  } else {
    already_in <- FALSE
  }
  if (!already_in) {
    cat(
      "# tinylint files
^inst/rules
sgconfig.yml",
      file = ".Rbuildignore",
      append = TRUE
    )
  }
  invisible(
    file.copy(system.file("rules", package = "tinylint"), "inst")
  )
  invisible(
    file.copy(system.file("sgconfig.yml", package = "tinylint"), ".")
  )
  invisible(
    file.copy(system.file("tinylint/r.so", package = "tinylint"), "inst/tinylint")
  )
}

add_to_rbuildignore <- function(x) {
  cat(
    "# tinylint files
    ^inst/rules
    sgconfig.yml",
    file = ".Rbuildignore",
    append = TRUE
  )
}
