# literal_coercion_linter blocks simple disallowed usages lgl, from int

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.logical(1L) 
      New code: TRUE 

# literal_coercion_linter blocks simple disallowed usages lgl, from num

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.logical(1) 
      New code: TRUE 

# literal_coercion_linter blocks simple disallowed usages lgl, from chr

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.logical("true") 
      New code: TRUE 

# literal_coercion_linter blocks simple disallowed usages int, from num

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.integer(1) 
      New code: 1L 

# literal_coercion_linter blocks simple disallowed usages num, from num

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.numeric(1) 
      New code: 1 

# literal_coercion_linter blocks simple disallowed usages dbl, from num

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.double(1) 
      New code: 1 

# literal_coercion_linter blocks simple disallowed usages int, from NA

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.integer(NA) 
      New code: NA_integer_ 

# literal_coercion_linter blocks simple disallowed usages num, from NA

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.numeric(NA) 
      New code: NA_real_ 

# literal_coercion_linter blocks simple disallowed usages dbl, from NA

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.double(NA) 
      New code: NA_real_ 

# literal_coercion_linter blocks simple disallowed usages chr, from NA

    Code
      fix_text(sprintf("as.%s(%s)", out_type, input))
    Output
      Old code: as.character(NA) 
      New code: NA_character_ 

