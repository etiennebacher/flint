#' Automatically replace lints
#'
#' @inheritParams lint
#' @inheritSection lint Ignoring lines
#'
#' @export
fix <- function(
    path = ".",
    linters = NULL,
    exclude_path = NULL,
    exclude_linters = NULL
) {

  linters2 <- resolve_linters(path, linters, exclude_linters)
  r_files <- resolve_path(path, exclude_path)
  rule_files <- resolve_rules(linters_is_null = is.null(linters), linters2, path)
  fixes <- list()

  if (length(r_files) > 1 && !uses_git()) {
    if (interactive()) {
      utils::menu(
        title = "This will run `fix()` on several R files. It seems that you are not using Git, which will make it difficult to see the changes in code. Do you want to continue?",
        choices = c("Yes", "No")
      )
    } else {
      stop("It seems that you are not using Git, but `fix()` will be applied on several R files. This will make it difficult to see the changes in code. Therefore, this operation is not allowed in a non-interactive setting.")
    }
  }

  for (i in r_files) {
    root <- astgrepr::tree_new(file = i, ignore_tags = c("flint-ignore", "nolint")) |>
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

fix_dir <- function(
    path = ".",
    linters = NULL,
    exclude_path = NULL,
    exclude_linters = NULL
) {
  if (!fs::is_dir(path)) {
    stop("`path` must be a directory.")
  }
  fix(
    path,
    linters = linters,
    exclude_path = exclude_path,
    exclude_linters = exclude_linters
  )
}

#' @rdname fix
#' @export

fix_package <- function(
    path = ".",
    linters = NULL,
    exclude_path = NULL,
    exclude_linters = NULL
) {
  if (!fs::is_dir(path)) {
    stop("`path` must be a directory.")
  }
  paths <- fs::path(path, c("R", "tests", "inst", "vignettes", "data-raw", "demo", "exec"))
  paths <- paths[fs::dir_exists(paths)]
  fix(
    path,
    linters = linters,
    exclude_path = exclude_path,
    exclude_linters = exclude_linters
  )
}

#' @param text Text to analyze (and to fix if necessary).
#'
#' @rdname fix
#' @export
fix_text <- function(text, linters = NULL, exclude_linters = NULL) {
  tmp <- tempfile(fileext = ".R")
  text <- trimws(text)
  cat(text, file = tmp)
  out <- fix(tmp, linters = linters, exclude_linters = exclude_linters)
  if (length(out) == 0) {
    return(invisible())
  }
  class(out) <- c("flint_fix", class(out))
  attr(out, "original") <- text
  out
}
