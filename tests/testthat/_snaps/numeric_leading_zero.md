# fix works

    Code
      fix_text("0.1 + .22-0.3-.2")
    Output
      Old code: 0.1 + .22-0.3-.2 
      New code: 0.1 + 0.22-0.3-0.2 

---

    Code
      fix_text("d <- 6.7 + .8i")
    Output
      Old code: d <- 6.7 + .8i 
      New code: d <- 6.7 + 0.8i 

---

    Code
      fix_text(".7i + .2 + .8i")
    Output
      Old code: .7i + .2 + .8i 
      New code: 0.7i + 0.2 + 0.8i 

---

    Code
      fix_text("'some text .7'")

