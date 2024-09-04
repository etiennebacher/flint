# fix works

    Code
      fix_text("apply(x, 1, sum)", linters = linter)
    Output
      Old code: apply(x, 1, sum) 
      New code: rowSums(x) 

---

    Code
      fix_text("apply(x, MARGIN = 1, sum)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 1, sum) 
      New code: rowSums(x) 

---

    Code
      fix_text("apply(x, MARGIN = 1, FUN = sum)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 1, FUN = sum) 
      New code: rowSums(x) 

---

    Code
      fix_text("apply(x, MARGIN = 1, FUN = sum, na.rm = TRUE)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 1, FUN = sum, na.rm = TRUE) 
      New code: rowSums(x, na.rm = TRUE) 

---

    Code
      fix_text("apply(x, 2, sum)", linters = linter)
    Output
      Old code: apply(x, 2, sum) 
      New code: colSums(x) 

---

    Code
      fix_text("apply(x, MARGIN = 2, sum)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 2, sum) 
      New code: colSums(x) 

---

    Code
      fix_text("apply(x, MARGIN = 2, FUN = sum)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 2, FUN = sum) 
      New code: colSums(x) 

---

    Code
      fix_text("apply(x, MARGIN = 2, FUN = sum, na.rm = TRUE)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 2, FUN = sum, na.rm = TRUE) 
      New code: colSums(x, na.rm = TRUE) 

---

    Code
      fix_text("apply(x, 1, mean)", linters = linter)
    Output
      Old code: apply(x, 1, mean) 
      New code: rowMeans(x) 

---

    Code
      fix_text("apply(x, MARGIN = 1, mean)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 1, mean) 
      New code: rowMeans(x) 

---

    Code
      fix_text("apply(x, MARGIN = 1, FUN = mean)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 1, FUN = mean) 
      New code: rowMeans(x) 

---

    Code
      fix_text("apply(x, MARGIN = 1, FUN = mean, na.rm = TRUE)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 1, FUN = mean, na.rm = TRUE) 
      New code: rowMeans(x, na.rm = TRUE) 

---

    Code
      fix_text("apply(x, 2, mean)", linters = linter)
    Output
      Old code: apply(x, 2, mean) 
      New code: colMeans(x) 

---

    Code
      fix_text("apply(x, MARGIN = 2, mean)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 2, mean) 
      New code: colMeans(x) 

---

    Code
      fix_text("apply(x, MARGIN = 2, FUN = mean)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 2, FUN = mean) 
      New code: colMeans(x) 

---

    Code
      fix_text("apply(x, MARGIN = 2, FUN = mean, na.rm = TRUE)", linters = linter)
    Output
      Old code: apply(x, MARGIN = 2, FUN = mean, na.rm = TRUE) 
      New code: colMeans(x, na.rm = TRUE) 

