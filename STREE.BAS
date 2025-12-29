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

'DIM DEBUG_COUNTER : DEBUG_COUNTER = 0

#INCLUDE "INC_SOURCE\COLORS.BAS"
DIM MnuTopLine : DIM curMenu            '--- menu vars 

DIM i: DIM j                            '--- general purpose loop vars
DIM tmp0$ : tmp0$ = RPT$(" ",90)        '--- general purpose temp vars
DIM tmp1$ : tmp1$ = tmp0$ : DIM mTmp    '--- general purpose temp vars    

DIM Key$ : Key$ = " "                   '--- key input var 
DIM KeysCTRL: DIM KeysALT : DIM KeysValid$ 
DIM MenuPrompt$ : MenuPrompt$ = tmp0$       '--- menu prompt key input var
DIM IsDirSelected                           '--- selection vars - files / directories
IsDirSelected = true

CONST cMAX_ITEMS = 199
CONST cMAX_PATH_LEN = 90
DIM cntDirs1 : DIM cntFiles1 : DIM cntDirs2 : DIM cntFiles2 '--- file/directory counts for each panel
DIM CurrDir1$ : DIM CurrDir2$ '--- current directory strings for each panel
DIM Items1$(cMAX_ITEMS) : DIM Items2$(cMAX_ITEMS) '--- file/directory name arrays for each panel
DIM Items_tagged1$(cMAX_ITEMS) : DIM Items_tagged2$(cMAX_ITEMS) '--- tagged items arrays for each panel

CONST cCURRENT_PANEL_1 = 1
CONST cCURRENT_PANEL_2 = 2
CurrentPanel = cCURRENT_PANEL_1

'--- Selection and navigation state
DIM SelIdx1 : DIM SelIdx2 : DIM RowOffset1 : DIM RowOffset2
DIM visRows : DIM maxOffset : DIM ttlItems


'--- Key scancodes we handle directly here (fallback/variants included)
CONST cKEY_DOWN = 17
CONST cKEY_UP   = 145
CONST cKEY_LEFT = 157
CONST cKEY_RIGHT = 29
CONST cKEY_TAB = 9

'--------------------------- START -----------------------------
EnvSave()
PRINT "STREE - FILE & DIRECTORY MANAGER FOR THE CX16 - V0.1.0"
PRINT "STARTING ... "

ShowHidden = false '--- default to not showing hidden files
CurrDir1$ = CurDir$()
InitArrays()
ReadItems(1) : DupePanel1To2()
MnuTopLine = GETROWS() - 3
DrawBaseScreen()
DrawPanels()

'--- drop into the keyloop

KeyLoop:
    'SLEEP 5
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
    
    IF key$ <> "" THEN
        Key$ = UCASE$(key$)  
        '--- KeysValid$ holds valid keys for the current menu
        IF INSTR(1, KeysValid$, Key$) THEN 
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
            DIM sc : sc = ASC(Key$)
            IF sc = cKEY_DOWN THEN
                IF CurrentPanel = cCURRENT_PANEL_1 THEN
                    MoveSelectionDown(1)
                ELSE
                    MoveSelectionDown(2)
                END IF
            ELSEIF sc = cKEY_UP THEN
                IF CurrentPanel = cCURRENT_PANEL_1 THEN
                    MoveSelectionUp(1)
                ELSE
                    MoveSelectionUp(2)
                END IF
            ELSEIF sc = cKEY_TAB THEN
                SwitchPanel()
            END IF
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
    '--- XTree style boxes
    'Box(1, 0, 56, 38, LINECOLOR)
    'Box(1, 56, 23, 55, LINECOLOR)
    'Box(38, 0, 56, 18, LINECOLOR)
    '--- Norton Commander style boxes
    Box(1, 0, GETCOLS()/2, 3, LINECOLOR)
    Box(1, GETCOLS()/2, 39, 3, LINECOLOR)
    Box(3, 0, GETCOLS()/2, GETROWS()-6, LINECOLOR)
    Box(3, GETCOLS()/2, 39,GETROWS()-6, LINECOLOR)
    PlotXY(1,GETCOLS()/2, cTDOWN, LINECOLOR)
    PlotXY(3,GETCOLS()/2, cINTERSECT, LINECOLOR)
    PlotXY(3,0 , cSIDE_LEFT, LINECOLOR)        
    PlotXY(3,GETCOLS()-1, cSIDE_RIGHT, LINECOLOR)        
    PlotXY(GETROWS()-4,GETCOLS()/2, cTUP, LINECOLOR)        
