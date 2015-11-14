FUNCTION Kang_Region::Init, $
  x, $
  y, $
  angle = angle, $
  background = background, $
  cname = cname, $
  charsize = charsize, $
  charthick = charthick, $
  coordinate = coordinate, $
  font = font, $
  image_obj = image_obj, $
  name = name, $
  nostats = nostats, $
  params = params, $
  pointType = pointType, $
  polygon = polygon, $
  regiontype = regiontype, $
  sexadecimal = sexadecimal, $
  source = source, $
  text = text, $
  unit = unit, $
  weighted = weighted, $
  _Extra = extra
; The initialization method for the object.  The data for the region
; are in the x and y vectors.  params is what is displayed in the
; region text widget.

; Set other passed parameters
IF N_Elements(angle) NE 0 THEN self.angle = 0 > angle < 360
IF N_Elements(background) NE 0 THEN self.source = ~background ELSE self.source = 1B
IF N_Elements(cname) NE 0 THEN self.cname = cname ELSE self.cname = 'Green'
IF N_Elements(charsize) NE 0 THEN self.charsize = charsize ELSE self.charsize = 1
IF N_Elements(charthick) NE 0 THEN self.charthick = charthick ELSE self.charthick = 1
IF N_Elements(coordinate) NE 0 THEN self.coordinate = coordinate ELSE self.coordinate = 'Image'
IF N_Elements(font) NE 0 THEN self.font = font
IF N_Elements(linestyle) NE 0 THEN self.linestyle = linestyle
IF N_Elements(name) NE 0 THEN self.name = name[0]
IF Keyword_Set(nostats) THEN self.nostats = 1
IF N_Elements(regionType) NE 0 THEN self.regionType = CapFirstLetter(regionType)
IF N_Elements(params) NE 0 THEN self.params = Ptr_New(reform(reform(params, 1, N_Elements(params))))
IF N_Elements(pointType) NE 0 THEN self.pointType = CapFirstLetter(pointType) ELSE BEGIN
   IF self.regionType EQ 'Point' THEN self.pointType = 'Plus'
ENDELSE
IF N_Elements(polygon) NE 0 THEN self.polygon = 0B > polygon  < 1B ELSE self.polygon = 1B ; Defaults to closed polygons
IF N_Elements(sexadecimal) NE 0 THEN self.sexadecimal = sexadecimal ELSE self.sexadecimal = 0B
IF N_Elements(source) NE 0 THEN self.source = source ELSE self.source = 1B
IF N_Elements(text) NE 0 THEN self.text = text
IF N_Elements(unit) NE 0 THEN self.unit = unit ELSE self.unit = 'Image'
IF N_Elements(weighted) NE 0 THEN self.weighted = 0B > weighted < 1B ELSE self.weighted = 1B ; Defaults to using weights

; This will be fixed later for non astronomical images
; These are not astronomical images
;IF size(astr, /tname) EQ 'STRING' THEN self.area = 'Pixel' ELSE self.area_unit = 'Arcmin'
self.area_unit = 'Pixel'

; Create region object from passed data
IF N_Elements(y) NE 0 THEN ok = self->IDLGRROI::Init(x, y, _Strict_Extra=extra) ELSE $
  ok = self->IDLGRROI::Init(x, _Strict_Extra=extra)

; Create text
self->CreateText

; Find stats
self->ComputeGeometry, image_obj

RETURN, 1 < ok
END; Kang_Region::Init--------------------------------------------------


PRO Kang_Region::Cleanup
; Free the pointers

Ptr_Free, self.params
self->IDLGRROI::Cleanup
END; Kang_Region::Cleanup--------------------------------------------------


PRO Kang_Region::SetProperty, $
  background = background, $
  cname = cname, $
  charsize = charsize, $
  charthick = charthick, $
  coordinate = coordinate, $
  data = data, $
  font = font, $
  image_obj = image_obj, $
  name = name, $
  pointType = pointType, $
  polygon = polygon, $
  params = params, $
  sexadecimal = sexadecimal, $
  source = source, $
  text = text, $
  unit = unit, $
  weighted = weighted, $
  _Extra = extra
; Sets the various parameters for the  region.

