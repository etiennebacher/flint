# fix 1:length(...) expressions

    Code
      fix_text("1:length(x)")
    Output
      Old code: 1:length(x) 
      New code: seq_along(x) 

---

    Code
      fix_text("1:nrow(x)")
    Output
      Old code: 1:nrow(x) 
      New code: seq_len(nrow(x)) 

---

    Code
      fix_text("1:ncol(x)")
    Output
      Old code: 1:ncol(x) 
      New code: seq_len(ncol(x)) 

---

    Code
      fix_text("1:NROW(x)")
    Output
      Old code: 1:NROW(x) 
      New code: seq_len(NROW(x)) 

---

    Code
      fix_text("1:NCOL(x)")
    Output
      Old code: 1:NCOL(x) 
      New code: seq_len(NCOL(x)) 

---

    Code
      fix_text("mutate(x, .id = 1:n())")
    Output
      Old code: mutate(x, .id = 1:n()) 
      New code: mutate(x, .id = seq_len(n())) 

# fix seq(...) expressions

    Code
      fix_text("seq(length(x))")
    Output
      Old code: seq(length(x)) 
      New code: seq_along(x) 

---

    Code
      fix_text("seq(nrow(x))")
    Output
      Old code: seq(nrow(x)) 
      New code: seq_len(nrow(x)) 

---

    Code
      fix_text("rev(seq(length(x)))")
    Output
      Old code: rev(seq(length(x))) 
      New code: rev(seq_along(x)) 

---

    Code
      fix_text("rev(seq(nrow(x)))")
    Output
      Old code: rev(seq(nrow(x))) 
      New code: rev(seq_len(nrow(x))) 

