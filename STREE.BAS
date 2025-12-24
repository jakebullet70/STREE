'-------------------------------------------------------------------------------  
' for the CX16
'
' 
'
' sadLogic / Steve De George SR. / Steve De George JR
' Compile with nxtBasic: https://github.com/unartic/nxtBasic   Windows - CRLF
'-----------------------------------------------------------------------------------
CONST cMNU_ALT = 1
CONST cMNU_CTRL = 2     
CONST cMNU_BASE = 3

#INCLUDE "INC_SOURCE\COLORS.BAS"
DIM MnuTopLine : DIM curMenu   '--- menu vars 

DIM Key$ : DIM KeysCTRL: DIM KeysALT :  '--- key input vars
DIM LINECOLOR: DIM TXTCOLOR : '--- color vars
DIM i: DIM j  '--- general purpose loop vars
'DIM var(9), DIM var$(9) :      '--- general purpose reusable vars

DIM cntDirs : DIM cntFiles  '--- file/directory vars
DIM dir$(99) : DIM files$(249) '--- file and directory arrays
'--- NxtBasic has 80k of string memory for dynamic allocation


'--------------------------- START -----------------------------
EnvSave()
PRINT "STREE - File and Directory Viewer for Commander X16 - V0.1.0"
PRINT "Starting ... "
ReadDIR : ReadFiles 
MnuTopLine = GETROWS() - 3
DrawBaseScreen



'--- drop into the keyloop

KeyLoop:
    key$ = Get
    KeysCTRL = KEYDOWN($3A) OR KEYDOWN($40)
    KeysALT  = KEYDOWN($3C) OR KEYDOWN($3E)

    if KeysALT then
        if curMenu <> cMNU_ALT then     
            MENU_DRAW_ALT()
        END IF  
     END IF

    if KeysCTRL then
        if curMenu <> cMNU_CTRL then
            MENU_DRAW_CTRL()
      END IF
    END IF
    
    if  KeysCTRL = false then
        if KeysALT = false then
            if curMenu <> cMNU_BASE then
                MENU_DRAW_BASE()
            end if
        end if
    end if 
    SLEEP 10

if key$ = "" then GOTO KeyLoop

EnvRestore()
END



'--------------------------- Subs -----------------------------

SUB DrawBaseScreen()
    CLS
    LINECOLOR = cCOLOR_CYAN : TXTCOLOR = cCOLOR_WHITE
    COLOR(cCOLOR_CYAN,cCOLOR_BLUE)
    PrintXY(0, 0,  "STREE V0.1.0", LINECOLOR)   
    PrintXY(0, 60, strPadR("12/11/2025  8:34 PM",20), LINECOLOR)  '--- date/time placeholder TODO`
    box(1, 0, 56, 38, LINECOLOR)
    box(1, 56, 23, 55, LINECOLOR)
    box(38, 0, 56, 18, LINECOLOR)
END SUB


SUB ReadDIR()
END SUB

SUB ReadFiles()
END SUB


SUB EnvSave()
    '--- save environment variables here
    EnvScrnMode = CURSCREENMODE
    EnvCharSet  = PEEK($372)        '--- CHARSET 
    SCREEN 0                        '--- text mode 80COL 
    ENTERISO : SETCHARSET 7
    CurRows = GETROWS() : CurCols = GETCOLS()  
END SUB 
SUB EnvRestore()
    '--- restore environment variables
    EXITISO
    SCREEN EnvScrnMode
    SETCHARSET EnvCharSet
END SUB 



#INCLUDE "INC_SOURCE\STR.BAS"
#INCLUDE "INC_SOURCE\DRAWING.BAS"

