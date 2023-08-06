
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tinylint

`tinylint` is a small R package to detect lints in R code and optionally
replace them. It comes with two main functions: `lint()` and `fix()`.

Both functions are very similar and take the same inputs.

`lint()` returns a dataframe containing all the lines with a
non-idiomatic or unconventional code.

`fix()` automatic fixes these lints.

## Comparison with existing tools

The most used tool for lints detection in R is `lintr`. However,
`lintr`’s performance is not optimal when it is applied on medium to
large packages. Also, `lintr` cannot perform automatic replacement of
lints. This task is usually delegated to `styler`.

# How does it work?

Use `tinylint::setup()` for an automatic setup. This will create a file
`sgconfig.yml` and a folder `rules` (both of these will be put in
`.Rbuildignore` but not in `.gitignore`).

Each file in the `rules` folder contains the definition of a lint and
(in most cases) a fix for this lint.

## Providing custom rules

You can add your own custom rules in the folder `rules/custom`. In this
folder, you can them organize them as you prefer (e.g creating other
subfolders).
