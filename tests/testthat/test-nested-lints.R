test_that("nested lints", {
  expect_snapshot(fix_text("any(duplicated(any(is.na(x))))"))
  expect_snapshot(fix_text("any(duplicated(any(is.na(x <- T))))"))
})
