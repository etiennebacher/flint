# fix works

    Code
      fix_text("expect_equal(typeof(x), 'double')", linters = linter)
    Output
      Old code: expect_equal(typeof(x), 'double') 
      New code: expect_type(x, 'double') 

---

    Code
      fix_text("expect_equal(typeof(x), \"double\")", linters = linter)
    Output
      Old code: expect_equal(typeof(x), "double") 
      New code: expect_type(x, "double") 

---

    Code
      fix_text("expect_identical(typeof(x), 'double')", linters = linter)
    Output
      Old code: expect_identical(typeof(x), 'double') 
      New code: expect_type(x, 'double') 

---

    Code
      fix_text("expect_identical(typeof(x), \"double\")", linters = linter)
    Output
      Old code: expect_identical(typeof(x), "double") 
      New code: expect_type(x, "double") 

---

    Code
      fix_text("expect_equal('double', typeof(x))", linters = linter)
    Output
      Old code: expect_equal('double', typeof(x)) 
      New code: expect_type(x, 'double') 

---

    Code
      fix_text("expect_identical('double', typeof(x))", linters = linter)
    Output
      Old code: expect_identical('double', typeof(x)) 
      New code: expect_type(x, 'double') 

---

    Code
      fix_text("expect_true(is.complex(foo(x)))", linters = linter)

# no double replacement

    Code
      fix_text("expect_equal(typeof(x), 'double')")
    Output
      Old code: expect_equal(typeof(x), 'double') 
      New code: expect_type(x, 'double') 

