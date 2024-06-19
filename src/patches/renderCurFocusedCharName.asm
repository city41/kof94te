; renders the current focused character's name into the fix layer
;
; parameters
; A0: base pointer for p1 or p2 data

;; things both render and clear need
move.w $PX_FOCUSED_CHAR_NAME_FIX_ADDRESS_OFFSET(A0), $3c0000 ; load the start of fix layer area into VRAMADDR
move.w #$20, $3c0004 ; VRAMMOD=32, one column to render letters horizontally

move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
cmpi.b #3, D0
beq clearFocusedName ; all three chosen? then clear the name instead

;; grab what we need out of A0, as we will clobber it after
move.w $PX_CURSOR_X_OFFSET(A0), D0
move.w $PX_CURSOR_Y_OFFSET(A0), D1
movea.l $PX_CHAR_NAME_TABLE_ADDRESS_OFFSET(A0), A1 ; deref to get the table pointer into A1

mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid
lea $2GRID_TO_CHARACTER_ID, A0
adda.w D1, A0
clr.w D0
move.b (A0), D1 ; character Id from grid is now in D1

mulu.w #18, D1 ; multiply by 18 to get the offset, each name is 18 characters
adda.w D1, A1 ; jump forward to the correct name


move.w #17, D0 ; 18 chars to render, one less since dbra hinges on -1

renderChar:
clr.w D1
move.b (A1)+, D1
addi.w #$300, D1   ; jump forward in S1 rom to start of font plus character offset
ori.w #$2000, D1   ; apply palette
move.w D1, $3c0002 ; write into VRAM
dbra D0, renderChar
bra done

clearFocusedName:
move.w #17, D0 ; clear out 18 tiles, 17 since dbra hinges on -1
clearChar:
move.w #$f20, $3c0002 ; write the blank tile into vram
dbra D0, clearChar


done:
rts