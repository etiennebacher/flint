# unreachable_code_linter works in sub expressions

    Code
      lint_text(lines)
    Output
      Original code: # Test comment 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code:
      while (bar) {
                return(bar)
                5 + 3
                repeat {
                  return(bar)
                  # Test comment
                  1 + 1
                }
              }
      Suggestion: Code and comments coming after a return() or stop() should be removed.
      Rule ID: unreachable_code-1 
      
      Original code: 5 + 3 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code:
      repeat {
                  return(bar)
                  # Test comment
                  1 + 1
                }
      Suggestion: Code and comments coming after a return() or stop() should be removed.
      Rule ID: unreachable_code-1 
      
      Original code: # Test comment 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code: 1 + 1 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code: # Test 2 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code: # Test comment 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code:
      for(i in 1:3) {
                return(bar)
                5 + 4
              }
      Suggestion: Code and comments coming after a return() or stop() should be removed.
      Rule ID: unreachable_code-1 
      
      Original code: 5 + 4 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code: 5 + 1 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      

---

    Code
      lint_text(lines)
    Output
      Original code: x <- 2 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code: x <- 3 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code: 5 + 3 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code: test() 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      
      Original code: 5 + 4 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      Rule ID: unreachable_code-1 
      

# unreachable_code_linter works with next and break in sub expressions

    Code
      lint_text(lines)
    Output
      Original code: # Test comment 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      
      Original code:
      while (bar) {
                break
                5 + 3
                repeat {
                  next
                  # Test comment
                }
              }
      Suggestion: Remove code and comments coming after `next` or `break`
      Rule ID: unreachable_code-2 
      
      Original code: 5 + 3 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      
      Original code:
      repeat {
                  next
                  # Test comment
                }
      Suggestion: Remove code and comments coming after `next` or `break`
      Rule ID: unreachable_code-2 
      
      Original code: # Test comment 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      
      Original code: # test 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      
      Original code:
      for(i in 1:3) {
                break
                5 + 4
              }
      Suggestion: Remove code and comments coming after `next` or `break`
      Rule ID: unreachable_code-2 
      
      Original code: 5 + 4 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      

---

    Code
      lint_text(lines)
    Output
      Original code: x <- 2 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      
      Original code: x <- 3 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      
      Original code: 5 + 3 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      
      Original code: test() 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      
      Original code: 5 + 4 
      Suggestion: Remove code and comments coming after `next` or `break` 
      Rule ID: unreachable_code-2 
      

