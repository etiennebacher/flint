#' Create a Github Actions workflow for `flint`
#'
#' @param path Root path to the package.
#'
#' @return Creates `.github/workflows/flint.yaml` but doesn't return any value.
#' @export
setup_flint_gha <- function(path = ".") {
  src <- system.file("gha/flint.yaml", package = "flint")
  tar <- file.path(path, ".github/workflows/flint.yaml")
  fs::file_copy(src, tar)
  message("Created `.github/workflows/flint.yaml.")
}
