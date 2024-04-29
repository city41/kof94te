move.w #$20, $3c0004 ; VRAMMOD=32, skip an entire column of fix after each write

;; player one side
move.w #$P1_FOCUSED_NAME_FIX_ADDRESS_VALUE, $3c0000  ; starting fix address TO VRAMADDR
move.w #14, D4 ; clear out 15 tiles, one less due to dbra hinging on -1

p1_clearFixTile:
move.w #$f20, $3C0002 ; set to tile the blank tile
dbra D4, p1_clearFixTile

;; player two side
move.w #$P2_FOCUSED_NAME_FIX_ADDRESS_VALUE, $3c0000  ; starting fix address TO VRAMADDR
move.w #17, D4 ; clear out 18 tiles, one less due to dbra hinging on -1

p2_clearFixTile:
move.w #$f20, $3C0002 ; set to tile the blank tile
dbra D4, p2_clearFixTile

rts

