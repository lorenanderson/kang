;+
; Returns the x and y values of a circle
;
; :Private:
;
;-
FUNCTION Kang_Circle, xcenter, ycenter, radius, NPoints = NPoints, coordinates = coordinates

; I have no idea where the factor of 1.25 comes from!
IF N_Elements(coordinates) NE 0 THEN BEGIN
   IF StrUpCase(coordinates) EQ 'J2000' OR StrUpCase(coordinates) EQ 'FK5' OR $
      StrUpCase(coordinates) EQ 'B1950' OR StrUpCase(coordinates) EQ 'FK4' THEN BEGIN
      RETURN, kang_ellipse(xcenter, ycenter, radius, radius/1.25, 0, npoints = npoints)
   ENDIF
ENDIF
IF N_Elements(NPoints) EQ 0 THEN NPoints=100

seeds = Findgen(npoints)/(npoints-1)*2*!pi
xvals = sin(seeds)*radius[0]+xcenter[0]
yvals = cos(seeds)*radius[0]+ycenter[0]

RETURN, Transpose([[xvals], [yvals]])
END; Kang_Circle-------------------------------------------------------------------
