;; scaleGrid
;; when character select is done, this method scales the grid down as a nice visual
;; effect before moving onto order select
;;
;; character_grid is sticky, so operations are only needed on first sprite

;; first read its current SCB3 value to get the vertical position
move.w #$8000 + $GRID_IMAGE_SI, $3c0000 ; set up the proper vram address

move.w $3c0002, D1 ; pull scb3 out
lsr.w #7, D1       ; shift D1 down to get at y position
addi.w #1, D1      ; shift y down
lsl.w #7, D1       ; shift y position back to where vram wants it

move.w #$f00, D0   ; set horizontal scale to full
add.w $GRID_SCALE_COUNTDOWN, D0 ; add in current vertical scale
add.w D0, D1       ; pack it all up into a single scb3 word

move.w D1, $3c0002 ; and send it on back



rts