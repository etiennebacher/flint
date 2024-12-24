lint_message <- "anyNA(x) is better than any(is.na(x))."

test_that("any_is_na_linter skips allowed usages", {
	linter <- any_is_na_linter()

	expect_lint("x <- any(y)", NULL, linter)
	expect_lint("y <- is.na(z)", NULL, linter)

	# negation shouldn't list
	expect_lint("any(!is.na(x))", NULL, linter)
	expect_lint("any(!is.na(foo(x)))", NULL, linter)
})

test_that("any_is_na_linter blocks disallowed usages", {
	# linter <- any_is_na_linter()
	linter <- any_is_na_linter()

	expect_lint("any(is.na(x))", lint_message, linter)
	expect_lint("any(is.na(foo(x)))", lint_message, linter)

	# extended usage of ... arguments
	expect_lint("any(is.na(y), b)", lint_message, linter)
	expect_lint("any(b, is.na(y))", lint_message, linter)

	# na.rm doesn't really matter for this since is.na can't return NA
	expect_lint("any(is.na(x), na.rm = TRUE)", lint_message, linter)

	# also catch nested usage
	expect_lint("foo(any(is.na(x)))", lint_message, linter)
})
