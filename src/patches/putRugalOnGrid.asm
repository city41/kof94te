;; loads Rugal on the character select grid when it's time to fight him
;; this routine only loads his avatar. The cursor also needs to be placed on him,
;; but that is the job of moveCpuCursor

lea $2RUGAL_CG_INJECT_DATA, A6
;; rugal is made up of four tiles, each tile is 4 words, 2 longs
;; so 8 longs in total
move.l (A6)+, $VRAMADDR
move.l (A6)+, $VRAMADDR
move.l (A6)+, $VRAMADDR
move.l (A6)+, $VRAMADDR
move.l (A6)+, $VRAMADDR
move.l (A6)+, $VRAMADDR
move.l (A6)+, $VRAMADDR
move.l (A6)+, $VRAMADDR


rts