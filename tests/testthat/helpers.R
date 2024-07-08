library(fs)
library(usethis)
library(withr)

expect_lint <- function(x, message, linter, ...) {
  if (is.null(linter)) {
    linter <- list_linters()
  }
  out <- lint_text(x, linters = linter, ...)
  if (is.null(message)) {
    testthat::expect_true(length(out) == 0)
  } else {
    testthat::expect_true(
      nrow(out) > 0 && any(message == out$message | grepl(message, out$message, fixed = TRUE))
    )
  }
}

expect_fix <- function(x, replacement, ...) {
  out <- fix_text(x, ...)
  testthat::expect_equal(as.character(out), replacement)
}

trim_some <- function(x, num = NULL) {
  x <- rex::re_substitutes(
    x,
    rex::rex(list(start, any_blanks, newline) %or% list(newline, any_blanks, end)),
    replacement = "",
    global = TRUE
  )

  if (is.null(num)) {
    ms <- rex::re_matches(x, "^\\s+", locations = TRUE, global = TRUE, options = "multi-line")[[1L]]
    num <- min(ms$end - ms$start) + 1L
  }

  rex::re_substitutes(x, rex::rex(start, n_times(any, num)), "", global = TRUE, options = "multi-line")
}


### Taken from {usethis} (file "R/project.R")

proj <- new.env(parent = emptyenv())

proj_get_ <- function() proj$cur

proj_set_ <- function(path) {
  old <- proj$cur
  proj$cur <- path
  invisible(old)
}



### Taken from {usethis} (file "tests/testthat/helper.R")

create_local_package <- function(
    dir = fs::file_temp(pattern = "testpkg"),
    env = parent.frame(),
    rstudio = TRUE) {
  suppressMessages(create_local_thing(dir, env, rstudio, "package"))
}


create_local_project <- function(
    dir = fs::file_temp(pattern = "testproj"),
    env = parent.frame(),
    rstudio = FALSE) {
  suppressMessages(create_local_thing(dir, env, rstudio, "project"))
}


create_local_thing <- function(
    dir = fs::file_temp(pattern = pattern),
    env = parent.frame(),
    rstudio = FALSE,
    thing = c("package", "project")) {
  thing <- match.arg(thing)
  if (fs::dir_exists(dir)) {
    ui_stop("Target {ui_code('dir')} {.file {dir}} already exists.")
  }

  old_project <- proj_get_() # this could be `NULL`, i.e. no active project
  old_wd <- getwd() # not necessarily same as `old_project`

  withr::defer(
    {
      fs::dir_delete(dir)
    },
    envir = env
  )
  usethis::ui_silence(
    switch(thing,
           package = create_package(dir, rstudio = rstudio, open = FALSE, check_name = FALSE),
           project = create_project(dir, rstudio = rstudio, open = FALSE)
    )
  )

  suppressMessages({
    defer(proj_set(old_project, force = TRUE), envir = env)
    proj_set(dir)
  })

  defer(
    {
      setwd(old_wd)
    },
    envir = env
  )
  setwd(proj_get())

  invisible(proj_get())
}


expect_proj_file <- function(...) expect_true(fs::file_exists(proj_path(...)))
