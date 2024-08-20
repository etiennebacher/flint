# print for lint works fine with single-line code

    Code
      lint_text("suppressPackageStartupMessages(library(dplyr))", linters = temp_rule)
    Output
      Original code: suppressPackageStartupMessages(library(dplyr)) 
      Suggestion: foo 
      Rule ID: rule_1 
      

# print for lint works fine with multi-line code

    Code
      lint_text(
        "suppressPackageStartupMessages({\n  library(dplyr)\n  library(knitr)\n})",
        linters = temp_rule)
    Output
      Original code:
      suppressPackageStartupMessages({
        library(dplyr)
        library(knitr)
      })
      Suggestion: foo
      Rule ID: rule_1 
      

---

    Code
      fix_text("unique(length(x))", linters = temp_rule)
    Output
      Old code: unique(length(x)) 
      New code:
      length(
        unique(x)
      )

---

    Code
      fix_text("unique(\n  length(x)\n)", linters = temp_rule)
    Output
      Old code:
      unique(
        length(x)
      )
      
      New code:
      length(
        unique(x)
      )

