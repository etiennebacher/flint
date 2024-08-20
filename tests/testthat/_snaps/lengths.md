# fix works

    Code
      fix_text("x |> sapply(length)", linters = linter)
    Output
      Old code: x |> sapply(length) 
      New code: x |> lengths() 

---

    Code
      fix_text("x %>% sapply(length)", linters = linter)
    Output
      Old code: x %>% sapply(length) 
      New code: x %>% lengths() 

---

    Code
      fix_text("x |> map_int(length)", linters = linter)
    Output
      Old code: x |> map_int(length) 
      New code: x |> lengths() 

---

    Code
      fix_text("x %>% map_int(length)", linters = linter)
    Output
      Old code: x %>% map_int(length) 
      New code: x %>% lengths() 

---

    Code
      fix_text("x |> purrr::map_int(length)", linters = linter)
    Output
      Old code: x |> purrr::map_int(length) 
      New code: x |> lengths() 

---

    Code
      fix_text("x %>% purrr::map_int(length)", linters = linter)
    Output
      Old code: x %>% purrr::map_int(length) 
      New code: x %>% lengths() 

