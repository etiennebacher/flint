# fix works

    Code
      fix_text("which(grepl('^a', x))", linters = linter)
    Output
      Old code: which(grepl('^a', x)) 
      New code: grep('^a', x) 

---

    Code
      fix_text("which(grepl('^a', x, ignore.case = TRUE))", linters = linter)
    Output
      Old code: which(grepl('^a', x, ignore.case = TRUE)) 
      New code: grep('^a', x, ignore.case = TRUE) 

