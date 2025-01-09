# nested lints

    Code
      fix_text("any(duplicated(any(is.na(x))))")
    Output
      Old code: any(duplicated(any(is.na(x)))) 
      New code: anyDuplicated(anyNA(x)) > 0 

---

    Code
      fix_text("any(duplicated(any(is.na(x <- T))))")
    Output
      Old code: any(duplicated(any(is.na(x <- T)))) 
      New code: anyDuplicated(anyNA(x <- TRUE)) > 0 

