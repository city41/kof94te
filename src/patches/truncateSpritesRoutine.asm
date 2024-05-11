; given a range of sprites, sets all their heights to zero
; D6.w: starting sprite index (si)
; D7.w: how many sprites to truncate (sc)

move.w #1, $3c0004 ; VRAMMOD=1

move.w #$8200, D0  ; SCB3 base address
add.w D6, D0    ; move forward by si words
move.w D0, $3c0000 ; VRAMADDR to SCB3, set to si'th sprite

subi.w #1, D7 ; since drba hinges on -1 not zero
truncateSprite:
move.w #0, $3c0002 ; y position | sticky | size to zero
dbra D7, truncateSprite

rts