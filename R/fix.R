#' @export
fix <- function(path = ".", linters = NULL, open = TRUE, return_nodes = FALSE) { # TODO: add a "linter" arg
  lints <- lint(path, linters = linters, open = open, return_nodes = TRUE)
  browser()
  lints <- Filter(Negate(is.null), lints)
  args <- append(
    list(x = astgrepr:::add_rulelist_class(lints)),
    vapply(lints, function(x) attributes(x)$other_info$fix, character(1))
  )
  names(args)[2:length(args)] <- names(lints)
  replacement2 <- as.call(append(astgrepr::node_replace_all, args)) |> eval()

  root <- astgrepr::tree_new(path) |>
    astgrepr::tree_root()

  out <- astgrepr::tree_rewrite(root, replacement2)
  class(out) <- c("tinylint_fix", class(out))
  attr(out, "original") <- text
  out
}

#' @export
fix_text <- function(text) {
  lints <- lint_text(text, return_nodes = TRUE)
  lints <- Filter(Negate(is.null), lints)
  args <- append(
    list(x = astgrepr:::add_rulelist_class(lints[[1]])),
    rep(attributes(lints[[1]])$other_info$fix, length(lints[[1]]))
  )
  names(args)[2:length(args)] <- names(lints[[1]])
  replacement2 <- as.call(append(astgrepr::node_replace, args)) |> eval()

  root <- astgrepr::tree_new(text) |>
    astgrepr::tree_root()

  out <- astgrepr::tree_rewrite(root, replacement2)
  class(out) <- c("tinylint_fix", class(out))
  attr(out, "original") <- text
  out
}