self->IDLGRROI::SetProperty, _Strict_Extra = extra
IF N_Elements(background) NE 0 THEN self.source = 0B > (~background) < 1B
IF N_Elements(cname) NE 0 THEN self.cname = cname
IF N_Elements(charsize) NE 0 THEN self.charsize = charsize
IF N_Elements(charthick) NE 0 THEN self.charthick = charthick
IF N_Elements(coordinate) NE 0 THEN self.coordinate = coordinate
IF N_Elements(data) NE 0 THEN BEGIN
    self->IDLGRROI::SetProperty, data = data
    self->ComputeGeometry, image_obj
ENDIF
IF N_Elements(font) NE 0 THEN self.font = font
IF N_Elements(name) NE 0 THEN self.Name = name
IF N_Elements(pointType) NE 0 THEN self.pointType = CapFirstLetter(pointType)
IF N_Elements(polygon) NE 0 THEN BEGIN
    self.polygon = 0B > polygon < 1B
    self->ComputeGeometry, image_obj
;IMAGE_STATISTICS, myImage, MASK = mask, COUNT = nSamples 
ENDIF
IF N_Elements(params) NE 0 THEN self.params = Ptr_New(reform(reform(params, 1, N_Elements(params))))
IF N_Elements(sexadecimal) NE 0 THEN self.sexadecimal = sexadecimal
IF N_Elements(source) NE 0 THEN self.source = 0B > source < 1B
IF N_Elements(unit) NE 0 THEN self.unit = unit
IF N_Elements(text) NE 0 THEN self.text = text
IF N_Elements(weighted) NE 0 THEN BEGIN
   self.weighted = 0B > weighted < 1B
   self->ComputeGeometry, image_obj
ENDIF

;Update the text
self->CreateText
END; Kang_Region::SetProperty--------------------------------------------------


PRO Kang_Region::GetProperty, $
  angle = angle, $
  background = background, $
  charsize = charsize, $
  charthick = charthick, $
  cname = cname, $
  coordinate = coordinate, $
  composite = composite, $
  font = font, $
  image_obj = image_obj, $
  name = name, $
  output_text = output_text, $
  params = params, $
  pointType = pointType, $
  polygon = polygon, $
  regiontext=regiontext, $
  regiontype=regiontype, $
  source = source, $
  stats = stats, $
  text = text, $
  xrange = xrange, $
  yrange = yrange, $
  weighted = weighted, $
  _Ref_Extra = extra
; Gets the various region properties out of the object.

self->IDLGRROI::GetProperty, _Strict_Extra = extra
IF Arg_Present(angle) THEN angle = self.angle
IF Arg_Present(background) THEN background = ~self.source
IF Arg_Present(charsize) THEN charsize = self.charsize
IF Arg_Present(charthick) THEN charthick = self.charthick
IF Arg_Present(cname) THEN cname = self.cname
IF Arg_Present(coordinate) THEN coordinate = self.coordinate
IF Arg_Present(composite) THEN composite = 0
IF Arg_Present(font) THEN font = self.font
IF Arg_Present(name) THEN name = self.Name
IF Arg_Present(output_text) THEN BEGIN
    CASE self.regionType OF
        'Threshold': BEGIN
; Change threshold text
            self->Getproperty, data=data, interior = interior, composite = composite
            IF Obj_Valid(image_obj) THEN data = image_obj->Convert_Coord(data[0, *], data[1, *], $
                                                                     old_coord = 'Image')
            output_text = 'Polygon(' + StrCompress(StrJoin(data, ',', /Single)) + ')'
            IF interior THEN output_text = '-' + output_text
        END

        'Freehand': output_text = RepStr(self.regiontext, 'Freehand', 'Polygon')

        ELSE: output_text = self.regiontext
    ENDCASE
ENDIF
IF Arg_Present(stats) THEN BEGIN
    stats = {coordinate:self.coordinate, $
             sexadecimal:self.sexadecimal, $
             unit:self.unit, $
             area:self.area, $
             area_unit:self.area_unit, $
             centroid:self.centroid, $
             perimeter:self.perimeter, $
             npix:self.npix, $
             n_nan:self.n_nan, $
             max:self.max, $
             min:self.min, $
             centroid_max:self.centroid_max, $
             centroid_min:self.centroid_min, $
             mean:self.mean, $
             median:self.median, $
             stddev:self.stddev, $
             total:self.total}
