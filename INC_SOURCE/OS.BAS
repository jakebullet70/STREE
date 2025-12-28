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
CONST cKEY_ESC = 27
CONST cKEY_ENTER = 13
CONST cKEY_BACKSPACE = 20

CONST cEDITOR_BLINK_CURSOR_YES = 1
CONST cEDITOR_BLINK_CURSOR_NO = 0
CONST cEDITOR_UCASE_YES = 1
CONST cEDITOR_UCASE_NO = 0


SUB DEBUG_STRING(dmsg$)
    DIM drow : DIM dcol
    drow = CURROW()
    dcol = CURCOL()
    LOCATE 0,0
    PRINT RPT$(" ",GETCOLS());
    LOCATE 0,0
    PRINT dmsg$;
    LOCATE drow,dcol
END SUB 




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
    'LDA tmp0$ : SYS CHROUT
END SUB




'--- get a single keypress, with options for upper case and blinking cursor - GENERIC
SUB EditText(row9, col9, max_length9, InputText$)
    '-- EDIT TEXT AT row,col for max_length9 chars
    DIM CurLocation : CurLocation = LEN(InputText$) 
    PrintXY(row9, col9, InputText$ + RPT$(" ", max_length9 - LEN(InputText$)), TXTCOLOR)
    LOCATE row9, col9 + CurLocation

    DO WHILE True
        '--- MenuPrompt$ holds the key
        GetSingleKey(cEDITOR_UCASE_NO, cEDITOR_BLINK_CURSOR_YES) 
        IF ASC(MenuPrompt$) = cKEY_ENTER THEN
            EXIT LOOP
        ELSEIF ASC(MenuPrompt$) = cKEY_ESC THEN
            InputText$ = ""
            EXIT LOOP
        ELSEIF ASC(MenuPrompt$) = cKEY_BACKSPACE THEN 
            IF CurLocation > 0 THEN
                InputText$ = LEFT$(InputText$, CurLocation - 1) + MID$(InputText$, CurLocation + 1, LEN(InputText$) - CurLocation)
                CurLocation = CurLocation - 1
            END IF
        ELSEIF MenuPrompt$ = CHR$(157) THEN '--- LEFT ARROW
            IF CurLocation > 0 THEN CurLocation = CurLocation - 1
        ELSEIF MenuPrompt$ = CHR$(29) THEN '--- RIGHT ARROW
            IF CurLocation < LEN(InputText$) THEN CurLocation = CurLocation + 1
        ELSEIF CurLocation < LEN(InputText$) THEN
            '--- OVERWRITE mode (cursor in middle of string)
            IF ASC(MenuPrompt$) >= 32 THEN '--- Only accept printable characters
                InputText$ = LEFT$(InputText$, CurLocation) + MenuPrompt$ + MID$(InputText$, CurLocation + 2, LEN(InputText$) - CurLocation - 1)
                CurLocation = CurLocation + 1
            END IF
        ELSEIF LEN(InputText$) < max_length9 THEN
            '--- APPEND mode (cursor at end of string)
            IF ASC(MenuPrompt$) >= 32 THEN '--- Only accept printable characters
                InputText$ = InputText$ + MenuPrompt$
                CurLocation = CurLocation + 1
            END IF
        END IF
        'DEBUG_STRING("CURLOCATION:" + STR$(CurLocation))
        SETCOL col9 
        PRINT InputText$ + RPT$(" ", max_length9 - LEN(InputText$));
        SETCOL col9 + CurLocation
    LOOP
END SUB

'======================= generic methods for handling key input ==========================
SUB GetSingleKey(ForceUCASE,BlinkCursor) 
    '--- RETURNS THE PRESSED KEY IN MenuPrompt$
    MenuPrompt$ = ""
    DO WHILE True
        IF BlinkCursor = cEDITOR_BLINK_CURSOR_YES THEN
            CursorEnable()
            SLEEP 20
            CursorDisable()
        ELSE
            SLEEP 20
        END IF
        MenuPrompt$ = Get
        IF MenuPrompt$ <> "" THEN 
            IF ForceUCASE = cEDITOR_UCASE_YES THEN  
                MenuPrompt$ = UCASE$(MenuPrompt$)
            END IF
            'DEBUG_STRING("KEY:" + STR$(ASC(MenuPrompt$)))
            EXIT LOOP
        END IF
    LOOP
END SUB


'==============================================================================
'==============================================================================
'==============================================================================

' Keyboard scancode diagram for Commander X16
'
'
'
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




