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

'--- ISO CHARSET CODES for Box drawing CP437  (DOS)
CONST cTOPLEFT = 218  ' Top-Left
CONST cTOPRIGHT = 191  ' Top-Right
CONST cBOTTOMLEFT = 192  ' Bottom-Left
CONST cBOTTOMRIGHT = 217  ' Bottom-Right
CONST cHORIZONTAL  = 196  ' Horizontal
CONST cVERTICAL  = 179   ' Vertical
CONST cINTERSECT = 197   ' Intersection
CONST cTDOWN = 194      ' T Down
CONST cTUP = 193        ' T Up   
CONST cSIDE_LEFT = 195    ' T Right
CONST cSIDE_RIGHT = 180   ' T Left   

SUB MENU_DRAW_CLEAR()
    'for j = MnuTopLine to (MnuTopLine + 2) '--- FAILS
    'for j = 57 to 59 '-- WORKS
    POKE 903,65	 : '--- CHANGES THE ROW SIZE SO THE LAST CHAR DOES NOT SCROLL THE SCREEN
    tmp0$ = RPT$(" ",80)
    FOR j = 57 TO 59
        LOCATE j,0 : PRINT tmp0$;
    NEXT 
    POKE 903,GETROWS()	 : '--- RESTORE THE ROW SIZE
END SUB

SUB MENU_DRAW_CTRL()
    curMenu = cMNU_CTRL
    MENU_DRAW_CLEAR
    PrintXY(MnuTopLine  ,0,"CTRL DIR",TXTCOLOR)
    PrintXY(MnuTopLine+1,0,"COMMANDS",TXTCOLOR)
    KeysValid$ = ""
END SUB

SUB MENU_DRAW_BASE_FILE()
    curMenu = cMNU_BASE_FILE
    MENU_DRAW_CLEAR
    PrintXY(MnuTopLine  ,0,"FILE",TXTCOLOR)
    PrintXY(MnuTopLine+1,0,"COMMANDS",TXTCOLOR)
    KeysValid$ = ""
END SUB

SUB MENU_DRAW_BASE_DIR()
    curMenu = cMNU_BASE_DIR
    MENU_DRAW_CLEAR
    PrintXY(MnuTopLine  ,0 ,"DIR",TXTCOLOR)
    PrintXY(MnuTopLine+1,0 ,"COMMANDS",TXTCOLOR)
    PrintXY(MnuTopLine,10,"Avail  Del  Rename  Log  Make  Quit",TXTCOLOR)
    PrintXY(MnuTopLine,10,"A",HIGHCOLOR)
    PrintXY(MnuTopLine,17,"D",HIGHCOLOR)
    PrintXY(MnuTopLine,22,"R",HIGHCOLOR)
    PrintXY(MnuTopLine,30,"L",HIGHCOLOR)
    PrintXY(MnuTopLine,35,"M",HIGHCOLOR)
    PrintXY(MnuTopLine,41,"Q",HIGHCOLOR)
    KeysValid$ = "ADRLMQ"
END SUB

SUB MENU_DRAW_ALT()
    curMenu = cMNU_ALT
    MENU_DRAW_CLEAR
    PrintXY(MnuTopLine  ,0,"ALT DIR",TXTCOLOR)
    PrintXY(MnuTopLine+1,0,"COMMANDS",TXTCOLOR)           
    KeysValid$ = ""
END SUB


'===================================================================================

SUB Box(x,y,w,h,clr) 
    
    '--- draw horizontals
    LINE_HORIZONTAL(x, y, w, clr)
    LINE_HORIZONTAL(x+h-1, y, w, clr)
    
    '--- Draw verticals
    LINE_VERTICAL(x, y , h , clr)
    LINE_VERTICAL(x, y+w, h , clr)

    '--- draw corners
    PlotXY(x, y, cTOPLEFT, clr)
    PlotXY(x, y+w, cTOPRIGHT, clr)
    PlotXY(x+h-1, y, cBOTTOMLEFT, clr)
    PlotXY(x+h-1, y+w, cBOTTOMRIGHT, clr)
    
END SUB


SUB LINE_VERTICAL(x0, y0, length, clr0)  
    FOR i = 0 TO length - 1
        PlotXY(x0 + i, y0, cVERTICAL, clr0)
    NEXT i
END SUB 
SUB LINE_HORIZONTAL(x0, y0, length, clr0)
    PrintXY(x0, y0, RPT$(CHR$(cHORIZONTAL), length), clr0)
END SUB


' TODO needs to be made into ASM for speed - Andy!
' TODO needs to be made into ASM for speed - Andy!

'--- plot a single character at x,y by ascii value with color
SUB PlotXY(row1,col1,s1,clr1) 
    ' TODO needs to be made into ASM for speed - Andy!  TODO  0,0 BASED
    PrintXY(row1,col1,CHR$(s1),clr1)
END SUB
'--- print a string at x,y with color
SUB PrintXY(row2,col2,tmp0$,clr2)
    ' TODO needs to be made into ASM for speed - Andy!  TODO 0,0 BASED
    LOCATE row2,col2 : ' row, col
    COLOR clr2 : PRINT tmp0$;
END SUB