ENDIF
IF Arg_Present(params) THEN params = *self.params
IF Arg_Present(regiontext) THEN regiontext = self.regiontext
IF Arg_Present(sexadecimal) THEN sexadecimal = self.sexadecimal
IF Arg_Present(source) THEN source = self.source
IF Arg_Present(text) THEN text = self.text
IF Arg_Present(unit) THEN unit = self.unit
IF Arg_Present(pointType) THEN pointType = self.pointType
IF Arg_Present(polygon) THEN polygon = self.polygon
IF Arg_Present(regiontype) THEN regiontype = self.regiontype
IF Arg_Present(xrange) THEN xrange = self.xrange
IF Arg_Present(yrange) THEN yrange = self.yrange
IF Arg_Present(weighted) THEN weighted = self.weighted

END; Kang_Region::GetProperty--------------------------------------------------


FUNCTION Kang_Region::GetProperty, $
  angle = angle, $
  background = background, $
  charsize = charsize, $
  charthick = charthick, $
  cname = cname, $
  composite = composite, $
  coordinate = coordinate, $
  font = font, $
  image_obj = image_obj, $
  interior = interior, $
  linestyle = linestyle, $
  name = name, $
  output_text = output_text, $
  params = params, $
  regionText=regionText, $
  regionType=regionType, $
  pointType=pointType, $
  polygon= polygon, $
  sexadecimal = sexadecimal, $
  source=source, $
  stats = stats, $
  text = text, $
  unit = unit, $
  thick = thick, $
  xrange = xrange, $
  yrange = yrange, $
  weighted = weighted, $
  _Ref_Extra = extra
;; Gets the various region properties out of the object - this time as
;;                                                        a function.

self->IDLGRROI::GetProperty, _Strict_Extra = extra

IF Keyword_Set(angle) THEN RETURN, self.angle
IF Keyword_Set(background) THEN RETURN, ~self.source
IF Keyword_Set(charsize) THEN RETURN,  self.charsize
IF Keyword_Set(charthick) THEN RETURN, self.charthick
IF Keyword_Set(cname) THEN RETURN, self.cname
IF Keyword_Set(composite) THEN RETURN, 0
IF Keyword_Set(coordinate) THEN RETURN, self.coordinate
IF Keyword_Set(sexadecimal) THEN RETURN, self.sexadecimal
IF Keyword_Set(unit) THEN RETURN, self.unit
IF Keyword_Set(font) THEN RETURN, self.font
IF Keyword_Set(interior) THEN BEGIN
    self->IDLGRROI::GetProperty, interior = interior
    RETURN, interior
ENDIF
IF Keyword_Set(linestyle) THEN BEGIN
    self->IDLGRROI::GetProperty, linestyle = linestyle
    RETURN, linestyle
ENDIF
IF Keyword_Set(name) THEN RETURN, self.Name
;IF Keyword_Set(stats) THEN RETURN, $
;  stats = {area:self.area, $
;           centroid:self.centroid, $
;           perimeter:self.perimeter, $
;           npix:self.npix, $
;           max:self.max, $
;           min:self.min, $
;           mean:self.mean, $
;           stddev:self.stddev, $
;           total:self.total}
IF Keyword_Set(params) THEN RETURN, *self.params
IF Keyword_Set(pointType) THEN RETURN, self.pointType
IF Keyword_Set(regionText) THEN RETURN, self.regiontext
IF Keyword_Set(source) THEN RETURN, self.source
IF Keyword_Set(output_text) THEN BEGIN
    CASE self.regionType OF
        'Threshold': BEGIN
; Change threshold text
            self->Getproperty, data=data, interior = interior, composite = composite
            IF Obj_Valid(image_obj) THEN data = image_obj->Convert_Coord(data[0, *], data[1, *], $
                                                                         old_coord = 'Image')
            output_text = 'Polygon(' + StrCompress(StrJoin(data, ',', /Single)) + ')'
            IF interior THEN output_text = '-' + output_text
            RETURN, output_text        
        END

        'Freehand': RETURN, RepStr(self.regiontext, 'Freehand', 'Polygon')

        ELSE: RETURN, self.regiontext
    ENDCASE
