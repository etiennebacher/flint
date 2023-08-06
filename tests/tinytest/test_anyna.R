source("helpers.R")
using("tinylint")

expect_no_lint("anyNA(x)")

expect_lint("any(is.na(x))", "anyNA")

expect_lint("if (any(is.na(x)) {
            print(TRUE)
            }", "anyNA")

expect_lint("for (any(is.na(x)) {
            print(TRUE)
            }", "anyNA")

expect_lint("while (any(is.na(x)) {
            print(TRUE)
            }", "anyNA")

