#' Hi there
#'
#' @export
fix <- function(path = ".", linters = NULL, open = TRUE) { # TODO: add a "linter" arg

  linters <- resolve_linters(linters)
  r_files <- resolve_path(path)
  rule_files <- fs::path(system.file(package = "flint"), "rules/", paste0(linters, ".yml"))
  fixes <- list()

  for (i in r_files) {
    root <- astgrepr::tree_new(file = i) |>
      astgrepr::tree_root()

    lints_raw <- astgrepr::node_find_all(root, files = rule_files)

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

    fixes[[i]] <- astgrepr::tree_rewrite(root, replacement2)
    writeLines(text = fixes[[i]], i)
  }
  fixes
}

#' @rdname fix
#' @export
fix_text <- function(text, linters = NULL) {
  tmp <- tempfile(fileext = ".R")
  text <- trimws(text)
  cat(text, file = tmp)
  out <- fix(tmp, linters = linters, open = FALSE)
  if (length(out) == 0) {
    return(invisible())
  }
  class(out) <- c("flint_fix", class(out))
  attr(out, "original") <- text
  out
}
