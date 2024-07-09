test_that("browser() call detected", {
  linter <- browser_linter()
  expect_lint("browser()", "Probably a forgotten debugging call?", linter)
  expect_lint("#browser()", NULL, linter)
})

test_that("browser() has no fix", {
  expect_snapshot(fix_text("browser()"))
})
