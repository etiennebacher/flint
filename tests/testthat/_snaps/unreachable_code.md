# unreachable_code_linter works in sub expressions

    Code
      lint_text(lines)
    Output
      Original code: # Test comment 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
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
      
      Original code: 5 + 3 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code:
      repeat {
                  return(bar)
                  # Test comment
                  1 + 1
                }
      Suggestion: Code and comments coming after a return() or stop() should be removed.
      
      Original code: # Test comment 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code: 1 + 1 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code: # Test 2 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code: # Test comment 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code:
      for(i in 1:3) {
                return(bar)
                5 + 4
              }
      Suggestion: Code and comments coming after a return() or stop() should be removed.
      
      Original code: 5 + 4 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code: 5 + 1 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      

---

    Code
      lint_text(lines)
    Output
      Original code: x <- 2 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code: x <- 3 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code: 5 + 3 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code: test() 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      
      Original code: 5 + 4 
      Suggestion: Code and comments coming after a return() or stop() should be removed. 
      

# unreachable_code_linter works with next and break in sub expressions

    Code
      lint_text(lines)
    Output
      Original code: # Test comment 
      Suggestion: Remove code and comments coming after `next` or `break` 
      
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
      
      Original code: 5 + 3 
      Suggestion: Remove code and comments coming after `next` or `break` 
      
      Original code:
      repeat {
                  next
                  # Test comment
                }
      Suggestion: Remove code and comments coming after `next` or `break`
      
      Original code: # Test comment 
      Suggestion: Remove code and comments coming after `next` or `break` 
      
      Original code: # test 
      Suggestion: Remove code and comments coming after `next` or `break` 
      
      Original code:
      for(i in 1:3) {
                break
                5 + 4
              }
      Suggestion: Remove code and comments coming after `next` or `break`
      
      Original code: 5 + 4 
      Suggestion: Remove code and comments coming after `next` or `break` 
      

---

    Code
      lint_text(lines)
    Output
      Original code: x <- 2 
      Suggestion: Remove code and comments coming after `next` or `break` 
      
      Original code: x <- 3 
      Suggestion: Remove code and comments coming after `next` or `break` 
      
      Original code: 5 + 3 
      Suggestion: Remove code and comments coming after `next` or `break` 
      
      Original code: test() 
      Suggestion: Remove code and comments coming after `next` or `break` 
      
      Original code: 5 + 4 
      Suggestion: Remove code and comments coming after `next` or `break` 
      

