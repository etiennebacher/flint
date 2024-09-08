# fix works

    Code
      fix_text("expect_true(identical(x + 1, y))", linters = linter)
    Output
      Old code: expect_true(identical(x + 1, y)) 
      New code: expect_identical(x + 1, y) 

---

    Code
      fix_text("expect_equal(x + 1, y)", linters = linter)
    Output
      Old code: expect_equal(x + 1, y) 
      New code: expect_identical(x + 1, y) 

---

    Code
      fix_text("expect_equal(x + 1.1, y)", linters = linter)

