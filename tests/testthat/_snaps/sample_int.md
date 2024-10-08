# fix works

    Code
      fix_text("sample(1:2, 3)", linters = linter)
    Output
      Old code: sample(1:2, 3) 
      New code: sample.int(2, 3) 

---

    Code
      fix_text("sample(seq(2), 3)", linters = linter)
    Output
      Old code: sample(seq(2), 3) 
      New code: sample.int(2, 3) 

---

    Code
      fix_text("sample(seq_len(2), 3)", linters = linter)
    Output
      Old code: sample(seq_len(2), 3) 
      New code: sample.int(2, 3) 

---

    Code
      fix_text("sample(2:3, 3)", linters = linter)