ENDIF
IF Keyword_Set(text) THEN RETURN, self.text
IF Keyword_Set(thick) THEN BEGIN
    self->IDLGRROI::GetProperty, thick = thick
    RETURN, thick
ENDIF
IF Keyword_Set(regiontype) THEN RETURN, self.regiontype
IF Keyword_Set(polygon) THEN RETURN, self.polygon
IF Keyword_Set(xrange) THEN RETURN, self.xrange
IF Keyword_Set(yrange) THEN RETURN, self.yrange
IF Keyword_Set(weighted) THEN RETURN, self.weighted

END; Kang_Region::GetProperty--------------------------------------------------


PRO Kang_Region::Rotate, newangle, image_obj = image_obj
; Rotates about the center of the object

; Use IDL's function to rotate it around
IF self.regiontype NE 'Text' THEN BEGIN
    centroid = image_obj->Convert_Coord(self.centroid[0], self.centroid[1], new_coord = 'Image')
    self->IDLGRROI::Rotate, [0,0, 1], self.angle - newangle, Center = [centroid[0], centroid[1], 0]

; Update the statistics
    self->ComputeGeometry, image_obj
ENDIF
self.angle = newangle

; Update the text
IF Ptr_Valid(self.params) THEN BEGIN
    n = N_Elements(*self.params)
    CASE StrUpCase(self.regiontype) OF
        'BOX': (*self.params)[n-1] = self.angle
        'TEXT': (*self.params)[n-1] = self.angle
        'ELLIPSE': (*self.params)[n-1] = self.angle
        'CROSS': (*self.params)[n-1] = self.angle
        'POLYGON': BEGIN
            self->GetProperty, data = data
            data = image_obj->Convert_Coord(data, old_coord = 'Image')
            *self.params = reform(reform(data, 1, N_Elements(data)))
        END
        'THRESHOLD': (*self.params)[n-1] = self.angle
        'FREEHAND': BEGIN
            self->GetProperty, data = data
            data = image_obj->Convert_Coord(data, old_coord = 'Image')
            *self.params = reform(reform(data, 1, N_Elements(data)))
        END
        ELSE:
    ENDCASE
    self->CreateText
ENDIF

END; Kang_Region::Rotate--------------------------------------------------


PRO Kang_Region::Scale, scale, image_obj = image_obj

self->Scale, scale
self->ComputeGeometry, image_obj
END; Kang_Region::Scale--------------------------------------------------


PRO Kang_Region::Move, translation, coordinate = coordinate, image_obj = image_obj
; Move the region

; Use IDL's built in translate function
pix_coords = image_obj->Convert_Coord(translation, Old_Coord = coordinate, New_Coord = 'Image')
self->IDLGRROI::Translate, pix_coords

; Update the text
translation_coords1 = image_obj->Convert_Coord(translation, Old_Coord = coordinate, New_Coord = self.coordinate)
translation_coords2 = image_obj->Convert_Coord([0, 0], Old_Coord = coordinate, New_Coord = self.coordinate)
translation_coords = translation_coords1 - translation_coords2

IF Ptr_Valid(self.params) THEN BEGIN
    CASE StrUpCase(self.regiontype) OF 
       'LINE': BEGIN
          (*self.params)[0:1] += translation_coords
          (*self.params)[2:3] += translation_coords
       END
       'ROW': BEGIN
          *self.params += translation_coords[1]
       END
       'COLUMN': BEGIN
          *self.params += translation_coords[0]
       END
       'POINT': (*self.params)[0:1] += translation_coords
       'PROJECTION': BEGIN
          (*self.params)[0:1] += translation_coords
          (*self.params)[2:3] += translation_coords
       END
       'POLYGON': BEGIN
          n_points = N_Elements(*self.params)/2.
          (*self.params)[lindgen(n_points)*2] +=translation_coords[0]
          (*self.params)[lindgen(n_points)*2+1] +=translation_coords[1]
       END
       'FREEHAND': BEGIN
          n_points = N_Elements(*self.params)/2.
          (*self.params)[lindgen(n_points)*2] +=translation_coords[0]
          (*self.params)[lindgen(n_points)*2+1] +=translation_coords[1]
       END
       ELSE: (*self.params)[0:1] += translation_coords
    ENDCASE
    self->CreateText
ENDIF

; Update the region stats
self->ComputeGeometry, image_obj

