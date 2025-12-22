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
    
    '--- draw horizontals
    LINE_HORIZONTAL(x, y, w, clr)
    LINE_HORIZONTAL(x+h-1, y, w, clr)
    
    '--- Draw verticals
    LINE_VERTICAL(x, y , h , clr)
    LINE_VERTICAL(x, y+w, h , clr)

    '--- draw corners
    PrintXY(x, y, TOPLEFT, clr)
    PrintXY(x, y+w-1, TOPRIGHT, clr)
    PrintXY(x+h-1, y, BOTTOMLEFT, clr)
    PrintXY(x+h-1, y+w-1, BOTTOMRIGHT, clr)
    
END SUB


SUB LINE_VERTICAL(x0, y0, length, clr0)  
    DIM i
    FOR i = 0 TO length - 1
        PlotXY(x0 + i, y0, VERTICAL, clr0)
        'LOCATE x+i,y : PRINT chr$(VERTICAL);
    NEXT i
END SUB 
SUB LINE_HORIZONTAL(x0, y0, length, clr0)
    PrintXY(x0, y0, RPT$(CHR$(HORIZONTAL), length), clr0)
END SUB






' TODO needs to be made into ASM for speed - Andy!
' TODO needs to be made into ASM for speed - Andy!

'--- plot a single character at x,y by ascii value with color
SUB PlotXY(row1,row2,s1,clr1) 
    ' TODO needs to be made into ASM for speed - Andy!  TODO  0,0 BASED
    PrintXY(row1,row2,CHR$(s1),clr1)
END SUB
'--- print a string at x,y with color
SUB PrintXY(row2,col2,tmp0$,clr2)
    ' TODO needs to be made into ASM for speed - Andy!  TODO 0,0 BASED
    LOCATE row2,col2 : ' row, col
    COLOR clr2 : PRINT tmp0$;
END SUB
    






' I've been following the progress of a pretty significant change to how keyboard scancodes are going to work, and saw that the pull request just got merged. I thought it would be pretty helpful to have a diagram of it (and needed something fun to do), so here it is:
' ,---,   ,---,---,---,---, ,---,---,---,---, ,---,---,---,---, ,---,---,---,
' | 6E| 6F| 70| 71| 72| 73| | 74| 75| 76| 77| | 78| 79| 7A| 7B| | 7C| 7D| 7E|   o     o     o
' '---'   '---'---'---'---' '---'---'---'---' '---'---'---'---' '---'---'---'
' ,---,---,---,---,---,---,---,---,---,---,---,---,---,-------, ,---,---,---, ,---,---,---,---,
' | 01| 02| 03| 04| 05| 06| 07| 08| 09| 0A| 0B| 0C| 0D|!0E->0F| | 4B| 50| 55| | 5A| 5F| 64| 69|
' ;---'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-----; ;---;---;---; ;---;---;---;---;
' | 10  | 11| 12| 13| 14| 15| 16| 17| 18| 19| 1A| 1B| 1C|   1D| | 4C| 51| 56| | 5B| 60| 65| 6A|
' ;-----',--',--',--',--',--',--',--',--',--',--',--',--'-----; '---'---'---' ;---;---;---;   |
' | 1E   | 1F| 20| 21| 22| 23| 24| 25| 26| 27| 28| 29|!2A-->2B|   4D  52  57  | 5C| 61| 66|!6B|
' ;------'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'--------;     ,---,     ;---;---;---;---;
' | 2C<-!2D| 2E| 2F| 30| 31| 32| 33| 34| 35| 36| 37|!38---->39|   4E| 53| 58  | 5D| 62| 67| 6C|
' ;----,---',--'-,-'---'---'---'---'---'---'---',--'-,----,---; ,---;---;---, ;---'---;---;   |
' | 3A | 3B | 3C |              3D              | 3E | 3F | 40| | 4F| 54| 59| |!5E->63| 68|!6D|
' '----'----'----'------------------------------'----'----'---' '---'---'---' '-------'---'---'
' !XX--->YY means, the position of XX is not used and the key actually triggers YY.
' Between right ctrl and insert, the position numbers skip enough to add 2 extra columns of keys.


