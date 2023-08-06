#' @export
lint <- function(filename) {
  system2("ast-grep", "scan --json=stream", stdout = tmp) |>
    cat(file = tmp)

  jsonlite::fromJSON(tmp)
}

#' @export
fix <- function(filename) {
  system2("ast-grep", "run", stdout = FALSE)
}
