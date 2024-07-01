#' @export
fix <- function(path = ".") { # TODO: add a "linter" arg

}

#' @export
fix_text <- function(text) {
  lints <- lint_text(text, return_nodes = TRUE)
  args <- append(
    list(x = astgrepr:::add_rulelist_class(lints[[1]])),
    rep(attributes(lints[[1]])$other_info$fix, length(lints[[1]]))
  )
  names(args)[2:length(args)] <- names(lints[[1]])
  replacement2 <- rlang::call2(
    astgrepr::node_replace,
    !!!args
  ) |> rlang::eval_bare()

  root <- astgrepr::tree_new(text) |>
    astgrepr::tree_root()

  out <- astgrepr::tree_rewrite(root, replacement2)
  class(out) <- c("tinylint_fix", class(out))
  attr(out, "original") <- text
  out
}

# TODO: this errors because the first replacement doesn't shift the indices before
# applying the second one:
# fix_text("any(duplicated(x)); any(duplicated(y))")
