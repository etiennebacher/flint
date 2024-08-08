# fix works

    Code
      fix_text("length(x == 0)", linters = linter)
    Output
      Old code: length(x == 0) 
      New code: length(x) == 0 

---

    Code
      fix_text("length(x != 0)", linters = linter)
    Output
      Old code: length(x != 0) 
      New code: length(x) != 0 

---

    Code
      fix_text("length(x >= 0)", linters = linter)
    Output
      Old code: length(x >= 0) 
      New code: length(x) >= 0 

---

    Code
      fix_text("length(x <= 0)", linters = linter)
    Output
      Old code: length(x <= 0) 
      New code: length(x) <= 0 

---

    Code
      fix_text("length(x > 0)", linters = linter)
    Output
      Old code: length(x > 0) 
      New code: length(x) > 0 

---

    Code
      fix_text("length(x < 0)", linters = linter)
    Output
      Old code: length(x < 0) 
      New code: length(x) < 0 

