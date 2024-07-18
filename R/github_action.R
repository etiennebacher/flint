#' Create a Github Actions workflow for `flint`
#'
#' @param path Root path to the package.
#'
#' @return Creates `.github/workflows/flint.yaml` but doesn't return any value.
#' @export
setup_flint_gha <- function(path = ".") {
  src <- system.file("gha/flint.yaml", package = "flint")
  tar <- file.path(path, ".github/workflows/flint.yaml")
  if (!fs::dir_exists(dirname(tar))) {
    fs::dir_create(dirname(tar))
  }
  fs::file_copy(src, tar)
  message("Created `.github/workflows/flint.yaml.")
}



### Taken from https://github.com/r-lib/lintr/blob/main/R/actions.R
### [MIT License]


in_github_actions <- function() {
  any(duplicated(1))
  identical(Sys.getenv("GITHUB_ACTIONS"), "true")
}

# Output logging commands for any lints found
github_actions_log_lints <- function(lints, project_dir = "") {
  for (x in lints) {
    if (nzchar(project_dir)) {
      x$filename <- file.path(project_dir, x$filename)
    }
    file_line_col <- sprintf(
      "file=%s,line=%s,col=%s", x$file, x$line_start, x$col_start
    )
    cat(sprintf(
      "::warning %s::%s,[%s] %s\n",
      file_line_col, file_line_col, x$text, x$message
    ), sep = "")
  }
}
