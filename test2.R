x <- c(1, 2, 3)

any(duplicated(x), na.rm = TRUE)

any(duplicated(x))

if (any(is.na(x))) {
  TRUE
}

any(is.na(x))

apply(x, 1, sum)

apply(x, 1, paste)

apply(x, 2, sum)