END; Kang_Regions::Move-----------------------------------------------------------------------------------


PRO Kang_Region::CreateText
; Creates the region text string for display in the widget and for
; saving purposes.

self.regiontext = StrCompress(self.regiontype + '(' + StrJoin(*self.params, ',') + ')')

; Adjust the text based on the region properties
self->GetProperty, interior = interior
IF interior THEN self.regiontext = '-' + self.regiontext

; Additional properties
IF ~self.source OR StrTrim(self.Name, 2) NE '' OR ~self.polygon OR self.thick GT 1 OR self.linestyle GT 0 OR $
  self.cname NE 'green' OR self.text NE '' THEN BEGIN
    self.regiontext += ' # '
    IF self.cname NE 'green' THEN self.regiontext += ('color = ' + StrCompress(self.cname, /Remove))
    IF ~self.source THEN self.regiontext += ' background '
    IF StrTrim(self.Name, 2) NE '' THEN self.regiontext += ' name = {' + self.Name + '} '
    IF self.polygon NE 1B AND total(self.regiontype EQ ['Row', 'Column', 'Point']) EQ 0 THEN self.regiontext += ' type = Line '
    IF self.linestyle GT 1 THEN self.regiontext += ' linestyle = ' + StrTrim(String(self.linestyle, format = '(I)'), 2)
    IF self.thick GT 1 THEN self.regiontext += ' width = ' + StrTrim(String(self.thick, format = '(I)'), 2)
    IF self.text NE '' THEN self.regiontext += ' text = {' + self.text + '}'
    IF self.pointType NE '' THEN self.regiontext += ' point = ' + self.pointType
ENDIF

END; Kang_Region::CreateText------------------------------------------------------------------------------


PRO Kang_Region::ComputeGeometry, image_obj
; Finds and stores the statistics.

IF self.nostats THEN RETURN

; Find some basic statistics
Result = self->IDLGRROI::ComputeGeometry(area = area, centroid = centroid, perimeter = perimeter)

; Something horribly wrong here sometimes with negative area.
area = abs(area)

; Stats without a valid image object
IF ~Obj_Valid(image_obj) THEN BEGIN
    self.area = area
    self.centroid = centroid[0:1]
    self.perimeter = perimeter
    RETURN
ENDIF

; The remainder of the statistics require an image
image_obj->GetProperty, astr = astr
CASE self.area_unit OF
   'Degree': BEGIN
      self.area = area * (abs(astr.cdelt[0]) * astr.cdelt[1])
      self.perimeter = perimeter * abs(astr.cdelt[0])
   END
   'Arcmin': BEGIN
      self.area = area * (abs(astr.cdelt[0]) * astr.cdelt[1]) * 60. * 60.
      self.perimeter = perimeter * abs(astr.cdelt[0]) * 60.
   END
   'Arcsec': BEGIN
      self.area = area * (abs(astr.cdelt[0]) * astr.cdelt[1]) * 3600. * 3600.
      self.perimeter = perimeter * abs(astr.cdelt[0]) * 3600.
   END
   'Pixel': self.area = area
ENDCASE
self.centroid = image_obj->Convert_Coord(centroid[0], centroid[1], Old_Coord = 'Image', New_Coord = self.coordinate)

; Find dimensions
image_obj->GetProperty, pix_limits = pix_limits
dimensions = [pix_limits[1]-pix_limits[0]+1, pix_limits[3]-pix_limits[2]+1]

; Find indices of the pixels inside the region
indices = self->Find_Indices(dimensions = [pix_limits[1]-pix_limits[0]+1, pix_limits[3]-pix_limits[2]+1])

; Compute weights if flag is set
IF N_Elements(indices) GE 50.*50 OR self.regiontype EQ 'Text' THEN self.weighted = 0
self.weighted = 0
IF self.weighted THEN BEGIN
   weights = self->ComputeWeights(dimensions = dimensions)
   self.npix = total(weights)
ENDIF ELSE self.npix = N_Elements(indices)

; Find and store additional stats
image_obj->Find_Geometry, indices, n_nan = n_nan, min = min, max = max, centroid_min = centroid_min, centroid_max = centroid_max, $
                          mean = mean, sum = total, median = median, $
                          stddev = stddev, weights = weights

