# fix works

    Code
      fix_text("expect_true(x > y)", linters = linter)
    Output
      Old code: expect_true(x > y) 
      New code: expect_gt(x, y) 

---

    Code
      fix_text("expect_true(x >= y)", linters = linter)
    Output
      Old code: expect_true(x >= y) 
      New code: expect_gte(x, y) 

---

    Code
      fix_text("expect_true(x < y)", linters = linter)
    Output
      Old code: expect_true(x < y) 
      New code: expect_lt(x, y) 

---

    Code
      fix_text("expect_true(x <= y)", linters = linter)
    Output
      Old code: expect_true(x <= y) 
      New code: expect_lte(x, y) 

