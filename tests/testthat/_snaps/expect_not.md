# fix works

    Code
      fix_text("expect_true(!anyNA(x))", linters = linter)
    Output
      Old code: expect_true(!anyNA(x)) 
      New code: expect_false(anyNA(x)) 

---

    Code
      fix_text("expect_false(!anyNA(x))", linters = linter)
    Output
      Old code: expect_false(!anyNA(x)) 
      New code: expect_true(anyNA(x)) 

---

    Code
      fix_text("expect_true(!anyNA(x) & TRUE)", linters = linter)

---

    Code
      fix_text("expect_false(!anyNA(x) & TRUE)", linters = linter)

