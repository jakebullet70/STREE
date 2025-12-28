'-------------------------------------------------------------------------------  
' for the CX16
'
' 
'
' sadLogic / Steve De George SR. / Steve De George JR
' Compile with nxtBasic: https://github.com/unartic/nxtBasic   Windows - CRLF
'-----------------------------------------------------------------------------------


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
    t$="FileName.txt"
    EditText(MnuTopLine+1,18-len(t$),32,t$)
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
    DO WHILE True
        '--- MenuPrompt$ holds the key
        GetSingleKey(cEDITOR_UCASE_YES, cEDITOR_BLINK_CURSOR_NO)
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


