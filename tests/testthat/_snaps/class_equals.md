# fix works

    Code
      fix_text("class(x) == 'character'")
    Output
      Old code: class(x) == 'character' 
      New code: inherits(x, 'character') 

---

    Code
      fix_text("\"class(x) == 'character'\"")

---

    Code
      fix_text("class(x) != 'character'")
    Output
      Old code: class(x) != 'character' 
      New code: !inherits(x, 'character') 

---

    Code
      fix_text("\"class(x) != 'character'\"")

---

    Code
      fix_text("'character' %in% class(x)")
    Output
      Old code: 'character' %in% class(x) 
      New code: inherits(x, 'character') 

---

    Code
      fix_text("\"'character' %in% class(x)\"")

---

    Code
      fix_text("!'character' %in% class(x)")
    Output
      Old code: !'character' %in% class(x) 
      New code: !inherits(x, 'character') 

---

    Code
      fix_text("! 'character' %in% class(x)")
    Output
      Old code: ! 'character' %in% class(x) 
      New code: ! inherits(x, 'character') 

---

    Code
      fix_text("!('character' %in% class(x))")
    Output
      Old code: !('character' %in% class(x)) 
      New code: !inherits(x, 'character') 

