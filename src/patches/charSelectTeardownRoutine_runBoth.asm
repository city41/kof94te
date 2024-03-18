; ;; get rid of the background/ocean
; move.w #$OCEANS_IMAGE_SI, D6 ; set sprite index
; move.w #20, D7
; jsr $2TRUNCATE_SPRITES_ROUTINE

; ;; get rid of the logo/countries
; move.w #$LOGO_IMAGE_SI, D6 ; set sprite index to
; move.w #15, D7
; jsr $2TRUNCATE_SPRITES_ROUTINE

; ;; get rid of the character grid
; move.w #$GRID_IMAGE_SI, D6 ; set sprite index
; move.w #18, D7
; jsr $2TRUNCATE_SPRITES_ROUTINE

; only one strip of the grid doesn't get cleared out by 
; the game's sprite system, so clean it up
move.w #$GRID_IMAGE_SI, D6
addi.w #17, D6
move.w #1, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

move.b #0, $IN_CHAR_SELECT_FLAG

rts