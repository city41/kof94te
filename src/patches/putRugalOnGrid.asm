;; loads Rugal on the character select grid when it's time to fight him
;; this routine only loads his avatar. The cursor also needs to be placed on him,
;; but that is the job of moveCpuCursor

btst #0, $PLAY_MODE ; is p1 playing?
beq setupRugalForPlayerTwo
move.w #$P2C1_SI, D6 ; it is p1, so use p2's chosen team sprites
bra renderRugal

setupRugalForPlayerTwo:
move.w #$P1C1_SI, D6 ; it is p2, so use p1's chosen team sprites

renderRugal:
move.w #0, D5 ; offset into tile data
lea $2RUGAL_CG_IMG, A6 ; load the image pointer
jsr $2RENDER_STATIC_IMAGE

rts