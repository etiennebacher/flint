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
    "equal_assignment",
    "equals_na",
    "expect_named",
    "is_numeric",
    "length_levels",
    "length_test",
    "lengths",
    "library_call",
    "literal_coercion",
    "implicit_assignment",
    "matrix_apply",
    "nested_ifelse",
    "numeric_leading_zero",
    "outer_negation",
    "paste",
    "redundant_ifelse",
    "right_assignment",
    "semicolon",
    "seq",
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