self.min = min
self.max = max
IF centroid_min[0] NE -1 THEN BEGIN
   self.centroid_min = image_obj->Convert_Coord(centroid_min[0], centroid_min[1], Old_Coord = 'Image', New_Coord = self.coordinate)
   self.centroid_max = image_obj->Convert_Coord(centroid_max[0], centroid_max[1], Old_Coord = 'Image', New_Coord = self.coordinate)
ENDIF
self.mean = mean
self.median = median
self.stddev = stddev
self.n_nan = n_nan
self.total = self.mean*self.npix

END; Kang_Region::ComputeGeometry-------------------------------------------------------------


FUNCTION Kang_Region::Find_Indices, dimensions = dimensions
; Returns the indices that lie inside the region

; From James Jones at ITT:
self->GetProperty, interior = interior
self->SetProperty, interior = 0
subscriptKey = self->ComputeMask(dimensions = dimensions, /Run_Length)
nSubscripts = total(subscriptKey[0:*:2])
IF nSubscripts GT 0 THEN BEGIN
    roiSubscripts = lonarr(nSubscripts)
    roiCursor = 0
    FOR i = 0, N_Elements(subscriptKey)-1., 2 DO BEGIN
        runlength = subscriptKey[i]
        roiSubscripts[roiCursor] = lindgen(runlength) + subscriptKey[i+1]
        roiCursor += runlength
    ENDFOR
ENDIF ELSE roiSubscripts = -1
self->SetProperty, interior = interior

RETURN, roiSubscripts
END; Kang_Region::Find_Indices--------------------------------------------------


FUNCTION Kang_Region::ComputeMask, dimensions = dimensions, mask_in = mask_in, weighted = weighted, run_length = run_length
; Returns a mask with values inside the region at a value of 255B, and
; outside with a value of 0B.
; Basically, we just need to transform to pixel coordinates
; If the weighted keyword is set, this returns an array weighted by
; the fraction of the pixel inside the polygon.

mask = -1

; We cannot have negative values in the data
self->GetProperty, data = data, interior = interior
x = data[0, *] > 0
y = data[1, *] > 0
type = self.polygon+1
IF StrUpCase(self.regionType) EQ 'POINT' THEN type = 0
region = Obj_New('IDLANROI', x, y, type = type)

; Compute the mask using the built in IDL method.
IF N_Elements(mask_in) NE 0 THEN mask = region->ComputeMask(dimensions = dimensions, mask_in = mask_in, $
                                                            run_length = run_length) ELSE $
  mask = region->ComputeMask(dimensions = dimensions, run_length = run_length)
Obj_Destroy, region

; The weights
IF Keyword_Set(weighted) THEN weights = self->ComputeWeights(dimensions = dimensions) ELSE weights = 1B
RETURN, mask * weights
END; Kang_Region::ComputeMask----------------------------------------


FUNCTION Kang_Region::ComputeWeights, dimensions = dimensions
; Create a weighted mask sing Mark Hadfield's mgh_polyfillg

; Calculate start and dimensions
self->GetProperty, data = data
;startx = floor(min(data[0, *], max = endx))
;endx = ceil(endx)
;starty = floor(min(data[0, *], max = endy))
;endy = ceil(endy)
;start = [startx, starty]
;dimensions = [endx-startx+1, endy-starty-1]+1

; This creates an array the same size as the input image
RETURN, mgh_polyfillg(data[0:1, *], dimension = dimensions + 1, start = [0, 0], delta = [1,1])
;RETURN, mgh_polyfillg(data[0:1, *], dimension = dimensions, start = start, delta = [1,1])
END; Kang_Region::ComputeWeights-------------------------------------


FUNCTION Kang_Region::Histogram, image_obj = image_obj, bins = bins, reverse_indices = reverse_indices, _Extra = extra

; Find dimensions and indices
image_obj->GetProperty, pix_limits = pix_limits
dimensions = [pix_limits[1]-pix_limits[0]+1, pix_limits[3]-pix_limits[2]+1]
indices = self->Find_Indices(dimensions = [pix_limits[1]-pix_limits[0]+1, pix_limits[3]-pix_limits[2]+1])

; Compute histogram
image_obj->Histogram, indices, histvals = histvals, reverse_indices = reverse_indices, bins = bins, _Extra = extra

