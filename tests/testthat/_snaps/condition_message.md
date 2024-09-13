# fix works

    Code
      fix_text("stop(paste0('a', 'b'))", linters = linter)
    Output
      Old code: stop(paste0('a', 'b')) 
      New code: stop('a', 'b') 

---

    Code
      fix_text("stop(paste0('a', 'b', collapse = 'e'))", linters = linter)

---

    Code
      fix_text("stop(paste0('a', 'b', recycle0 = 'e'))", linters = linter)

---

    Code
      fix_text("stop(paste0('a', 'b'), call. = FALSE)", linters = linter)
    Output
      Old code: stop(paste0('a', 'b'), call. = FALSE) 
      New code: stop('a', 'b') 

---

    Code
      fix_text("stop(paste0('a', 'b'), domain = FALSE)", linters = linter)
    Output
      Old code: stop(paste0('a', 'b'), domain = FALSE) 
      New code: stop('a', 'b') 

---

    Code
      fix_text("stop(domain = FALSE, paste0('a', 'b'))", linters = linter)
    Output
      Old code: stop(domain = FALSE, paste0('a', 'b')) 
      New code: stop('a', 'b') 

---

    Code
      fix_text("warning(paste0('a', 'b'))", linters = linter)
    Output
      Old code: warning(paste0('a', 'b')) 
      New code: warning('a', 'b') 

---

    Code
      fix_text("warning(paste0('a', 'b', collapse = 'e'))", linters = linter)

---

    Code
      fix_text("warning(paste0('a', 'b', sep = 'e'))", linters = linter)
    Output
      Old code: warning(paste0('a', 'b', sep = 'e')) 
      New code: warning('a', 'b', sep = 'e') 

---

    Code
      fix_text("warning(paste0('a', 'b'), immediate. = FALSE)", linters = linter)
    Output
      Old code: warning(paste0('a', 'b'), immediate. = FALSE) 
      New code: warning('a', 'b') 

---

    Code
      fix_text("warning(immediate. = FALSE, paste0('a', 'b'))", linters = linter)
    Output
      Old code: warning(immediate. = FALSE, paste0('a', 'b')) 
      New code: warning('a', 'b') 

