'-------------------------------------------------------------------------------  
' for the CX16
'
' 
'
' sadLogic / Steve De George SR. / Steve De George JR
' Compile with nxtBasic: https://github.com/unartic/nxtBasic   Windows - CRLF
'-----------------------------------------------------------------------------------
CONST cKEY_ESC = 27
CONST cKEY_ENTER = 13


'===========================  PROCESS - PROMPTS DIR  ============================

SUB KEYS_DIR_PROCESS()
    IF     Key$ = "A" THEN  
        PROMPT_SHOW_AVAILABLE_SPACE
    ELSEIF Key$ = "D" THEN  
        PROMPT_DELETE_DIR
    ELSEIF Key$ = "R" THEN  
        PROMPT_RENAME_DIR
    ELSEIF Key$ = "Q" THEN  
        PROMPT_QUIT
    ELSEIF Key$ = "R" THEN 
        ' RENAME DIR
    ELSEIF Key$ = "L" THEN 
        'LOG DISK
    ELSEIF Key$ = "M" THEN 
        'MAKE DIR
    END IF
    MENU_DRAW_BASE_DIR()
END SUB


SUB PROMPT_RENAME_DIR()
    MENU_DRAW_CLEAR
    PrintXY(MnuTopLine  ,0 ,"RENAME sub-directory:",TXTCOLOR)
    PrintXY(MnuTopLine+1,18,"to:",TXTCOLOR)
    PrintXY(MnuTopLine+2, 0,"Enter new name         TAB Change case  UP History  CR Ok  ESC Cancel",TXTCOLOR)
    PrintXY(MnuTopLine+2,23,"TAB",HIGHCOLOR)
    'PrintXY(MnuTopLine+1,37,"ESC",HIGHCOLOR) 
    GetSingleKey() 
END SUB

SUB PROMPT_DELETE_DIR()
    '--- ASK TO DELETE, if files, tell of ALT PRUNE command
END SUB

SUB PROMPT_SHOW_AVAILABLE_SPACE()
END SUB

SUB PROMPT_QUIT()
    '--- ASK TO QUIT
    MENU_DRAW_CLEAR
    PrintXY(MnuTopLine+1,0,"Quit The STree Program?   [No]  Yes  ESC Cancel",TXTCOLOR)
    PrintXY(MnuTopLine+1,27,"N",HIGHCOLOR)
    PrintXY(MnuTopLine+1,32,"Y",HIGHCOLOR)
    PrintXY(MnuTopLine+1,37,"ESC",HIGHCOLOR) 
    DO WHILE true
        GetSingleKey()    
        IF MenuPrompt$ = "Y" THEN
            GOTO OutOfHere
        ELSEIF MenuPrompt$ = "N" OR ASC(MenuPrompt$) = cKEY_ESC OR ASC(MenuPrompt$) = cKEY_ENTER THEN
            EXIT LOOP
        END IF
    LOOP              
END SUB




'===================================  PROCESS - PROMPTS FILE  ============================
SUB KEYS_FILE_PROCESS()
END SUB


'===================================  PROCESS - PROMPTS CTRL  ============================
SUB KEYS_CTRL_PROCESS()
END SUB


'===================================  PROCESS - PROMPTS ALT  ============================
SUB KEYS_ALT_PROCESS()
END SUB



'==============================================================================
'==============================================================================
'==============================================================================

'======================= generic methods for handling key input ==========================
SUB GetSingleKey() 
    '--- RETURNS THE PRESSED KEY IN MenuPrompt$
    DO While true
        MenuPrompt$ = Get
        IF MenuPrompt$ <> "" THEN 
            MenuPrompt$ = UCASE$(MenuPrompt$)
            EXIT LOOP
        END IF
        SLEEP 10
    LOOP
END SUB




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


