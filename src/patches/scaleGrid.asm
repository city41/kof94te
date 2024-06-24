move.w #$8000 + $GRID_IMAGE_SI, D2
add.w D1, D2
move.w D2, $3c0000
move.w #$f00, D0
add.w $GRID_SCALE_COUNTDOWN, D0
move.w D0, $3c0002

rts