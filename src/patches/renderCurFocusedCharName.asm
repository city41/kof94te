move.w $P1_CURSOR_X, D0
move.w $P1_CURSOR_Y, D1
mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid
lea $2GRID_TO_CHARACTER_ID, A0
adda.w D1, A0
clr.w D0
move.b (A0), D1 ; character Id from grid is now in D1

lea $2CHAR_NAMES_TABLE, A0
mulu.w #8, D1 ; multiply by 8 to get the offset, each name is 8 characters
adda.w D1, A0 ; jump forward to the correct name

move.w #$20, $3c0004 ; VRAMMOD=32, one column to render letters horizontally
move.w #$7056, $3c0000 ; load the start of fix layer area into VRAMADDR

move.w #7, D0

renderChar:
clr.w D1
move.b (A0)+, D1
addi.w #$300, D1   ; jump forward in S1 rom to start of font plus character offset
ori.w #$1000, D1   ; apply palette
move.w D1, $3c0002 ; write into VRAM
dbra D0, renderChar
rts