library(tinytest)

register_tinytest_extension(
  "tinylint",
  c("expect_no_lint")
)

exit_if <- function(...) {
  L <- as.list(substitute(list(...))[-1])
  msg <- NULL
  for (e in L) {
    if (isTRUE(eval(e))) {
      str <- paste0(deparse(e), collapse = " ")
      msg <- sprintf("'%s' is TRUE", str)
      break
    }
  }
  msg
}

is_ci <- function() {
  isTRUE(as.logical(Sys.getenv("CI", "false")))
}

is_cran <- function() {
  isFALSE(as.logical(Sys.getenv("NOT_CRAN", "false")))
}
