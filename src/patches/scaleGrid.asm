;; scaleGrid
;; when character select is done, this method scales the grid down as a nice visual
;; effect before moving onto order select
;;
;; character_grid is sticky, so operations are only needed on first sprite
;;
;; This routine sets the sprite height to 6. This is done to help avoid garbage tiles from showing during the scale.

;;;; MOVE Y POSITION DOWN
;; first read its current SCB3 value to get the vertical position
move.w #$8200 + $GRID_IMAGE_SI, $3c0000 ; set up the proper vram address

move.w $SCALE_GRID_Y_POSITION, D1 ; grab current y
subi.w #6, D1      ; shift y down, 6 pixels
move.w D1, $SCALE_GRID_Y_POSITION ; store the new position for next time
lsl.w #7, D1       ; shift y position up into place for scb3 word
addi.w #6, D1 ; add on the height to form the full word
move.w D1, $3c0002


;;;; SCALE VERTICALLY DOWN
move.w #$8000 + $GRID_IMAGE_SI, $3c0000
move.w #$f00, D0
add.w $GRID_SCALE_COUNTDOWN, D0
move.w D0, $3c0002

rts