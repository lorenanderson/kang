;+
; NAME:
;  KANG_TEXTBOX
;
; PURPOSE:
;
;  This function allows the user to type some text in a
;  pop-up dialog widget and have it returned to the program.
;  This is an example of a Pop-Up Dialog Widget.
;
; AUTHOR:
;
;       FANNING SOFTWARE CONSULTING
;       David Fanning, Ph.D.
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: davidf@dfanning.com
;       Coyote's Guide to IDL Programming: http://www.dfanning.com
;
; CATEGORY:
;
;  Utility, Widgets
;
; CALLING SEQUENCE:
;
;  thetext = TextBox()
;
; INPUTS:
;
;  None.
;
; KEYWORD PARAMETERS:
;
;  CANCEL: An output parameter. If the user kills the widget or clicks the Cancel
;       button this keyword is set to 1. It is set to 0 otherwise. It
;       allows you to determine if the user canceled the dialog without
;       having to check the validity of the answer.
;
;       theText = TextBox(Title='Provide Phone Number...', Label='Number:', Cancel=cancelled)
;       IF cancelled THEN Return
;
;  GROUP_LEADER: The widget ID of the group leader of this pop-up
;       dialog. This should be provided if you are calling
;       the program from within a widget program:
;
;          thetext = TextBox(Group_Leader=event.top)
;
;       If a group leader is not provided, an unmapped top-level base widget
;       will be created as a group leader.
;
;  LABEL: A string the appears to the left of the text box.  Can be a
;        scalar or a vector.
;
;  NUMBER:  An optional keyword stating the number of text box fields 
;        you'd like.  If not specified, the number of fields in the
;        larger of the number of elements in "value" and "label"
;
;  TITLE:  The title of the top-level base. If not specified, the
;       string 'Provide Input:' is used by default.
;
;  VALUE: A string variable that is the intial value of the textbox. By default, a null string.
;        Can be a scalar or a vector
;
;
;  XSIZE: The size of the text widget in pixel units. By default, 200.
;
;  XOFFSET: X direction offset position to place widget on the display
;
;  YOFFSET: Y direction offset position to place widget on the display
;
;
; OUTPUTS:
;
;  theText: The string of characters the user typed in the
;       text widget. No error checking is done.  For multiple fields,
;       this is a string array.
;
; RESTRICTIONS:
;
;  The widget is destroyed if the user clicks on either button or
;  if they hit a carriage return (CR) in the text widget. The
;  text is recorded if the user hits the ACCEPT button or hits
;  a CR in the text widget.
;
; MODIFICATION HISTORY:
;
;  Written by: David W. Fanning, December 20, 2001.
;  Added VALUE keyword to set the initial value of the text box. 4 Nov 2002. DWF.
;  Made vectorized to allow multiple boxes, added number keyword,
;     changed name to kang_textbox. November 2007 L. Anderson.
;-
;
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright � 2000-2002 Fanning Software Consulting.
;
; This software is provided "as-is", without any express or
; implied warranty. In no event will the authors be held liable
; for any damages arising from the use of this software.
;
; Permission is granted to anyone to use this software for any
; purpose, including commercial applications, and to alter it and
; redistribute it freely, subject to the following restrictions:
;
; 1. The origin of this software must not be misrepresented; you must
;    not claim you wrote the original software. If you use this software
;    in a product, an acknowledgment in the product documentation
;    would be appreciated, but is not required.
;
; 2. Altered source versions must be plainly marked as such, and must
;    not be misrepresented as being the original software.
;
; 3. This notice may not be removed or altered from any source distribution.
;
; For more information on Open Source Software, visit the Open Source
; web site: http://www.opensource.org.
;
;###########################################################################

PRO Kang_TextBox_Event, event

   ; This event handler responds to all events. Widget
   ; is always destoyed. The text is recorded if ACCEPT
   ; button is selected or user hits CR in text widget.

Widget_Control, event.top, Get_UValue=info
CASE event.ID OF
   info.cancelID: Widget_Control, event.top, /Destroy
   ELSE: BEGIN

         ; Get the text and store it in the pointer location.

       FOR i = 0, N_Elements(info.textID)-1 DO BEGIN
           Widget_Control, info.textID[i], Get_Value=theText
           (*info.ptr).text[i] = theText[0]
       ENDFOR
       (*info.ptr).cancel = 0
      Widget_Control, event.top, /Destroy
      ENDCASE
