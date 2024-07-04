#' @export
fix <- function(path = ".", linters = NULL, open = TRUE, return_nodes = FALSE) { # TODO: add a "linter" arg

  if (!is.null(linters) && !all(linters %in% list_linters())) {
    stop(paste0("Unknown linters: ", toString(setdiff(linters, list_linters()))))
  } else if (is.null(linters)) {
    linters <- list_linters()
  }

  if (fs::is_dir(path)) {
    r_files <- list.files(path, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
  } else {
    r_files <- path
  }
  lints <- list()

  for (i in r_files) {
    root <- astgrepr::tree_new(file = i) |>
      astgrepr::tree_root()

    files <- fs::path(system.file(package = "flint"), "rules/", paste0(linters, ".yml"))
    lints_raw <- astgrepr::node_find_all(root, files = files)

    if (all(lengths(lints_raw) == 0)) {
      next
    }

    lints <- Filter(Negate(is.null), lints_raw)
    args <- append(
      list(x = astgrepr:::add_rulelist_class(lints)),
      vapply(lints, function(x) attributes(x)$other_info$fix, character(1))
    )
    names(args)[2:length(args)] <- names(lints)
    replacement2 <- as.call(append(astgrepr::node_replace_all, args)) |> eval()

    out <- astgrepr::tree_rewrite(root, replacement2)
    writeLines(text = out, i)
  }

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
  class(out) <- c("flint_fix", class(out))
  attr(out, "original") <- text
  out
}
