# fix works

    Code
      fix_text("y[order(y)]", linters = linter)
    Output
      Old code: y[order(y)] 
      New code: sort(y, na.last = TRUE) 

---

    Code
      fix_text("y[order(y, decreasing = FALSE)]", linters = linter)
    Output
      Old code: y[order(y, decreasing = FALSE)] 
      New code: sort(y, decreasing = FALSE, na.last = TRUE) 

---

    Code
      fix_text("y[order(y, na.last = FALSE)]", linters = linter)
    Output
      Old code: y[order(y, na.last = FALSE)] 
      New code: sort(y, na.last = FALSE, na.last = TRUE) 

---

    Code
      fix_text("sort(x + y) == x + y", linters = linter)

---

    Code
      fix_text("sort(x + y) != x + y", linters = linter)

