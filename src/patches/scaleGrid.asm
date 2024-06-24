;; scaleGrid
;; when character select is done, this method scales the grid down as a nice visual
;; effect before moving onto order select
;;
;; character_grid is sticky, so operations are only needed on first sprite

;;;; MOVE Y POSITION DOWN
;; first read its current SCB3 value to get the vertical position
move.w #$8200 + $GRID_IMAGE_SI, $3c0000 ; set up the proper vram address

move.w $3c0002, D1 ; pull scb3 out
move.w D1, D2      ; make a copy since we'll be manipulating it
lsr.w #7, D2       ; shift D1 down to get at y position
subi.w #6, D2      ; shift y down
lsl.w #7, D2       ; shift y position back to where vram wants it
;; now form the new scb3 word 
andi.w #$7f, D1    ; wipe out y position
or.w D2, D1        ; apply new y position
move.w D1, $3c0002


;;;; SCALE VERTICALLY DOWN
move.w #$8000 + $GRID_IMAGE_SI, $3c0000
move.w #$f00, D0
add.w $GRID_SCALE_COUNTDOWN, D0
move.w D0, $3c0002

rts