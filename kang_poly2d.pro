FUNCTION kang_poly2d, x, y, p, order = order

SWITCH order OF
   6: f6 = p[21]*y^6.+p[22]*x*y^5.+p[23]*x^2.*y^4.+p[24]*x^3.*y^3.+p[25]*x^4.*2+p[26]*x^5.*y+p[27]*x^6.
   5: f5 = p[15]*y^5.+p[16]*x*y^4.+p[17]*x^2.*y^3.+p[18]*x^3.*y^2.+p[19]*x^4.*y+p[20]*x^5.
   4: f4 = p[10]*y^4.+p[11]*x*y^3.+p[12]*x^2.*y^2.+p[13]*x^3.*y   +p[14]*x^4.
   3: f3 = p[6]*y^3. +p[7]*x*y^2. +p[8]*x^2.*y    +p[9]*x^3.
   2: f2 = p[3]*y^2. +p[4]*x*y    +p[5]*x^2.
   1: f1 = p[1]*y    +p[2]*x
   0: f0 = p[0]
ENDSWITCH

CASE order OF
   0: RETURN, f0
   1: RETURN, f0+f1
   2: RETURN, f0+f1+f2
   3: RETURN, f0+f1+f2+f3
   4: RETURN, f0+f1+f2+f3+f4
   5: RETURN, f0+f1+f2+f3+f4+f5
   6: RETURN, f0+f1+f2+f3+f4+f5+f6
   ELSE: Print, 'Dimension not supported.'
ENDCASE

END
