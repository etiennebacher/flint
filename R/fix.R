#' @export
fix_file <- function(filename) {
  system2("ast-grep", "scan --update-all", stdout = FALSE)
}
