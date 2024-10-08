# fix works

    Code
      fix_text("rep(1:3, length.out = 5)", linters = linter)
    Output
      Old code: rep(1:3, length.out = 5) 
      New code: rep_len(1:3, 5) 

---

    Code
      fix_text("rep(x, length.out = 5)", linters = linter)
    Output
      Old code: rep(x, length.out = 5) 
      New code: rep_len(x, 5) 