END SUB

SUB DupePanel1To2()
    FOR i = 0 to cMAX_ITEMS - 1
        Items2$(i) = Items1$(i)
        'Items_tagged2$(i) = Items_tagged1$(i)
    NEXT i
    cntDirs2 = cntDirs1
    cntFiles2 = cntFiles1
    CurrDir2$ = CurrDir1$
END SUB

SUB ReadItems(PanelNum)
    DIM tmpCDir$ : DIM curListCount : DIM nNumItems
    
    IF PanelNum = 1 THEN '--- if '/' then ROOT
        tmpCDir$ = CurrDir1$
    ELSE
        tmpCDir$ = CurrDir2$
    END IF

    nNumItems = DIRLIST("*","*",LIST_DIRS)  
    curListCount = 0
    IF LEN(tmpCDir$) > 1 THEN
        IF PanelNum = 1 THEN
            Items1$(curListCount) = "/.." '--- parent dir entry
        ELSE
            Items2$(curListCount) = "/.." '--- parent dir entry
        END IF
        curListCount = curListCount + 1
    END IF

    FOR j = 0 TO nNumItems - 1
        tmp0$ = DIRITEM()
        '--- HostFS does not return the . and .. items. hardware/sd card does
        if tmp0$ <> "." AND tmp0$ <> ".." THEN    
            'fname$ = FixUpChars(fname$)   '--- lcase$ or PETSCII or ??
            IF LEN(tmp0$) = 0 THEN CONTINUE
            IF ShowHidden = false AND LEFT$(tmp0$,1) = "." THEN CONTINUE
            IF PanelNum = 1 THEN
                Items1$(curListCount) = "[" + tmp0$ + "]"
            ELSE
                Items2$(curListCount) = "[" + tmp0$ + "]"
            END IF
        END IF
        curListCount = curListCount + 1
    NEXT
    CLOSEDIRLIST()
    IF PanelNum = 1 THEN
        cntDirs1 = nNumItems
    ELSE
        cntDirs2 = nNumItems
    END IF
    
    nNumItems = DIRLIST("*","*",LIST_FILES) '--- files now
    FOR j = 0 to nNumItems - 1
        tmp0$ = DIRITEM()
        IF LEN(tmp0$) = 0 THEN CONTINUE
        IF ShowHidden = false AND LEFT$(tmp0$,1) = "." THEN CONTINUE
        IF PanelNum = 1 THEN
            Items1$(curListCount + j) = tmp0$ 
        ELSE
            Items2$(curListCount + j) = tmp0$ 
        END IF
    NEXT 
    CLOSELIST()
    IF PanelNum = 1 THEN
        cntFiles1 = nNumItems
    ELSE
        cntFiles2 = nNumItems
    END IF

END SUB

SUB InitArrays()
    tmp0$ = RPT$(" ",cMAX_PATH_LEN) 
    FOR i = 0 to cMAX_ITEMS - 1
        Items1$(i) = tmp0$
        Items_tagged1$(i) = " "
        Items2$(i) = tmp0$
        Items_tagged2$(i) = " "
    NEXT i
    cntDirs1 = 0 : cntFiles1 = 0 : cntDirs2 = 0 : cntFiles2 = 0
    '--- initialize selection state
    SelIdx1 = 0 : SelIdx2 = 0
    RowOffset1 = 0 : RowOffset2 = 0
END SUB


