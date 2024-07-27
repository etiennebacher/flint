#' Get the list of linters in `flint`
#'
#' @return A character vector
#' @export
#'
#' @examples
#' list_linters()
list_linters <- function() {

  c(
    "any_duplicated",
    "any_is_na",
    "class_equals",
    "double_assignment",
    "empty_assignment",
    "equal_assignment",
    "equals_na",
    "expect_length",
    "expect_named",
    "expect_not",
    "expect_null",
    "expect_true_false",
    "expect_type",
    "implicit_assignment",
    "is_numeric",
    "length_levels",
    "length_test",
    "lengths",
    "library_call",
    "literal_coercion",
    "matrix_apply",
    "nested_ifelse",
    "numeric_leading_zero",
    "outer_negation",
    "paste",
    "redundant_ifelse",
    "right_assignment",
    "semicolon",
    "seq",
    "sort",
    "T_and_F_symbol",
    "undesirable_function",
    "unreachable_code"
  )

}


#' suppressWarnings(file.remove("R/linters_factory.R"))
#' for (i in list_linters()) {
#'   cat(
#'     sprintf(
#' "\n
#' #' %s
#' #' @usage %s_linter
#' #' @name %s_linter
#' #' @export
#' NULL
#' makeActiveBinding('%s_linter', function() { function() '%s' }, env = environment())\n
#' ",
#'     i, i, i, i, i
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

