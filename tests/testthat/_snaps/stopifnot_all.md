# fix works

    Code
      fix_text("stopifnot(all(x > 0 & y < 1))", linters = linter)
    Output
      Old code: stopifnot(all(x > 0 & y < 1)) 
      New code: stopifnot(x > 0 & y < 1) 

---

    Code
      fix_text(lines, linters = linter)
    Output
      Old code:
      stopifnot(exprs = {
        all(x > 0 & y < 1)
      })
      
      New code:
      stopifnot(exprs = {
        x > 0 & y < 1
      })
      

