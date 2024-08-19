# no lints found message works

    Code
      invisible(lint(dest))
    Message
      i Going to check 1 file.
      v No lints detected.

# found lint message works

    Code
      invisible(lint(temp_dir))
    Message
      i Going to check 1 file.
      v Found lints in 1 file.

---

    Code
      invisible(lint(temp_dir))
    Message
      i Going to check 2 files.
      v Found lints in 2 files.

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
      v Fixed 1 file.

---

    Code
      fix(temp_dir, force = TRUE)
    Message
      i Going to check 2 files.
      v Fixed 2 files.

