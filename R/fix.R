#' @export
fix <- function(path = ".") { # TODO: add a "linter" arg

}

#' @export
fix_text <- function(text) {
  browser()
  lints <- lint_text(text, return_nodes = TRUE)
  args <- list(
    x = lints[[1]]$node_1,
    attributes(lints[[1]])$fix
  )
  names(args)[2] <- names(lints[[1]])
  replacement2 <- rlang::call2(
    astgrepr::node_replace,
    !!!args
  ) |> rlang::eval_bare()
}
