# fix works

    Code
      fix_text("any(!x)\nall(!y)")
    Output
      Old code:
      any(!x)
      all(!y)
      
      New code:
      !all(x)
      !any(y)

---

    Code
      fix_text("any(!f(x))\nall(!f(x))")
    Output
      Old code:
      any(!f(x))
      all(!f(x))
      
      New code:
      !all(f(x))
      !any(f(x))