RETURN, histvals
END; Kang_Region::Histogram------------------------------------------


PRO Kang_Region::Draw, color = color, linestyle = linestyle, thick = thick
; Draw the region on the display

IF ~Keyword_Set(color) THEN color = *self.color
IF ~Keyword_Set(linestyle) THEN linestyle = self.linestyle
IF ~Keyword_Set(thick) THEN thick = self.thick

self->GetProperty, data = data, interior = interior
CASE StrUpCase(self.regiontype) OF
    'TEXT': XYOutS, data[0], data[1], self.text, /Data, color = color, charsize = self.charsize, charthick=self.charthick, $
                    orientation = self.angle, alignment = 0.5, NoClip=0, font = self.font
    'LINE': PlotS, data[0, *], data[1, *], thick=thick, linestyle=linestyle, color=color[0], NoClip=0
    'ROW': PlotS, data[0, *], data[1, *], thick=thick, linestyle=linestyle, color=color[0], NoClip=0
    'POINT': BEGIN
       CASE self.pointType OF
          'Plus': psym = 1
          'Circle': BEGIN
             psym = 8
             plotsym, 0
          END
          'X': psym = 7
       ENDCASE
       PlotS, data[0], data[1], thick=thick, linestyle=linestyle, color=color[0], NoClip=0, psym = psym
    END
    'COLUMN': PlotS, data[0, *], data[1, *], thick=thick, linestyle=linestyle, color=color[0], NoClip=0
    'PROJECTION': PlotS, data[0, *], data[1, *], thick=thick, linestyle=linestyle, color=color[0], NoClip=0
    'FREEHAND': BEGIN
; Lines, don't close polygon
        IF self.polygon EQ 0B THEN PlotS, data, thick=thick, linestyle=linestyle, color=self.color[0], NoClip=0 ELSE $
          PlotS, [[data], [data[*, 0]]], thick=thick, linestyle=linestyle, color=color[0], NoClip=0 
; Draw the red line
        IF interior THEN PlotS, [self.xrange[1], self.xrange[0]], [self.yrange[0], self.yrange[1]], thick=thick, color=250, NoClip=0
    END
    ELSE: BEGIN
; Add the last element to close the polygon
        PlotS, [[data], [data[*, 0]]], thick=thick, linestyle=linestyle, color=color[0], NoClip=0

; Draw the red line
        IF interior THEN PlotS, [self.xrange[1], self.xrange[0]], [self.yrange[0], self.yrange[1]], thick=thick, color=250, NoClip=0
    END
ENDCASE

IF self.text NE '' AND StrUpCase(self.regiontype) NE 'TEXT' THEN BEGIN
    XYOutS, avg(data[0, *]), max(data[1, *]), self.text, /Data, color = color, charsize = 1.35, charthick = 2, $;self.charsize, charthick=self.charthick, $
            orientation = self.angle, alignment = 0.5, NoClip=0, font = 2
ENDIF

END; Kang_Region::Draw--------------------------------------------------


PRO Kang_Region__Define

struct = {KANG_REGION, $
          INHERITS IDLGRROI, $
          regiontext:'', $      ; Text to display in widget
          regiontype:'', $      ; Type of region
          angle:0., $           ; Position angle
          params:Ptr_New(), $   ; Parameters used to construct region
          area:0., $            ; Region stats
          area_unit:'', $
          perimeter:0., $
          npix:0., $
          n_nan:0L, $
          centroid:FltArr(2), $
          max:0., $
          min:0., $
          centroid_max:FltArr(2), $
          centroid_min:FltArr(2), $
          mean:0., $
          median:0., $
          stddev:0., $
          total:0., $
          text:'', $            ; Region drawing properties
          charsize:0, $
          charthick:0, $
          coordinate:'', $
          sexadecimal:0, $
          unit:'', $
          cname:'', $           ; Color name
          font:0, $
;          name:'', $           ; Already defined by IDLGRROI
          pointType:'', $       ; For "point" regions
          polygon:0B, $         ; Region can be a polygon or a line
          weighted:0B, $        ; Use weights in the statistical analysis?
          source:0B, $          ; Is this a source or a background region?
          nostats: 0B $         ; Set to 1 if stats are not to be computed
         }

END; Kang_Region__Define------------------------------------------------------------
