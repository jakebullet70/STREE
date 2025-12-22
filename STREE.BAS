'-------------------------------------------------------------------------------  
' for the CX16
'
' 
'
' sadLogic / Steve De George SR. / Steve De George JR
' Compile with nxtBasic: https://github.com/unartic/nxtBasic   Windows - CRLF
'-----------------------------------------------------------------------------------


#INCLUDE "INC_SOURCE\COLORS.BAS"

DIM var(9), DIM var$(9) :      '--- general purpose reusible vars
DIM dir$(99) : DIM files$(249) '--- file and directory arrays
'--- NxtBasic has 80k of string memory for dynamic allocation


'--------------------------- START -----------------------------
SCREEN 0 '--- text mode 80COL  TODO: save old screen mode and restore on exit
ENTERISO 
PRINT "STREE - File and Directory Viewer for Commander X16 - V0.1.0"
PRINT "Starting ... "
ReadDIR : ReadFiles 
COLOR(cCOLOR_CYAN,cCOLOR_BLUE)
LINECOLOR = cCOLOR_CYAN : TXTCOLOR = cCOLOR_WHITE
DrawBaseScreen

'--- drop into the keyloop

KeyLoop:
    key$ = Get
    KeysCTRL = KEYDOWN($3A) OR KEYDOWN($40)
    KeysALT = KEYDOWN($3C) or KEYDOWN($3E)

    if KeysALT then
       locate 10,10 :  PRINT "ALT key is pressed";
     else
       locate 10,10 :  PRINT "                     ";
     END IF

    if KeysCTRL then
      locate 20,20 :  PRINT "CTRL key is pressed";
    else
      locate 20,20 :  PRINT "                     ";    
    END IF

if key$ = "" then GOTO KeyLoop

EXITISO : END



'--------------------------- Subs -----------------------------

SUB DrawBaseScreen()
    CLS
    PrintXY(0, 0,  "STREE V0.1.0", LINECOLOR)   
    PrintXY(0, 60, strPadR("12/11/2025  8:34 PM",20), LINECOLOR)
    box(1, 0, 56, 38, LINECOLOR)
    box(1, 56, 23, 56, LINECOLOR)
    box(40, 0, 56, 16, LINECOLOR)
END SUB


SUB ReadDIR()
END SUB

SUB ReadFiles()
END SUB



#INCLUDE "INC_SOURCE\STR.BAS"
#INCLUDE "INC_SOURCE\DRAWING.BAS"