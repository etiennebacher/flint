# fix works

    Code
      fix_text("expect_identical(x, NULL)", linters = linter)
    Output
      Old code: expect_identical(x, NULL) 
      New code: expect_null(x) 

---

    Code
      fix_text("expect_equal(x, NULL)", linters = linter)
    Output
      Old code: expect_equal(x, NULL) 
      New code: expect_null(x) 

---

    Code
      fix_text("expect_true(is.null(x))", linters = linter)
    Output
      Old code: expect_true(is.null(x)) 
      New code: expect_null(x) 

---

    Code
      fix_text("expect_identical(NULL, x)", linters = linter)
    Output
      Old code: expect_identical(NULL, x) 
      New code: expect_null(x) 

---

    Code
      fix_text("expect_equal(NULL, x)", linters = linter)
    Output
      Old code: expect_equal(NULL, x) 
      New code: expect_null(x) 

