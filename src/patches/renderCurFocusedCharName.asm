; renders the current focused character's name into the fix layer
;
; parameters
; A0: base pointer for p1 or p2 data

;; grab what we need out of A0, as we will clobber it after
move.w $PX_CURSOR_X_OFFSET(A0), D0
move.w $PX_CURSOR_Y_OFFSET(A0), D1
move.w $PX_FOCUSED_CHAR_NAME_FIX_ADDRESS_OFFSET(A0), $3c0000 ; load the start of fix layer area into VRAMADDR
movea.l $PX_CHAR_NAME_TABLE_ADDRESS(A0), A1 ; deref to get the table pointer into A1

mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid
lea $2GRID_TO_CHARACTER_ID, A0
adda.w D1, A0
clr.w D0
move.b (A0), D1 ; character Id from grid is now in D1

mulu.w #15, D1 ; multiply by 15 to get the offset, each name is 15 characters
adda.w D1, A1 ; jump forward to the correct name

move.w #$20, $3c0004 ; VRAMMOD=32, one column to render letters horizontally

move.w #14, D0 ; 15 chars to render, one less since dbra hinges on -1

renderChar:
clr.w D1
move.b (A1)+, D1
addi.w #$300, D1   ; jump forward in S1 rom to start of font plus character offset
ori.w #$2000, D1   ; apply palette
move.w D1, $3c0002 ; write into VRAM
dbra D0, renderChar
rts