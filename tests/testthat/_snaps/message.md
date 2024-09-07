# no lints found message works

    Code
      invisible(lint(dest))
    Message
      i Going to check 1 file.
      v No lints detected.

# found lint message works when no lint can be fixed

    Code
      invisible(lint(temp_dir))
    Message
      i Going to check 1 file.
      v Found 2 lints in 1 file.
      i None of them can be fixed automatically.

# found lint message works when lint can be fixed

    Code
      invisible(lint(temp_dir))
    Message
      i Going to check 1 file.
      v Found 2 lints in 1 file.
      i 2 of them can be fixed automatically.

---

    Code
      invisible(lint(temp_dir))
    Message
      i Going to check 2 files.
      v Found 2 lints in 2 files.
      i 2 of them can be fixed automatically.

# no fixes needed message works

    Code
      fix(dest)
    Message
      i Going to check 1 file.
      v No fixes needed.

# fix needed message works

    Code
      fix(temp_dir)
    Message
      i Going to check 1 file.
      v Fixed 2 lints in 1 file.

---

    Code
      fix(temp_dir, force = TRUE)
    Message
      i Going to check 2 files.
      v Fixed 2 lints in 2 files.

