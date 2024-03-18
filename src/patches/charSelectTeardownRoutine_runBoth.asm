;; get rid of the background/ocean
move.w #$OCEANS_IMAGE_SI, D6 ; set sprite index
move.w #20, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

;; get rid of the logo/countries
move.w #$LOGO_IMAGE_SI, D6 ; set sprite index to
move.w #15, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

;; get rid of the character grid
move.w #$GRID_IMAGE_SI, D6 ; set sprite index
move.w #18, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

move.b #$6, $108235 ; p1 character one is Kyo
move.w #$6, $102970 ; p1 character one is Kyo in membdisp
move.b #0, $IN_CHAR_SELECT_FLAG

rts