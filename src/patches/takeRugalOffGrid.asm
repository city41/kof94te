;; removes Rugal from the grid

lea $2RUGAL_CG_CLEAR_DATA, A6
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