
    DIM hdr$
    
    width = (GETCOLS() / 2) - 4
    
    IF LEN(hdr$) = 0 THEN hdr$ = "/"

    '--- build header string, trimmed/padded to width
    hdr$ = hdr$ + RPT$(" ", width - LEN(hdr$))
    color 4, 1
    Print hdr$

end
