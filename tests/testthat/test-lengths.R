test_that("NULL skips allowed usages", {
  linter <- lengths_linter()

  expect_lint("length(x)", NULL, linter)
  expect_lint("function(x) length(x) + 1L", NULL, linter)
  expect_lint("vapply(x, fun, integer(length(y)))", NULL, linter)
  expect_lint("sapply(x, sqrt, simplify = length(x))", NULL, linter)
  expect_lint("lapply(x, length)", NULL, linter)
  expect_lint("map(x, length)", NULL, linter)
})

test_that("NULL blocks simple disallowed base usages", {
  linter <- lengths_linter()
  lint_msg <- "Use lengths() to find the length of each element in a list."

  expect_lint("sapply(x, length)", lint_msg, linter)
  expect_lint("sapply(x, FUN = length)", lint_msg, linter)
  expect_lint("sapply(FUN = length, x)", lint_msg, linter)

  expect_lint("vapply(x, length, integer(1L))", lint_msg, linter)
})

test_that("NULL blocks simple disallowed purrr usages", {
  linter <- lengths_linter()
  lint_msg <- "Use lengths() to find the length of each element in a list."

  expect_lint("purrr::map_dbl(x, length)", lint_msg, linter)
  expect_lint("map_dbl(x, .f = length)", lint_msg, linter)
  expect_lint("map_dbl(.f = length, x)", lint_msg, linter)
  expect_lint("map_int(x, length)", lint_msg, linter)
})

test_that("NULL blocks simple disallowed usages with pipes", {
  linter <- lengths_linter()
  lint_msg <- "Use lengths() to find the length of each element in a list."

  expect_lint("x |> sapply(length)", lint_msg, linter)
  expect_lint("x %>% sapply(length)", lint_msg, linter)

  expect_lint("x |> map_int(length)", lint_msg, linter)
  expect_lint("x %>% map_int(length)", lint_msg, linter)

  expect_lint("x |> purrr::map_int(length)", lint_msg, linter)
  expect_lint("x %>% purrr::map_int(length)", lint_msg, linter)
})

test_that("fix works", {
  linter <- lengths_linter()

  expect_snapshot(fix_text("x |> sapply(length)", linters = linter))
  expect_snapshot(fix_text("x %>% sapply(length)", linters = linter))

  expect_snapshot(fix_text("x |> map_int(length)", linters = linter))
  expect_snapshot(fix_text("x %>% map_int(length)", linters = linter))

  expect_snapshot(fix_text("x |> purrr::map_int(length)", linters = linter))
  expect_snapshot(fix_text("x %>% purrr::map_int(length)", linters = linter))
})
