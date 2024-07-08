# fix works

    Code
      fix_text("{\n  length(levels(x))\n  length(levels(y))\n}")
    Output
      Old code:
      {
        length(levels(x))
        length(levels(y))
      }
      
      New code:
      {
        nlevels(x)
        nlevels(y)
      }

