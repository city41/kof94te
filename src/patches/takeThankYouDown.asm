
move.w #25, D5     ; clear out 26 rows using dbra
clearRow:
move.w #$7004, D3    ; the first row's starting address
add.w D5, D3        ; add on to get to the current row's starting address
move.w D3, $3c0000  ; set VRAMADDR
move.w #32, $3c0004 ; set VRAMMOD
move.w #38, D4     ; going to clear 39 chars per row

clearTile:
move.w #$f20, $3c0002
dbra D4, clearTile
dbra D5, clearRow

rts