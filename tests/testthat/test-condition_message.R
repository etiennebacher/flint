test_that("condition_message_linter skips allowed usages", {
  linter <- condition_message_linter()

  expect_lint("stop('a string', 'another')", NULL, linter)
  expect_lint("warning('a string', 'another')", NULL, linter)
  expect_lint("message('a string', 'another')", NULL, linter)
  # extracted calls likely don't obey base::stop() semantics
  expect_lint("ctx$stop(paste('a', 'b'))", NULL, linter)
  expect_lint("ctx@stop(paste('a', 'b'))", NULL, linter)

  # sprintf is OK -- gettextf() enforcement is left to other linters
  expect_lint("stop(sprintf('A %s!', 'string'))", NULL, linter)

  # get multiple sep= in one expression
  expect_lint(
    trim_some("
      tryCatch(
        foo(x),
        error = function(e) stop(paste(a, b, sep = '-')),
        warning = function(w) warning(paste(a, b, sep = '--')),
      )
    "),
    NULL,
    linter
  )
})

skip_if_not_installed("tibble")
patrick::with_parameters_test_that(
  "paste/paste0 allowed by condition_message_linter when using other seps and/or collapse",
  expect_lint(
    sprintf("%s(%s(x, %s = '%s'))", condition, fun, parameter, arg),
    NULL,
    condition_message_linter()
  ),
  .cases = tibble::tribble(
    ~.test_name,                           ~condition, ~fun,     ~parameter, ~arg,
    "stop, paste and collapse = ''",       "stop",     "paste",  "collapse",  "",
    "warning, paste and collapse = '\n'",  "warning",  "paste",  "collapse",  "\n",
    "message, paste and collapse = '|'",   "message",  "paste",  "collapse",  "|",
    "stop, paste0 and collapse = ''",      "stop",     "paste0", "collapse",  "",
    "warning, paste0 and collapse = '\n'", "warning",  "paste0", "collapse",  "\n",
    "message, paste0 and collapse = '|'",  "message",  "paste0", "collapse",  "|",
    "stop, paste and sep = '-'",           "stop",     "paste",  "sep",       "-",
    "warning, paste and sep = '\n'",       "warning",  "paste",  "sep",       "\n",
    "message, paste and sep = '|'",        "message",  "paste",  "sep",       "|"
  )
)

test_that("condition_message_linter blocks simple disallowed usages", {
  expect_lint(
    "stop(paste('a string', 'another'))",
    "Don't use paste to build stop strings.",
    condition_message_linter()
  )

  expect_lint(
    "warning(paste0('a string ', 'another'))",
    "Don't use paste0 to build warning strings.",
    condition_message_linter()
  )

  # TODO: `sep` argument should be linted if it has the default value
  # expect_lint(
  #   "stop(paste(x, sep = ' '))",
  #   "Don't use paste to build stop strings.",
  #   condition_message_linter()
  # )

  # not thrown off by named arguments
  expect_lint(
    "stop(paste('a', 'b'), call. = FALSE)",
    "Don't use paste to build stop strings.",
    condition_message_linter()
  )

  expect_lint(
    "warning(paste0('a', 'b'), immediate. = TRUE)",
    "Don't use paste0 to build warning strings.",
    condition_message_linter()
  )

  expect_lint(
    trim_some("
      tryCatch(
        foo(x),
        error = function(e) stop(paste(a, b)),
        warning = function(w) warning(paste(a, b, sep = '--')),
      )
    "),
    "Don't use paste to build stop strings.",
    condition_message_linter()
  )

  # one with no sep, one with linted sep
  expect_equal(nrow(lint_text(
    trim_some("
      tryCatch(
        foo(x),
        error = function(e) stop(paste(a, b)),
        warning = function(w) warning(paste(a, b, sep = '')),
      )
    "),
    linters = condition_message_linter()
  )), 1)
})

test_that("packageStartupMessage usages are also matched", {
  expect_lint(
    "packageStartupMessage(paste('a string', 'another'))",
    "Don't use paste to build packageStartupMessage strings.",
    condition_message_linter()
  )

  expect_lint(
    "packageStartupMessage(paste0('a string ', 'another'))",
    "Don't use paste0 to build packageStartupMessage strings.",
    condition_message_linter()
  )
})

# test_that("R>=4.0.0 raw strings are handled", {
#   skip_if_not_r_version("4.0.0")
#   expect_lint(
#     "warning(paste(a, b, sep = R'( )'))",
#     "Don't use paste to build warning strings.",
#     condition_message_linter()
#   )
#   expect_lint(
#     "warning(paste(a, b, sep = R'---[ ]---'))",
#     "Don't use paste to build warning strings.",
#     condition_message_linter()
#   )
# })

test_that("fix works", {
  linter <- condition_message_linter()

  expect_snapshot(fix_text("stop(paste('a', 'b'))", linters = linter))
  expect_snapshot(fix_text("stop(paste('a', 'b', collapse = 'e'))", linters = linter))
  expect_snapshot(fix_text("stop(paste('a', 'b', sep = 'e'))", linters = linter))
  expect_snapshot(fix_text("stop(paste('a', 'b'), call. = FALSE)", linters = linter))
  expect_snapshot(fix_text("stop(paste('a', 'b'), domain = FALSE)", linters = linter))
  expect_snapshot(fix_text("stop(domain = FALSE, paste('a', 'b'))", linters = linter))

  expect_snapshot(fix_text("warning(paste('a', 'b'))", linters = linter))
  expect_snapshot(fix_text("warning(paste('a', 'b', collapse = 'e'))", linters = linter))
  expect_snapshot(fix_text("warning(paste('a', 'b', sep = 'e'))", linters = linter))
  expect_snapshot(fix_text("warning(paste('a', 'b'), immediate. = FALSE)", linters = linter))
  expect_snapshot(fix_text("warning(immediate. = FALSE, paste('a', 'b'))", linters = linter))
})
