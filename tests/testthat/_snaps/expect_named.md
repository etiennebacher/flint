# fix works for expect_named

    Code
      fix_text("expect_identical(names(x), c('a', 'b'))")
    Output
      Old code: expect_identical(names(x), c('a', 'b')) 
      New code: expect_named(x, c('a', 'b')) 

---

    Code
      fix_text("expect_identical('a', names(x))")
    Output
      Old code: expect_identical('a', names(x)) 
      New code: expect_named(x, 'a') 

---

    Code
      fix_text("expect_equal('a', names(x))")
    Output
      Old code: expect_equal('a', names(x)) 
      New code: expect_named(x, 'a') 

---

    Code
      fix_text("expect_equal(names(x), c('a', 'b'))")
    Output
      Old code: expect_equal(names(x), c('a', 'b')) 
      New code: expect_named(x, c('a', 'b')) 

---

    Code
      fix_text("expect_identical(names(x), c(\"a\", \"b\"))")
    Output
      Old code: expect_identical(names(x), c("a", "b")) 
      New code: expect_named(x, c("a", "b")) 

---

    Code
      fix_text("testthat::expect_equal('a', names(x))")
    Output
      Old code: testthat::expect_equal('a', names(x)) 
      New code: testthat::expect_named(x, 'a') 

---

    Code
      fix_text("expect_identical(names(xs), NULL)")
    Output
      Old code: expect_identical(names(xs), NULL) 
      New code: expect_null(names(xs)) 

