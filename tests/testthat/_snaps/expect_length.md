# fix works

    Code
      fix_text("expect_equal(length(x), 2L)", linters = linter)
    Output
      Old code: expect_equal(length(x), 2L) 
      New code: expect_length(x, 2L) 

---

    Code
      fix_text("expect_identical(length(x), 2L)", linters = linter)
    Output
      Old code: expect_identical(length(x), 2L) 
      New code: expect_length(x, 2L) 

---

    Code
      fix_text("expect_equal(2L, length(x))", linters = linter)
    Output
      Old code: expect_equal(2L, length(x)) 
      New code: expect_length(x, 2L) 

---

    Code
      fix_text("expect_identical(2L, length(x))", linters = linter)
    Output
      Old code: expect_identical(2L, length(x)) 
      New code: expect_length(x, 2L) 

