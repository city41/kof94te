;; get rid of the background/ocean
move.w #321, D6
move.w #20, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

;; get rid of the logo/countries
move.w #341, D6
move.w #15, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

;; get rid of the character grid
move.w #356, D6
move.w #18, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

move.b #0, $IN_CHAR_SELECT_FLAG

rts