ENDCASE
END ;-----------------------------------------------------



FUNCTION Kang_TextBox, number, Title=title, Label=label, Cancel=cancel, $
  Group_Leader=groupleader, XSize=xsize, Value=value, column=column, $
  XOffset = xoffset, YOffset = YOffset


   ; Return to caller if there is an error. Set the cancel
   ; flag and destroy the group leader if it was created.

Catch, theError
IF theError NE 0 THEN BEGIN
   Catch, /Cancel
   ok = Dialog_Message(!Error_State.Msg)
   IF destroy_groupleader THEN Widget_Control, groupleader, /Destroy
   cancel = 1
   RETURN, ""
ENDIF

   ; Check parameters and keywords.

n_label = N_Elements(label)
n_value =N_Elements(value)
IF N_Elements(number) EQ 0 THEN number=1 > n_label > n_value
IF N_Elements(title) EQ 0 THEN title = 'Provide Input:'
IF n_label EQ 0 THEN label = Replicate("", number)

; Add new strings to the end
IF n_label LT number THEN label = [label, Replicate("", number-n_label)]

; Make all strings the same length
length = StrLen(label)
maxLength = Max(length)
FOR i = 0, number-1 DO IF length[i] LT maxlength THEN label[i] = label[i] + String(Replicate(32B, maxlength-length[i]))

IF N_Elements(value) EQ 0 THEN value = Replicate("", number)
IF n_value LT number THEN value = [value, Replicate("", number-n_value)]
IF N_Elements(xsize) EQ 0 THEN xsize = 200
IF N_Elements(column) EQ 0 THEN column = number < 2


   ; Provide a group leader if not supplied with one. This
   ; is required for modal operation of widgets. Set a flag
   ; for destroying the group leader widget before returning.

IF N_Elements(groupleader) EQ 0 THEN BEGIN
   groupleader = Widget_Base(Map=0)
   Widget_Control, groupleader, /Realize
   destroy_groupleader = 1
ENDIF ELSE destroy_groupleader = 0

   ; Create modal base widget.

tlb = Widget_Base(Title=title, Column=1, /Modal, $
   /Base_Align_Center, Group_Leader=groupleader)
subBase = Widget_Base(tlb, Column=column)

   ; Create the rest of the widgets.
textID = lonArr(number)
FOR i = 0, number-1 DO BEGIN
    labelbase = Widget_Base(subBase, Row=1)
    IF label[i] NE "" THEN labelID = Widget_Label(labelbase, Value=label[i])
    textID[i] = Widget_Text(labelbase, /Editable, Scr_XSize=xsize, Value=value[i])
ENDFOR
buttonBase = Widget_Base(tlb, Row=1)
cancelID = Widget_Button(buttonBase, Value='Cancel')
acceptID = Widget_Button(buttonBase, Value='Accept')

   ; Center the widgets on display.
IF N_Elements(xoffset) EQ 0 AND N_Elements(yoffset) EQ 0 THEN CenterTLB, tlb $
ELSE Widget_Control, tlb, XOffset=XOffset, YOffset=YOffset
Widget_Control, tlb, /Realize

   ; Create a pointer for the text the user will type into the program.
   ; The cancel field is set to 1 to indicate that the user canceled
   ; the operation. Only if a successful conclusion is reached (i.e.,
   ; a Carriage Return or Accept button selection) is the cancel field
   ; set to 0.

ptr = Ptr_New({text:StrArr(number), cancel:1})

   ; Store the program information:

info = {ptr:ptr, textID:textID, cancelID:cancelID}
Widget_Control, tlb, Set_UValue=info, /No_Copy

   ; Blocking or modal widget, depending upon group leader.

XManager, 'kang_textbox', tlb

   ; Return from block. Return the text to the caller of the program,
   ; taking care to clean up pointer and group leader, if needed.
   ; Set the cancel keyword.

theText = (*ptr).text
cancel = (*ptr).cancel
Ptr_Free, ptr
IF destroy_groupleader THEN Widget_Control, groupleader, /Destroy

RETURN, theText
END ;-----------------------------------------------------