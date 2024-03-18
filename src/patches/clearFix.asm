move.w #$7027, $3c0000  ; starting fix address TO VRAMADDR
move.w #$20, $3c0004 ; VRAMMOD=32, skip an entire column of fix after each write

move.w #60, D4 ; clear out 24 tiles, one less due to dbra hinging on -1

clearFixTile:
move.w #$f20, $3C0002 ; set to tile ff, the blank tile
dbra D4, clearFixTile

rts

