#' Automatically replace lints
#'
#' @inheritParams lint
#'
#' @export
fix <- function(
    path = ".",
    linters = NULL,
    exclude_path = NULL,
    exclude_linters = NULL,
    open = TRUE
) {

  linters <- resolve_linters(linters, exclude_linters)
  r_files <- resolve_path(path, exclude_path)
  rule_files <- fs::path(system.file(package = "flint"), "rules/", paste0(linters, ".yml"))
  fixes <- list()

  for (i in r_files) {
    root <- astgrepr::tree_new(file = i) |>
      astgrepr::tree_root()

    lints_raw <- astgrepr::node_find_all(root, files = rule_files)

    lints <- Filter(Negate(is.null), lints_raw)
    lints <- Filter(function(x) length(attributes(x)$other_info$fix) > 0, lints)
    if (length(lints) == 0) {
      next
    }
    args <- append(
      list(x = astgrepr:::add_rulelist_class(lints)),
      vapply(lints, function(x) as.character(attributes(x)$other_info$fix), character(1))
    )
    names(args)[2:length(args)] <- names(lints)
    replacement2 <- as.call(append(astgrepr::node_replace_all, args)) |> eval()

    fixes[[i]] <- astgrepr::tree_rewrite(root, replacement2)
    writeLines(text = fixes[[i]], i)
  }
  invisible(fixes)
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
