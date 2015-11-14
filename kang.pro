; docformat = 'rst'
;+
; Display and analysis of images and data cubes.  This routine simply
; brings up the GUI display and/or outputs an object reference for
; command line processing.
;
; :Params:
;   image : in, optional, type = 'array OR string'
;       One may load an image in two ways::
;          1) load a previously defined IDL array, or::
;          2) pass a string argument specifying a valid FITS file
;          location on disk.::
;       If no argument is passed, the GUI display is simply shown.
;
;   header : in, optional, type = 'string array'
;       If an image array is passed, a valid FITS header may also
;       be passed in to provide the astrometry information.
;
;  :Keywords:
;  AxisColor : in, optional, type = 'string'
;    The axis color.
;  BackColor : in, optional, type = 'string'
;    The background color.
;  BarTitle : in, optional, type = 'string'
;    Colorbar title
;  Brightness : in, optional, type = 'float'
;    Brightness (stretch)
;  Block : in, optional, type = 'boolean'
;    Set to block the command line from further input while the
;    program is running.
;  C_Annotation : in, optional, type = 'string array'
;    Contour annotations
;  C_Charsize : in, optional, type = 'float array'
;    Contour annotation character size
;  C_Colors : in, optional, type = 'string array'
;    Contour colors
;  C_Labels : in, optional, type = 'string array'
;    Contour labels (binary array)
;  C_Linestyle : in, optional, type = 'integer array'
;    Contour line styles (solid
;  C_Thick : in, optional, type = 'integer array'
;    Contour thickness
;  Charsize : in, optional, type = 'float'
;    Character size for axes
;  Charthick : in, optional, type = 'float'
;    Character thickness for axes
;  Clip : in, optional, type = 'float'
;    Percent to use when histogram clipping the input image.
;  ColorTable : in, optional, type = 'integer'
;    The colortable index to load
;  Contrast : in, optional, type = 'float'
;    Contrast (level)
;  Contours  : in, optional, type = 'boolean array'
;    Binary array for which image should be displayed with contours
;  Deltavel : in, optional, type = 'float'
;    Range to intergated the velocity over
;  Downhill : in, optional, type = 'boolean'
;    Downhill contours
;  Filename : in, optional, type = 'string'
;    Output file name
;  Font : in, optional, type = 'integer'
;    The axes font
;  HighScale : in, optional, type = 'float'
;    The highest value to plot
;  Invert : in, optional, type = 'boolean'
;    Set to invert the color table on load.
;  Levels : in, optional, type = 'float array'
;    Contour levels
;  Limits : in, optional, type = 'float array'
;    Data limits: [xmin
;  LowScale : in, optional, type = 'float'
;    The lowest value to plot
;  Max_value : in, optional, type = 'float'
;    Max value for contours - used with nlevels keyword
;  Mask  : out, optional, type = 'boolean array'
;    Output mask if regions are loaded and selected
;  Min_value : in, optional, type = 'float'
;    Max value for contours - used with nlevels keyword
;  Minor : in, optional, type = 'integer'
;    Minor tick marks
;  NLevels : in, optional, type = 'boolean'
;    Number of contour levels
;  NoAxis : in, optional, type = 'boolean'
;    Don't plot the axis
;  NoBar : in, optional, type = 'boolean'
;    Don't plot the color bar
;  NoGUI : in, optional, type = 'boolean'
;    Set to work only from the command line with no GUI display.
;  OutFile : in, optional, type = 'string'
;    Image output file. Can be jpg
;  Obj : out, optional, type = 'object reference'
;    If working from the command line, you must output this object
;    reference to use the Kang object in batch processing.
;  Position : in, optional, type = 'float array (4)'
;    The position of the plot in the window
;  Quit : in, optional, type = 'boolean'
;    Quit after loaded - good for immediate output of ps files
;  RegionFile : in, optional, type = 'string'
;    Region file to load
;  Reverse : in, optional, type = 'boolean'
;    Set to reverse the color table on load.
;  Scale_To_Image : in, optional, type = 'boolean'
;    Will scale the image based on the min and max of the current image displayed
;  Scaling : in, optional, type = 'string'
;    Which type of scaling to use
;  Sexadecimal : in, optional, type = 'boolean'
;    Sexadecimal numbers on axes
;  Subtitle : in, optional, type = 'string'
;    Subtitle
;  TickColor : in, optional, type = 'string'
;    Tickmark color
;  Ticklen : in, optional, type = 'float'
;    The length of the tickmarks. 0.02 is the default and 1 draws a grid
;  Ticks : in, optional, type = 'integer'
;    Major tick marks
;  Title : in, optional, type = 'string'
;    Title printed above plot
;  TLBID : out, optional, private, type = 'integer'
;    The top level base ID for the GUI.
;  Velocity : in, optional, type = 'float'
;    The velocity of the 3-D image to display
;  ViewInfo : in, optional, type = 'boolean'
;    View info panel at top of display
;  ViewMenubar : in, optional, type = 'boolean'
;    View menubar at top of display
;  ViewSliders : in, optional, type = 'boolean'
;    View brightness, contrast sliders at bottom of display
;  WID : out, optional, type = 'integer'
;    The window ID number for the GUI window.
;  WindowTitle : in, optional, type = 'string'
;    The title of the main window
;  XSize : in, optional, type = 'integer'
;    Size of draw window in x direction
;  XTitle : in, optional, type = 'string'
;    The X-Axis title
;  YSize : in, optional, type = 'integer'
;    Size of draw window in y direction
;  YTitle : in, optional, type = 'string'
;    The Y-Axis title
;       
; :Restrictions:
;       Requires David Fanning's Coyote program library.::
;       Requires the GSFC IDL astronomy user's library.::
;       Requires Craig Markwardt's program library::
;       Written while using Linux; some features may not work under all operating systems.
;
; :History:
;       Written by Loren D. Anderson.::
;    As Plot_Fits::
;       V1.0 First version created to analyze LBV cubes.
;               Beta release November 2007
;       V2.0 Rewritten using objects to allow command line processing.
;               Beta release March 2008
;
;    As Kang::
;       V1.0 Many small updates and changes.
;               Beta release March 2009
;
;       V1.0 Many more bug fixes.
;               Alpha release September 2009
;
;       V1.1 January, 2010
;         	Fixed numerous bugs with how regions were saved, added smoothing ability, added ability
;         	to change order of regions (only command line for now), added functionality for how composite regions
;        	were displayed, sped up calculation of region statistics, added ability to
;         	save object reference after program is called, cleaned up some small heap
;         	memory issues, fixed bug when line regions are drawn, added ability to remember 
;         	when widgets are closed by user, added limited support for FITS extensions.
;
;       V1.2 September, 2010
;               More bug fixes caused by V1.1 upgrades....
;
;       V1.3 May, 2011
;               Added apphot routine for easier aperture photometry, fixed more bugs of course
;               Added scaling percentages to dropdown menu on main GUI
;               Region photometric properties by default use fractional pixels for small regions.
;               Fixed large bug for drawing regions on RA/Dec images
;
;      V1.4 May 2012
;               Added three new region types: row, column, and point
;               Fixed bug when reading in images with type=line set
;-
PRO Kang, $
  image, $                      ; The image data. Can be an array or a filename.
  header, $                     ; The header data.
  AxisColor=axisCname, $        ; The axis color.
  BackColor=backcname, $        ; The background color.
  BarTitle=bartitle, $          ; Colorbar title
  Block=block, $                ; Blocks the command line
  Brightness=brightness, $      ; Brightness (stretch)
  C_Annotation=c_annotation, $  ; Contour annotations
  C_Charsize=c_charsize, $      ; Contour annotation character size
  C_Colors=c_colors, $          ; Contour colors
  C_Labels=c_labels, $          ; Contour labels (binary array)
  C_Linestyle=c_linestyle, $    ; Contour line styles (solid, dashed, etc)
  C_Thick=c_thick, $            ; Contour thickness
  Charsize=charsize, $          ; Character size for axes
  Charthick=charthick, $        ; Character thickness for axes
  Clip=clip, $                  ; The percentage at which to clip the input image
  ColorTable=colortable, $      ; The colortable index to load
  Contrast=contrast, $          ; Contrast (level)
  Contours = contours, $        ; Binary array for which image should be displayed with contours
  Deltavel=deltavel, $          ; Range to intergated the velocity over
  Downhill=downhill, $          ; Downhill contours
  Filename=filename, $          ; Output file name
  Font=font, $                  ; The axes font
  HighScale=highScale, $        ; The highest value to plot
  Invert=invert, $              ; Invert the color table
  Levels=levels, $              ; Contour levels
  Limits=limits, $              ; Data limits: [xmin, xmax, ymin, ymax]
  LowScale=lowScale, $          ; The lowest value to plot
  Max_value=max_value, $        ; Max value for contours - used with nlevels keyword
  Mask = mask, $                ; Output mask
  Min_value=min_value, $        ; Max value for contours - used with nlevels keyword
  Minor=minor, $                ; Minor tick marks
  NLevels=nlevels, $            ; Number of contour levels
  NoAxis=noaxis, $              ; Don't plot the axis
  NoBar=nobar, $                ; Don't plot the color bar
  NoInfo=noinfo, $              ; Don't put info panel at top of display
  NoGUI=nogui, $                ; Don't display the GUI
  NoMenubar=nomenubar, $        ; Don't put menu bar at top of display
  NoSliders=nosliders, $        ; Don't put contrast and brightness sliders at bottom of display
  Obj = obj, $                  ; Output object reference to the kang object
  OutFile=outfile, $            ; Image output file. Can be jpg, ps, gif, etc. This is a scaler
  Position=position, $          ; The position of the plot in the window
  Quit=Quit, $                  ; Quit after loaded - good for immediate output of ps files
  RegionFile=regionfile, $      ; Region file to load
  Reverse=reverse, $            ; Reverse the color table
  Scale_To_Image=scale_to_image, $ ; Will scale the image based on the min and max of the current image displayed
  Scaling=scaling, $            ; Which type of scaling to use
  Sexadecimal=sexadecimal, $    ; Sexadecimal numbers on axes
  Subtitle=subtitle, $          ; Subtitle
  TickColor=tickcname, $        ; Tickmark color
  Ticklen=ticklen, $            ; The length of the tickmarks. 0.02 is the default and 1 draws a grid
  Ticks=ticks, $                ; Major tick marks
  Title=title, $                ; Title printed above plot
  tlbid=tlbid, $                ; Outputs the widget ID of the program. Useful for getting information out if necessary.
  Velocity=velocity, $          ; The velocity of the 3-D image to display
  ViewInfo=viewinfo, $          ; View info panel at top of display
  ViewMenubar=viewmenubar, $    ; View menubar at top of display
  ViewSliders=viewsliders, $    ; View sliders at bottom of display
  Wid=wid, $                    ; This is an output variable for the main draw window ID
  WindowTitle=windowtitle, $    ; The title of the main window
  XSize=xsize, $                ; Size of draw window in x direction
  XTitle=xtitle, $              ; The X-Axis title
  YSize=ysize, $                ; Size of draw window in y direction
  YTitle=ytitle                 ; The Y-Axis title

obj = Obj_New('Kang', $
              image, $
              header, $
              AxisColor=axisCname, $
              BackColor=backcname, $
              BarTitle=bartitle, $
              Block=block, $
              Brightness=brightness, $
              C_Annotation=c_annotation, $
              C_Charsize=c_charsize, $
              C_Colors=c_colors, $
              C_Labels=c_labels, $
              C_Linestyle=c_linestyle, $
              C_Thick=c_thick, $
              Charsize=charsize, $
              Charthick=charthick, $
              Clip=clip, $
              ColorTable=colortable, $
              Contrast=contrast, $
              Contours = contours, $
              Deltavel=deltavel, $
              Downhill=downhill, $
              Filename=filename, $
              Font=font, $
              HighScale=highScale, $
              Invert=invert, $
              Levels=levels, $
              Limits=limits, $
              LowScale=lowScale, $
              Max_value=max_value, $
              Mask = mask, $
              Min_value=min_value, $
              Minor=minor, $
              NLevels=nlevels, $
              NoAxis=noaxis, $
              NoBar=nobar, $
              OutFile=outfile, $
              Position=position, $
              Quit=Quit, $
              RegionFile=regionfile, $
              Reverse=reverse, $
              Scale_To_Image=scale_to_image, $
              Scaling=scaling, $
              Sexadecimal=sexadecimal, $
              Subtitle=subtitle, $
              TickColor=tickcname, $
              Ticklen=ticklen, $
              Ticks=ticks, $
              Title=title, $
              tlbid=tlbid, $
              Velocity=velocity, $
              ViewInfo=viewinfo, $
              ViewMenubar=viewmenubar, $
              ViewSliders=viewsliders, $
              Wid=wid, $
              WindowTitle=windowTitle, $
              XSize=xsize, $
              XTitle=xtitle, $
              YSize=ysize, $
              YTitle=ytitle)

; Bring up GUI
IF ~Keyword_Set(nogui) THEN BEGIN
    obj->GUI, block = block
    obj->File_Dialog_Widget
    obj->Velocity_Widget
ENDIF

END; Kang--------------------------------------------------
