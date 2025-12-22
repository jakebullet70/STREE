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
CLS
LINECOLOR = cCOLOR_CYAN

DrawBaseScreen
Wait4Key:
    key$ = Get
if key$ = "" then GOTO Wait4Key

EXITISO : END


'--------------------------- Subs -----------------------------

SUB DrawBaseScreen()

   ' LINE_HORIZONTAL(0,0,40,LINECOLOR)
    LINE_VERTICAL(2,2,10,LINECOLOR)
    

    'PrintXY(1, 1, TOPLEFT, LINECOLOR) 
    'PrintXY(1, 2, TOPLEFT, LINECOLOR) 
    'PrintXY(1, 3, TOPLEFT, LINECOLOR) 

    ' box(0, 1, 57, 21, LINECOLOR)
    ' box(56, 1, 24, 29, LINECOLOR)
    ' box(0, 21, 57, 9, LINECOLOR)
    
    'box(1, 2, 58, 22, LINECOLOR)
    
    'box(57, 2, 25, 30, LINECOLOR)
    'box(1, 22, 58, 10, LINECOLOR)
END SUB

' main {
'     sub start() {
        
'         cx16.set_screen_mode(1)
'         palette.set_c64pepto()
'         txt.lowercase() ;cx16.screen_set_charset(3, 0)
'         txt.cls()
'         txt.color2(drawing.BLUE, drawing.CYAN)
'         txt.print("  XTREE  File  Directory  Volume  Tag  Window            12/11/2025  8:34:33 PM ")

'         const ubyte LINECOLOR = (drawing.BLUE << 4) | drawing.CYAN
'         drawing.box(0, 1, 57, 21, LINECOLOR)
'         drawing.box(56, 1, 24, 29, LINECOLOR)
'         drawing.box(0, 21, 57, 9, LINECOLOR)
'         drawing.line_horizontal(57, 3, 22, LINECOLOR)
'         drawing.line_horizontal(57, 7, 22, LINECOLOR)

'         txt.waitkey()
'         ;ubyte color = (bg << 4) | fg
'         ;txt.setcc2(0, 0, 65, color)
'     }
' }

' drawing{

'     const ubyte BLACK = 0
'     const ubyte WHITE = 1
'     const ubyte RED = 2
'     const ubyte CYAN = 3
'     const ubyte PURPLE = 4
'     const ubyte GREEN = 5
'     const ubyte BLUE = 6
'     const ubyte YELLOW = 7
'     const ubyte ORANGE = 8
'     const ubyte BROWN = 9
'     const ubyte LIGHTRED = 10
'     const ubyte DARKGREY = 11
'     const ubyte GREY = 12
'     const ubyte LIGHTGREEN = 13
'     const ubyte LIGHTBLUE = 14
'     const ubyte LIGHTGREY = 15

'     sub line_horizontal(ubyte x, ubyte y, ubyte length, ubyte color) {
'         const ubyte HORIZONTAL = 64  ; Horizontal
'         ubyte i
'         for i in 0 to length-1 {
'             txt.setcc2(x+i, y, HORIZONTAL, color)
'         }
'     }

'     sub box(ubyte x, ubyte y, ubyte w, ubyte h, ubyte color) {
'         ; Corners and sides (PETSCII codes)
'         const ubyte TOPLEFT = 112  ; Top-Left
'         const ubyte TOPRIGHT = 110  ; Top-Right
'         const ubyte BOTTOMLEFT = 109  ; Bottom-Left
'         const ubyte BOTTOMRIGHT = 125  ; Bottom-Right
'         const ubyte HORIZONTAL  = 64   ; Horizontal
'         const ubyte VERTICAL  = 93   ; Vertical

'         ubyte i, j
        
'         ; draw corners
'         txt.setcc2(x, y, TOPLEFT, color)
'         txt.setcc2(x+w-1, y, TOPRIGHT, color)
'         txt.setcc2(x, y+h-1, BOTTOMLEFT, color)
'         txt.setcc2(x+w-1, y+h-1, BOTTOMRIGHT, color)

'         ; draw horizontals
'         for i in 1 to w-2 {
'             txt.setcc2(x+i, y, HORIZONTAL, color)
'             txt.setcc2(x+i, y+h-1, HORIZONTAL, color)
'         }

'         ; Draw verticals
'         for j in 1 to h-2 {
'             txt.setcc2(x, y+j, VERTICAL, color)
'             txt.setcc2(x+w-1, y+j, VERTICAL, color)
'         }
'     }
' }


SUB ReadDIR()
END SUB

SUB ReadFiles()
END SUB



#INCLUDE "INC_SOURCE\STR.BAS"
#INCLUDE "INC_SOURCE\DRAWING.BAS"