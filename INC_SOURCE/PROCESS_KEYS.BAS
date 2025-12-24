'-------------------------------------------------------------------------------  
' for the CX16
'
' 
'
' sadLogic / Steve De George SR. / Steve De George JR
' Compile with nxtBasic: https://github.com/unartic/nxtBasic   Windows - CRLF
'-----------------------------------------------------------------------------------


SUB KEYS_ALT_PROCESS()
END SUB

SUB KEYS_CTRL_PROCESS()
END SUB


SUB KEYS_DIR_PROCESS()
    IF KeyPressed$ = "A" THEN
        '--- show available space
    ELSEIF KeyPressed$ = "D" THEN
        '--- delete directory
    ELSEIF KeyPressed$ = "R" THEN
        '--- rename directory
    ELSEIF KeyPressed$ = "Q" THEN
        PROMPT_QUIT
    END IF
    MENU_DRAW_BASE_DIR()
END SUB


SUB KEYS_FILE_PROCESS()
END SUB


'=================  PROMPTS  =======================
SUB PROMPT_RENAME_DIR()
END SUB
SUB PROMPT_DELETE_DIR()
END SUB
SUB PROMPT_AVAILABLE_SPACE()
END SUB

SUB PROMPT_QUIT()
    '--- ASK TO QUIT
    MENU_DRAW_CLEAR
    PrintXY(MnuTopLine+1,0,"Quit The STree Program?   [No]  Yes  ESC Cancel",cCOLOR_WHITE)
    PrintXY(MnuTopLine+1,27,"N",LINECOLOR)
    PrintXY(MnuTopLine+1,32,"Y",LINECOLOR)
    PrintXY(MnuTopLine+1,37,"ESC",LINECOLOR) 
    DO WHILE true
        GetSingleKey()    
        IF MenuPrompt$ <> "" THEN
            IF MenuPrompt$ = "Y" THEN
                GOTO OutOfHere
            ELSEIF MenuPrompt$ = "N" OR ASC(MenuPrompt$) = 27 OR ASC(MenuPrompt$) = 13 THEN
                EXIT LOOP
            END IF
        END IF
    LOOP              
END SUB


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


