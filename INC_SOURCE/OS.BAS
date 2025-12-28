'-------------------------------------------------------------------------------  
' for the CX16
'
' 
'
' sadLogic / Steve De George SR. / Steve De George JR
' Compile with nxtBasic: https://github.com/unartic/nxtBasic   Windows - CRLF
'-----------------------------------------------------------------------------------
'--- OS BASICS INCLUDE FILE
'-----------------------------------------------------------------------------------

'--- OS CONSTANTS
CONST CHROUT = $FFD2   '--- OS Char out routine
'CONST cOS_BUILD$' = "2024-06-10"  '--- OS BUILD DATE STRING  

'--- OS Crap
SUB CursorEnable()
    LDA 20 : LDX 0 : SYS $FEAB
END SUB
SUB CursorDisable()
    LDA 20 : LDX 1 : SYS $FEAB
END SUB



' TODO needs to be made into ASM for speed - Andy!
' TODO needs to be made into ASM for speed - Andy!

'--- plot a single character at x,y by ascii value with color
SUB PlotXY(row1,col1,s1,clr1) 
    ' TODO needs to be made into ASM for speed - Andy!  TODO  0,0 BASED
    'PrintXY(row1,col1,CHR$(s1),clr1)
    LOCATE row1,col1 : ' row, col
    COLOR clr1 : LDA s1 : SYS CHROUT
END SUB

'--- print a string at x,y with color
SUB PrintXY(row2,col2,tmp0$,clr2)
    ' TODO needs to be made into ASM for speed - Andy!  TODO 0,0 BASED
    LOCATE row2,col2 : ' row, col
    COLOR clr2 : PRINT tmp0$;
END SUB



