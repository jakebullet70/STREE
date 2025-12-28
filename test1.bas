

PromptKeys()
' CursorEnable
' sleep 30
' CursorDisable   ' blows up into ML monitor here
END

SUB CursorEnable()
    LDA 20 : LDX 0 : SYS $FEAB
END SUB

SUB CursorDisable()
    LDA 20 : LDX 1 : SYS $FEAB
END SUB 

SUB PromptKeys() 
    DO While true
        CursorEnable 
        SLEEP 20
        CursorDisable

        MenuPrompt$ = Get

        IF MenuPrompt$ <> "" THEN 
            EXIT LOOP
        END IF
    LOOP
END SUB