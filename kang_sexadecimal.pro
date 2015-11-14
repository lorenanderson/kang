FUNCTION kang_sexadecimal, value, format = format, no_zeros = no_zeros
; Format is the format for the seconds

; Determine sign
sign = value / abs(value)
IF sign EQ -1 THEN str_sign = '-' ELSE str_sign = '+'

; Take abs since calculations will be faster
abs_value = abs(value)

; Compute deg, min, sec
deg = floor(abs_value)
min = floor((abs_value - deg) * 60)
sec = floor((abs_value - deg - min/60.) * 3600)

; Create strings
IF N_Elements(format) EQ 0 THEN format = '(F6.3)'
str_value = str_sign + String(deg, format = '(I3)') + ':' + String(min, format = '(I2)') + ':' + String(sec, format = format)

; Replace ' ' with '0' in first entry
IF ~Keyword_Set(no_zeros) THEN str_value = RepStr(str_value, ' ', '0') ELSE str_value = RepStr(str_value, ' ', '')

RETURN, str_value
END
