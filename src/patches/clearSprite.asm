; given a sprite index and height, fills that sprite with empty tiles, starting at tile 0
; D0.w: sprite index
; D1.w: height, ie number of tiles to clear

move.w #1, $3c0004 ; VRAMMOD=1
lsl.w #6, D0 ; si * 64, since in SCB1, each sprite is 64 words
move.w D0, $3c0000 ; VRAMADDR to SCB1, sprite si

clearTile:
subi.w #1, D1  ; sub one as dbra hinges on -1
move.w #$ff, $3c0002 ; set the even word to the blank tile
move.w #0, $3c0002   ; set the odd word to palette zero, MSB tile zero
dbra D1, clearTile   ; and let's do it again...


rts


