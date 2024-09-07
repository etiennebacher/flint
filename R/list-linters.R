#' Get the list of linters in `flint`
#'
#' @return A character vector
#' @export
#'
#' @examples
#' list_linters()
list_linters <- function() {

  c(
    # "absolute_path", # TODO: really broken, too many false positives, e.g #42
    "any_duplicated",
    "any_is_na",
    "class_equals",
    "double_assignment",
    "duplicate_argument",
    "empty_assignment",
    "equal_assignment",
    "equals_na",
    "expect_comparison",
    "expect_length",
    "expect_named",
    "expect_not",
    "expect_null",
    "expect_true_false",
    "expect_type",
    "for_loop_index",
    "function_return",
    "implicit_assignment",
    "is_numeric",
    "length_levels",
    "length_test",
    "lengths",
    "library_call",
    "literal_coercion",
    "matrix_apply",
    "missing_argument",
    "nested_ifelse",
    "numeric_leading_zero",
    "outer_negation",
    "package_hooks",
    "paste",
    "redundant_equals",
    "redundant_ifelse",
    "right_assignment",
    "semicolon",
    "seq",
    "sort",
    "T_and_F_symbol",
    "todo_comment",
    "undesirable_function",
    "undesirable_operator",
    "unnecessary_nesting",
    "unreachable_code"
  )

}


#' suppressWarnings(file.remove("R/linters_factory.R"))
#' for (i in list_linters()) {
#'   if (grepl("assignment", i)) {
#'     cat(
#'       sprintf(
#' "\n
#' #' %s",
#'         i
#'       ),
#'       file = "R/linters_factory.R",
#'       append = TRUE
#'     )
#'   } else {
#'     cat(
#'       sprintf(
#' "\n
#' #' @inherit lintr::%s_linter title
#' #' @description
#' #' See <https://lintr.r-lib.org/reference/%s_linter>.",
#'         i, i
#'       ),
#'       file = "R/linters_factory.R",
#'       append = TRUE
#'     )
#'   }
#'   cat(
#'     sprintf(
#' "\n
#' #' @usage %s_linter
#' #' @name %s_linter
#' #' @export
#' NULL
#' makeActiveBinding('%s_linter', function() { function() '%s' }, env = environment())\n
#' ",
#'       i, i, i, i
#'     ),
#'     file = "R/linters_factory.R",
#'     append = TRUE
#'   )
#' }
#' cat(
#'   paste0(
#'     "keep:\n",
#'     paste("  -", list_linters(), collapse = "\n")
#'   ),
#'   file = "inst/config.yml"
#' )

