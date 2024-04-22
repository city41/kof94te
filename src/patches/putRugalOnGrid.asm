;; loads Rugal on the character select grid when it's time to fight him
;; this routine only loads his avatar. The cursor also needs to be placed on him,
;; but that is the job of moveCpuCursor

move.w #0, D5 ; offset into tile data
lea $2RUGAL_CG_IMG, A6 ; load the image pointer
move.w #$RUGAL_SI, D6  ; sprite index
jsr $2RENDER_STATIC_IMAGE

rts