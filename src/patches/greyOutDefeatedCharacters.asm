;; looks at the defeated teams byte and swaps in grey tiles for any teams
;; that have been defeated on the character grid

move.w #23, D0
move.l $CPU_DEFEATED_CHARACTERS, D1

greyOutCharacterIfDefeated:
btst.l D0, D1
beq skipGreyOut
lea $2CHARACTER_TO_GREY_OUT_TABLE, A0 ; get the base address of map loaded
move.w D0, D2 ; copy the character id over as we need to multiply it
mulu.w #32, D2 ; each character is 8 word pairs -> 16 words -> 32 bytes
adda.w D2, A0 ; then use that to offset into the map

;; each team needs to replace 4 tiles
;; each double word is a [VRAMADDR]|[VRAMRW] pair
;; each tile writes two longs, as SCB1 has pairs of words per tile
;; so that totals 8 longs to write
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR

skipGreyOut:
dbra D0, greyOutCharacterIfDefeated

rts