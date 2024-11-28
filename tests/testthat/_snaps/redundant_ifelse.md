# fix works

    Code
      fix_text("ifelse(x > 5, TRUE, FALSE)")
    Output
      Old code: ifelse(x > 5, TRUE, FALSE) 
      New code: x > 5 

---

    Code
      fix_text("if_else(x > 5, TRUE, FALSE)")
    Output
      Old code: if_else(x > 5, TRUE, FALSE) 
      New code: x > 5 

---

    Code
      fix_text("fifelse(x > 5, TRUE, FALSE)")
    Output
      Old code: fifelse(x > 5, TRUE, FALSE) 
      New code: x > 5 

---

    Code
      fix_text("ifelse(x > 5, FALSE, TRUE)")
    Output
      Old code: ifelse(x > 5, FALSE, TRUE) 
      New code: !(x > 5) 

---

    Code
      fix_text("if_else(x > 5, FALSE, TRUE)")
    Output
      Old code: if_else(x > 5, FALSE, TRUE) 
      New code: !(x > 5) 

---

    Code
      fix_text("fifelse(x > 5, FALSE, TRUE)")
    Output
      Old code: fifelse(x > 5, FALSE, TRUE) 
      New code: !(x > 5) 

---

    Code
      fix_text("ifelse(x > 5, 0, 1L)")
    Output
      Old code: ifelse(x > 5, 0, 1L) 
      New code: as.integer(!(x > 5)) 

---

    Code
      fix_text("if_else(x > 5, 0, 1L)")
    Output
      Old code: if_else(x > 5, 0, 1L) 
      New code: as.integer(!(x > 5)) 

---

    Code
      fix_text("fifelse(x > 5, 0, 1L)")
    Output
      Old code: fifelse(x > 5, 0, 1L) 
      New code: as.integer(!(x > 5)) 

---

    Code
      fix_text("ifelse(x > 5, 1L, 0L)")
    Output
      Old code: ifelse(x > 5, 1L, 0L) 
      New code: as.integer(x > 5) 

---

    Code
      fix_text("if_else(x > 5, 1L, 0L)")
    Output
      Old code: if_else(x > 5, 1L, 0L) 
      New code: as.integer(x > 5) 

---

    Code
      fix_text("fifelse(x > 5, 1L, 0L)")
    Output
      Old code: fifelse(x > 5, 1L, 0L) 
      New code: as.integer(x > 5) 

