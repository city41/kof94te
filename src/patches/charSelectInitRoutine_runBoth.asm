; originally 36e66 called these routines to set things up
; so far, just blindly calling them too
; jsr $3604
; jsr $15a0
; jsr $25aa
; jsr $5e72
; ; this is the bios routine for clearing all sprites
; jsr $c004c8

; load the palettes
; TODO: this should be done during vblank
jsr $2LOAD_P_A_L_E_T_T_E_S

; load the character grid image onto the screen
move.w #$GRID_IMAGE_SI, D6 ; set sprite index
lea $2CHARACTER_GRID_IMAGE, A6 ; load the image pointer
jsr $2RENDER_STATIC_IMAGE

; load the p1 cursor onto the screen
move.w #$P1_CURSOR_SI, D6
lea $2P1_CURSOR_IMAGE, A6
jsr $2RENDER_STATIC_IMAGE

; move the cursor into place
move.w #$P1_CURSOR_SI, D0
move.w #8, D1
move.w #441, D2 ; y will be 55 when on screen
jsr $2MOVE_SPRITE

; initialize cursor's location
move.w #0, $P1_CURSOR_X
move.w #0, $P1_CURSOR_Y


move.b #1, $IN_CHAR_SELECT_FLAG


rts