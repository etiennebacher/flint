test_that("lint: argument 'exclude_linters' works", {
	expect_lint(
		"any(duplicated(x))",
		NULL,
		linter = NULL,
		exclude_linters = "any_duplicated"
	)
})

test_that("fix: argument 'exclude_linters' works", {
	expect_fix(
		"any(duplicated(x))",
		character(0),
		linter = NULL,
		exclude_linters = "any_duplicated"
	)
})