'================ Navigation helpers =====================================
SUB SwitchPanel()
    IF CurrentPanel = cCURRENT_PANEL_1 THEN
        CurrentPanel = cCURRENT_PANEL_2
    ELSE
        CurrentPanel = cCURRENT_PANEL_1
    END IF
    '--- Redraw menu/footer for new panel
    'MENU_DRAW_BASE_DIR()
    DrawPanels()
END SUB

SUB MoveSelectionUp(PanelNum)
    
    IF PanelNum = 1 THEN
        ttlItems = cntDirs1 + cntFiles1
        IF LEN(CurrDir1$) > 1 THEN ttlItems = ttlItems + 1
        IF ttlItems = 0 THEN SelIdx1 = 0 : GOTO msu_end
        SelIdx1 = SelIdx1 - 1
        IF SelIdx1 < 0 THEN SelIdx1 = 0
        IF SelIdx1 > ttlItems - 1 THEN SelIdx1 = ttlItems - 1
    ELSE
        ttlItems = cntDirs2 + cntFiles2
        IF LEN(CurrDir2$) > 1 THEN ttlItems = ttlItems + 1
        IF ttlItems = 0 THEN SelIdx2 = 0 : GOTO msu_end
        SelIdx2 = SelIdx2 - 1
        IF SelIdx2 < 0 THEN SelIdx2 = 0
        IF SelIdx2 > ttlItems - 1 THEN SelIdx2 = ttlItems - 1
    END IF
msu_end:
    '--- ensure selection visible
    EnsureSelectionVisible(PanelNum)
    '--- refresh UI
    DrawPanel(PanelNum)
END SUB

SUB MoveSelectionDown(PanelNum)
    
    IF PanelNum = 1 THEN
        ttlItems = cntDirs1 + cntFiles1
        IF LEN(CurrDir1$) > 1 THEN ttlItems = ttlItems + 1
        IF ttlItems = 0 THEN SelIdx1 = 0 : GOTO msd_end
        SelIdx1 = SelIdx1 + 1
        IF SelIdx1 > ttlItems - 1 THEN SelIdx1 = ttlItems - 1
    ELSE
        ttlItems = cntDirs2 + cntFiles2
        IF LEN(CurrDir2$) > 1 THEN ttlItems = ttlItems + 1
        IF ttlItems = 0 THEN SelIdx2 = 0 : GOTO msd_end
        SelIdx2 = SelIdx2 + 1
        IF SelIdx2 > ttlItems - 1 THEN SelIdx2 = ttlItems - 1
    END IF
msd_end:
    '--- ensure selection visible
    EnsureSelectionVisible(PanelNum)
    '--- refresh UI
    DrawPanel(PanelNum)
END SUB



'================= Panel rendering ======================================
SUB DrawPanels()
    'DEBUG_STRING("DRAW PANELS CALL:" + STR$(DEBUG_COUNTER)) 
    DrawPanel(1)
    DrawPanel(2)
END SUB

