# fix works

    Code
      fix_text("expect_equal(foo(x), TRUE)", linters = linter)
    Output
      Old code: expect_equal(foo(x), TRUE) 
      New code: expect_true(foo(x)) 

---

    Code
      fix_text("expect_equal(foo(x), FALSE)", linters = linter)
    Output
      Old code: expect_equal(foo(x), FALSE) 
      New code: expect_false(foo(x)) 

---

    Code
      fix_text("expect_identical(foo(x), TRUE)", linters = linter)
    Output
      Old code: expect_identical(foo(x), TRUE) 
      New code: expect_true(foo(x)) 

---

    Code
      fix_text("expect_identical(foo(x), FALSE)", linters = linter)
    Output
      Old code: expect_identical(foo(x), FALSE) 
      New code: expect_false(foo(x)) 

---

    Code
      fix_text("expect_equal(TRUE, foo(x))", linters = linter)
    Output
      Old code: expect_equal(TRUE, foo(x)) 
      New code: expect_true(foo(x)) 

---

    Code
      fix_text("expect_equal(FALSE, foo(x))", linters = linter)
    Output
      Old code: expect_equal(FALSE, foo(x)) 
      New code: expect_false(foo(x)) 

