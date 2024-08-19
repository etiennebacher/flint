#' Automatically replace lints
#'
#' @description
#' `fix()`, `fix_package()`, and `fix_dir()` all replace lints in files. The
#' only difference is in the input they take:
#' * `fix()` takes path to files or directories
#' * `fix_dir()` takes a path to one directory
#' * `fix_package()` takes a path to the root of a package and looks at the
#' following list of folders: `R`, `tests`, `inst`, `vignettes`, `data-raw`,
#' `demo`, `exec`.
#'
#' `fix_text()` takes some text input. Its main interest is to be able to
#' quickly experiment with some lints and fixes.
#'
#' @inheritParams lint
#' @param force Force the application of fixes on the files. This is used only
#' in the case where Git is not detected, several files will be modified, and the
#' code is run in a non-interactive setting.
#' @inheritSection lint Ignoring lines
#'
#' @export
#' @examples
#' # `fix_text()` is convenient to explore with a small example
#' fix_text("any(duplicated(rnorm(5)))")
#'
#' fix_text("any(duplicated(rnorm(5)))
#' any(is.na(x))
#' ")
#'
#' # Setup for the example with `fix()`
#' destfile <- tempfile()
#' cat("
#' x = c(1, 2, 3)
#' any(duplicated(x), na.rm = TRUE)
#'
#' any(duplicated(x))
#'
#' if (any(is.na(x))) {
#'   TRUE
#' }
#'
#' any(
#'   duplicated(x)
#' )", file = destfile)
#'
#' fix(destfile)
#' cat(paste(readLines(destfile), collapse = "\n"))
fix <- function(
    path = ".",
    linters = NULL,
    exclude_path = NULL,
    exclude_linters = NULL,
    force = FALSE,
    verbose = TRUE
) {

  if (isFALSE(verbose) | is_testing()) {
    withr::local_options(cli.default_handler = function(...) { })
  }

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
    } else if (isFALSE(force)) {
      stop("It seems that you are not using Git, but `fix()` will be applied on several R files. This will make it difficult to see the changes in code. Therefore, this operation is not allowed in a non-interactive setting.")
    }
  }

  needed_fixing <- vector("list", length(r_files))

  cli::cli_alert_info("Going to check {length(r_files)} file{?s}.")
  i <- 0
  cli::cli_progress_bar(format = "{cli::pb_spin} Checking: {i}/{length(r_files)}")

  for (i in seq_along(r_files)) {
    file <- r_files[i]
    needed_fixing[[file]] <- TRUE
    root <- astgrepr::tree_new(file = file, ignore_tags = c("flint-ignore", "nolint")) |>
      astgrepr::tree_root()

    lints_raw <- astgrepr::node_find_all(root, files = rule_files)

    lints <- Filter(Negate(is.null), lints_raw)
    lints <- Filter(function(x) length(attributes(x)$other_info$fix) > 0, lints)
    if (length(lints) == 0) {
      needed_fixing[[file]] <- FALSE
      next
    }
    args <- append(
      list(x = astgrepr:::add_rulelist_class(lints)),
      vapply(lints, function(x) as.character(attributes(x)$other_info$fix), character(1))
    )
    names(args)[2:length(args)] <- names(lints)
    replacement2 <- as.call(append(astgrepr::node_replace_all, args)) |> eval()

    fixes[[file]] <- astgrepr::tree_rewrite(root, replacement2)
    writeLines(text = fixes[[file]], file)
    cli::cli_progress_update()
  }

  cli::cli_progress_done()

  if (!any(unlist(needed_fixing))) {
    cli::cli_alert_success("No fixes needed.")
  } else {
    cli::cli_alert_success("Fixed {length(Filter(isTRUE, needed_fixing))} file{?s}.")
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
