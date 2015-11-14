FUNCTION kang_tickmarks, axis, index, value

IF value LT 0 THEN value+=360
ndecdig = (ceil(-(alog10(value/1000))) - 3) > 0.
print, value, ndecdig

tickmark = string(value, format='(F0.1' + StrTrim(long(ndecdig), 2) + ')')

return, tickmark
END
