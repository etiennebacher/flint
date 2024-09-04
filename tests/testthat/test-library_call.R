test_that("library_call_linter skips allowed usages", {
  linter <- library_call_linter()

  expect_lint(
    trim_some("
      library(dplyr)
      print('test')
    "),
    NULL,
    linter
  )

  expect_lint("print('test')",
    NULL,
    linter
  )

  expect_lint(
    trim_some("
      # comment
      library(dplyr)
    "),
    NULL,
    linter
  )

  expect_lint(
    trim_some("
      print('test')
      # library(dplyr)
    "),
    NULL,
    linter
  )

  # TODO
  # expect_lint(
  #   trim_some("
  #     suppressPackageStartupMessages({
  #       library(dplyr)
  #       library(knitr)
  #     })
  #   "),
  #   NULL,
  #   linter
  # )
})

test_that("library_call_linter warns on disallowed usages", {
  linter <- library_call_linter()
  lint_message <- "Move all library/require calls to the top of the script."

  expect_lint(
    trim_some("
      library(dplyr)
      print('test')
      library(tidyr)
    "),
    lint_message,
    linter
  )

  expect_lint(
    trim_some("
      library(dplyr)
      print('test')
      library(tidyr)
      library(purrr)
    "),
    lint_message,
    linter
  )

  expect_lint(
    trim_some("
      library(dplyr)
      print('test')
      library(tidyr)
      print('test')
    "),
    lint_message,
    linter
  )

  # TODO
  # expect_lint(
  #   trim_some("
  #     library(dplyr)
  #     print('test')
  #     suppressMessages(library('lubridate', character.only = TRUE))
  #     suppressMessages(library(tidyr))
  #     print('test')
  #   "),
  #   lint_message,
  #   linter
  # )
})

test_that("require() treated the same as library()", {
  linter <- library_call_linter()
  lint_message_library <- "Move all library/require calls to the top of the script."
  lint_message_require <- "Move all require calls to the top of the script."

  expect_lint(
    trim_some("
      library(dplyr)
      require(tidyr)
    "),
    NULL,
    linter
  )

  expect_lint(
    trim_some("
      library(dplyr)
      print(letters)
      require(tidyr)
    "),
    lint_message_library,
    linter
  )

  expect_lint(
    trim_some("
      library(dplyr)
      print(letters)
      library(dbplyr)
      require(tidyr)
    "),
    lint_message_library,
    linter
  )
})

test_that("skips allowed usages of library()/character.only=TRUE", {
  linter <- library_call_linter()

  expect_lint("library(data.table)", NULL, linter)
  expect_lint("function(pkg) library(pkg, character.only = TRUE)", NULL, linter)
  expect_lint("function(pkgs) sapply(pkgs, require, character.only = TRUE)", NULL, linter)
})

# test_that("blocks disallowed usages of strings in library()/require()", {
#   linter <- library_call_linter()
#   char_only_msg <- rex::rex("Use symbols in library calls", anything, "character.only")
#   direct_stub <- "Call library() directly, not vectorized with "
#
#   expect_lint(
#     'library("data.table")',
#     rex::rex("Use symbols, not strings, in library calls."),
#     linter
#   )
#
#   expect_lint('library("data.table", character.only = TRUE)', char_only_msg, linter)
#   expect_lint('suppressWarnings(library("data.table", character.only = TRUE))', char_only_msg, linter)
#
#   expect_lint(
#     "do.call(library, list(data.table))",
#     rex::rex(direct_stub, "do.call()"),
#     linter
#   )
#   expect_lint(
#     'do.call("library", list(data.table))',
#     rex::rex(direct_stub, "do.call()"),
#     linter
#   )
#   expect_lint(
#     'lapply("data.table", library, character.only = TRUE)',
#     rex::rex(direct_stub, "lapply()"),
#     linter
#   )
#   expect_lint(
#     'purr::map("data.table", library, character.only = TRUE)',
#     rex::rex(direct_stub, "map()"),
#     linter
#   )
# })
#
# test_that("character.only=TRUE is caught in *apply functions passed as strings", {
#   linter <- library_call_linter()
#   lib_msg <- rex::rex("Call library() directly, not vectorized with sapply()")
#   req_msg <- rex::rex("Call require() directly, not vectorized with sapply()")
#
#   expect_lint("sapply(pkgs, 'library', character.only = TRUE)", lib_msg, linter)
#   expect_lint('sapply(pkgs, "library", character.only = TRUE)', lib_msg, linter)
#   expect_lint("sapply(pkgs, 'require', character.only = TRUE)", req_msg, linter)
#   expect_lint('sapply(pkgs, "require", character.only = TRUE)', req_msg, linter)
# })
#
# test_that("character.only=TRUE is caught with multiple-line source", {
#   expect_lint(
#     trim_some('
#       suppressWarnings(library(
#         "data.table",
#         character.only = TRUE
#       ))
#     '),
#     rex::rex("Use symbols in library calls", anything, "character.only"),
#     library_call_linter()
#   )
# })
#
# test_that("character.only=TRUE is caught inside purrr::walk as well", {
#   expect_lint(
#     'purr::walk("data.table", library, character.only = TRUE)',
#     rex::rex("Call library() directly, not vectorized with walk()"),
#     library_call_linter()
#   )
# })
#
# test_that("multiple lints are generated correctly", {
#   expect_lint(
#     trim_some('{
#       library("dplyr", character.only = TRUE)
#       print("not a library call")
#       require("gfile")
#       sapply(pkg_list, "library", character.only = TRUE)
#       purrr::walk(extra_list, require, character.only = TRUE)
#     }'),
#     list(
#       list(message = rex::rex("library calls", anything, "character.only")),
#       list(message = rex::rex("Move all require calls to the top of the script.")),
#       list(message = "symbols, not strings, in require calls"),
#       list(message = rex::rex("library() directly", anything, "vectorized with sapply()")),
#       list(message = rex::rex("require() directly", anything, "vectorized with walk()"))
#     ),
#     library_call_linter()
#   )
# })

patrick::with_parameters_test_that(
  "library_call_linter skips allowed usages",
  {
    linter <- library_call_linter()

    expect_lint(sprintf("%s(x)", call), NULL, linter)
    expect_lint(sprintf("%s(x, y, z)", call), NULL, linter)

    # intervening expression
    expect_lint(sprintf("%1$s(x); y; %1$s(z)", call), NULL, linter)

    # inline or potentially with gaps don't matter
    expect_lint(
      trim_some(glue::glue("
        {call}(x)
        y

        stopifnot(z)
      ")),
      NULL,
      linter
    )

    # only suppressing calls with library()
    expect_lint(
      trim_some(glue::glue("
        {call}(x)
        {call}(y)
      ")),
      NULL,
      linter
    )
  },
  .test_name = c("suppressMessages", "suppressPackageStartupMessages"),
  call = c("suppressMessages", "suppressPackageStartupMessages")
)

# patrick::with_parameters_test_that(
#   "library_call_linter blocks simple disallowed usages",
#   {
#     linter <- library_call_linter()
#     lint_msg <- sprintf("Unify consecutive calls to %s\\(\\)\\.", call)
#
#     # one test of inline usage
#     expect_lint(sprintf("%1$s(library(x)); %1$s(library(y))", call), lint_msg, linter)
#
#     expect_lint(
#       trim_some(glue::glue("
#         {call}(library(x))
#
#         {call}(library(y))
#       ")),
#       lint_msg,
#       linter
#     )
#
#     expect_lint(
#       trim_some(glue::glue("
#         {call}(require(x))
#         {call}(require(y))
#       ")),
#       lint_msg,
#       linter
#     )
#
#     expect_lint(
#       trim_some(glue::glue("
#         {call}(library(x))
#         # a comment on y
#         {call}(library(y))
#       ")),
#       lint_msg,
#       linter
#     )
#   },
#   .test_name = c("suppressMessages", "suppressPackageStartupMessages"),
#   call = c("suppressMessages", "suppressPackageStartupMessages")
# )
#
# test_that("Namespace differences are detected", {
#   linter <- library_call_linter()
#
#   # totally different namespaces
#   expect_lint(
#     "ns::suppressMessages(library(x)); base::suppressMessages(library(y))",
#     NULL,
#     linter
#   )
#
#   # one namespaced, one not
#   expect_lint(
#     "ns::suppressMessages(library(x)); suppressMessages(library(y))",
#     NULL,
#     linter
#   )
# })

test_that("Consecutive calls to different blocked calls is OK", {
  expect_lint(
    "suppressPackageStartupMessages(library(x)); suppressMessages(library(y))",
    NULL,
    library_call_linter()
  )
})
