'-------------------------------------------------------------------------------  
' for the CX16
'
' 
'
' sadLogic / Steve De George SR. / Steve De George JR
' Compile with nxtBasic: https://github.com/unartic/nxtBasic   Windows - CRLF
'-----------------------------------------------------------------------------------


' Corners and sides (PETSCII codes)
' CONST TOPLEFT = 112  ' Top-Left
' CONST TOPRIGHT = 110  ' Top-Right
' CONST BOTTOMLEFT = 109  ' Bottom-Left
' CONST BOTTOMRIGHT = 125  ' Bottom-Right
' CONST HORIZONTAL  = 64   ' Horizontal
' CONST VERTICAL  = 93   ' Vertical
CONST TOPLEFT = 218  ' Top-Left
CONST TOPRIGHT = 191  ' Top-Right
CONST BOTTOMLEFT = 192  ' Bottom-Left
CONST BOTTOMRIGHT = 217  ' Bottom-Right
CONST HORIZONTAL  = 196  ' Horizontal
CONST VERTICAL  = 179   ' Vertical
CONST INTERSECT = 197   ' Intersection

SUB BOX(x,y,w,h,clr) 
    DIM i
    
    '--- draw corners
    PrintXY(x, y, TOPLEFT, clr)
    PrintXY(x + w - 1, y, TOPRIGHT, clr)
    PrintXY(x, y + h-1, BOTTOMLEFT, clr)
    PrintXY(x + w - 1, y + h - 1, BOTTOMRIGHT, clr)

    '--- draw horizontals
    LINE_HORIZONTAL(x, y, w, clr)
    LINE_HORIZONTAL(x, y + h - 1, w, clr)

    '--- Draw verticals
    LINE_VERTICAL(x, y + 1, h - 2, clr)
    LINE_VERTICAL(x + w - 1, y + 1, h - 2, clr)

END SUB


SUB LINE_VERTICAL(x, y, length, clr)  
    DIM i
    FOR i = 0 TO length - 1
        PlotXY(x + i, y, VERTICAL, clr)
        'LOCATE x+i,y : PRINT chr$(VERTICAL);
    NEXT i
END SUB 
SUB LINE_HORIZONTAL(x, y, length, clr)
    PrintXY(x, y, RPT$(CHR$(HORIZONTAL), length), clr)
END SUB


' TODO needs to be made into ASM for speed - Andy!
' TODO needs to be made into ASM for speed - Andy!

'--- plot a single character at x,y by ascii value with color
SUB PlotXY(x1,y1,s1,clr1) 
    ' TODO needs to be made into ASM for speed - Andy!  TODO  0,0 BASED
    PrintXY(x1,y1,CHR$(s1),clr1)
END SUB
'--- print a string at x,y with color
SUB PrintXY(x2,y2,tmp0$,clr2)
    ' TODO needs to be made into ASM for speed - Andy!  TODO 0,0 BASED
    LOCATE x2,y2 : ' row, col
    COLOR clr2 : PRINT tmp0$;
END SUB
    