SUB DrawPanel(PanelNum)
    'DEBUG_COUNTER = DEBUG_COUNTER + 1

    DIM visRows : DIM startRow : DIM startCol : DIM width  
    DIM iz : DIM r : DIM idx : DIM text$ : DIM hdr$ : DIM headerRow : DIM total
    visRows = GETROWS() - 8 ' space for borders and menu
    startRow = 4
    width = (GETCOLS() / 2) - 4
    IF PanelNum = 1 THEN
        startCol = 2
        ttlItems = cntDirs1 + cntFiles1
        IF LEN(CurrDir1$) > 1 THEN ttlItems = ttlItems + 1
    ELSE
        startCol = (GETCOLS() / 2) + 2
        ttlItems = cntDirs2 + cntFiles2
        IF LEN(CurrDir2$) > 1 THEN ttlItems = ttlItems + 1
    END IF

    '--- draw panel header (current dir) with active/inactive color
    DrawPanelHeader(PanelNum)

    FOR iz = 0 TO visRows - 1
        r = startRow + iz
        IF PanelNum = 1 THEN
            idx = RowOffset1 + iz
            IF idx >= ttlItems THEN
                text$ = RPT$(" ", width)
            ELSE
                text$ = Items1$(idx)
                text$ = LEFT$(text$, width) + RPT$(" ", width - LEN(LEFT$(text$, width)))
            END IF
        ELSE
            idx = RowOffset2 + iz
            IF idx >= ttlItems THEN
                text$ = RPT$(" ", width)
            ELSE
                text$ = Items2$(idx)
                text$ = LEFT$(text$, width) + RPT$(" ", width - LEN(LEFT$(text$, width)))
            END IF
        END IF

        '--- highlight selected item
        IF PanelNum = 1 AND idx = SelIdx1 THEN
            PrintXYColor(r, startCol, text$, cCOLOR_BLUE, cCOLOR_WHITE)
        ELSEIF PanelNum = 2 AND idx = SelIdx2 THEN
            PrintXYColor(r, startCol, text$, cCOLOR_BLUE, cCOLOR_WHITE)
        ELSE
            PrintXYColor(r, startCol, text$, cCOLOR_LIGHT_GRAY, cCOLOR_BLUE)
        END IF
    NEXT 
END SUB

SUB DrawPanelHeader(PanelNum)
    DIM headerRow 
    DIM startRow  
    DIM startCol  
    DIM width 
    DIM hdr$
    startRow = 4
    width = (GETCOLS() / 2) - 4
    IF PanelNum = 1 THEN
        startCol = 2
        hdr$ = CurrDir1$
    ELSE
        startCol = (GETCOLS() / 2) + 2
        hdr$ = CurrDir2$
    END IF

    IF LEN(hdr$) = 0 THEN hdr$ = "/"
    headerRow = startRow - 2

    '--- build header string, trimmed/padded to width
    hdr$ = hdr$ + RPT$(" ", width - LEN(hdr$))

    IF PanelNum = CurrentPanel THEN
        'PrintXYColor(headerRow, startCol, hdr$, cCOLOR_BLUE, cCOLOR_WHITE) ' BOOM
    ELSE
        'PrintXYColor(headerRow, startCol, hdr$, cCOLOR_WHITE, cCOLOR_BLUE)  ' BOOM
    END IF

END SUB

SUB EnsureSelectionVisible(PanelNum)    
    visRows = GETROWS() - 8
    IF PanelNum = 1 THEN
        ttlItems = cntDirs1 + cntFiles1
        IF LEN(CurrDir1$) > 1 THEN ttlItems = ttlItems + 1
    ELSE
        ttlItems = cntDirs2 + cntFiles2
        IF LEN(CurrDir2$) > 1 THEN ttlItems = ttlItems + 1
    END IF
    maxOffset = ttlItems - visRows
    IF maxOffset < 0 THEN maxOffset = 0
    IF PanelNum = 1 THEN
        IF SelIdx1 < RowOffset1 THEN RowOffset1 = SelIdx1
        IF SelIdx1 >= RowOffset1 + visRows THEN RowOffset1 = SelIdx1 - (visRows - 1)
        IF RowOffset1 < 0 THEN RowOffset1 = 0
        IF RowOffset1 > maxOffset THEN RowOffset1 = maxOffset
    ELSE
        IF SelIdx2 < RowOffset2 THEN RowOffset2 = SelIdx2
        IF SelIdx2 >= RowOffset2 + visRows THEN RowOffset2 = SelIdx2 - (visRows - 1)
        IF RowOffset2 < 0 THEN RowOffset2 = 0
        IF RowOffset2 > maxOffset THEN RowOffset2 = maxOffset
    END IF
END SUB

#INCLUDE "INC_SOURCE\OS.BAS"
#INCLUDE "INC_SOURCE\DRAWING.BAS"
#INCLUDE "INC_SOURCE\PROCESS_KEYS.BAS"
#INCLUDE "INC_SOURCE\STR.BAS"
#INCLUDE "INC_SOURCE\DOS.BAS"

