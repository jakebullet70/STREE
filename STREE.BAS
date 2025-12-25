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
CONST cMNU_BASE_DIR = 3
CONST cMNU_BASE_FILE = 4

#INCLUDE "INC_SOURCE\COLORS.BAS"
DIM MnuTopLine : DIM curMenu            '--- menu vars 

DIM i: DIM j                            '--- general purpose loop vars
DIM tmp0$ : tmp0$ = RPT$(" ",90)        '--- general purpose temp vars
DIM tmp1$ : tmp1$ = tmp0$ : DIM mTmp    '--- general purpose temp vars    

DIM Key$ : Key$ = " "  '--- key input var 
DIM KeysCTRL: DIM KeysALT : DIM KeysValid$ 
DIM MenuPrompt$ : MenuPrompt$ = tmp0$ 
DIM KeyPressed$ '--- key input vars
DIM IsDirSelected  '--- selection vars - files / directories
IsDirSelected = true

CONST cMAX_FILE = 249
CONST cMAX_DIR = 99
CONST cMAX_PATH_LEN = 96
DIM cntDirs : DIM cntFiles  '--- file/directory vars
DIM dir$(cMAX_DIR) : DIM files$(cMAX_FILE) '--- file and directory arrays
InitArrays()    
'--- NxtBasic has 80k of string memory for dynamic allocation


'--------------------------- START -----------------------------
EnvSave()
PRINT "STREE - File and Directory Viewer for Commander X16 - V0.1.0"
PRINT "Starting ... "
ReadDIR() : ReadFiles() 
MnuTopLine = CurRows - 3
DrawBaseScreen()


'--- drop into the keyloop

KeyLoop:
    key$ = Get
    KeysCTRL = KEYDOWN($3A) OR KEYDOWN($40)
    KeysALT  = KEYDOWN($3C) OR KEYDOWN($3E)

    IF KeysALT THEN
        IF curMenu <> cMNU_ALT THEN     
            MENU_DRAW_ALT()
        END IF  
     END IF

    IF KeysCTRL THEN
        IF curMenu <> cMNU_CTRL THEN
            MENU_DRAW_CTRL()
      END IF
    END IF
    
    IF  KeysCTRL = false AND KeysALT = false THEN
        IF IsDirSelected THEN
            IF curMenu <> cMNU_BASE_DIR THEN
                MENU_DRAW_BASE_DIR()
            END IF
        ELSE
            IF curMenu <> cMNU_BASE_FILE THEN
                MENU_DRAW_BASE_FILE()
            END IF
        END IF
    END IF
    SLEEP 10

    IF key$ <> "" THEN
        KeyPressed$ = UCASE$(key$)  
        IF INSTR(1, KeysValid$, KeyPressed$) THEN
            IF curMenu = cMNU_CTRL THEN
                KEYS_CTRL_PROCESS()
            ELSEIF curMenu = cMNU_ALT THEN      
                KEYS_ALT_PROCESS()
            ELSEIF curMenu = cMNU_BASE_FILE THEN
                KEYS_FILE_PROCESS()  
            ELSEIF curMenu = cMNU_BASE_DIR THEN
                KEYS_DIR_PROCESS()    
            END IF
        ELSE
            '--- ARROW KEYS - TAB
        END IF
    END IF 

GOTO KeyLoop

OutOfHere:
EnvRestore()
END



'--------------------------- Subs -----------------------------

SUB DrawBaseScreen()
    CLS
    DIM LINECOLOR: DIM TXTCOLOR : '--- color vars
    DIM HIGHCOLOR
    LINECOLOR = cCOLOR_CYAN : TXTCOLOR = cCOLOR_WHITE : HIGHCOLOR = LINECOLOR
    COLOR(cCOLOR_CYAN,cCOLOR_BLUE)
    PrintXY(0, 0,  "STREE V0.1.0", LINECOLOR)   
    PrintXY(0, 60, strPadR("12/11/2025  8:34 PM",20), LINECOLOR)  '--- date/time placeholder TODO`
    BOX(1, 0, 56, 38, LINECOLOR)
    BOX(1, 56, 23, 55, LINECOLOR)
    BOX(38, 0, 56, 18, LINECOLOR)
END SUB


SUB ReadDIR()
END SUB

SUB ReadFiles()
END SUB

SUB InitArrays()
    tmp0$ = RPT$(" ",cMAX_PATH_LEN)
    FOR i = 0 to cMAX_DIR
        dir$(i) = tmp0$
    NEXT i  
    FOR i = 0 to cMAX_FILE
        files$(i) = tmp0$
    NEXT i
    cntDirs = 0 : cntFiles = 0
END SUB

SUB EnvSave() 
   '--- save environment variables here
   ' TODO : nee to save current txt  bg color
    DIM EnvScrnMode : DIM EnvCharSet
    DIM CurRows : DIM CurCols
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
    PRINT "HAVE A NICE DAY!"
END SUB 


#INCLUDE "INC_SOURCE\DRAWING.BAS"
#INCLUDE "INC_SOURCE\PROCESS_KEYS.BAS"
#INCLUDE "INC_SOURCE\STR.BAS"