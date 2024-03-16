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
; load the background/oceans image onto the screen
; TODO: make sure this is done during vblank
move.w #326, D6 ; set sprite index to 321
lea $2BG_OCEANS_IMAGE, A6 ; load the image pointer
jsr $2RENDER_STATIC_IMAGE

; load the logo/countries image onto the screen
move.w #346, D6 ; set sprite index to 21
lea $2LOGO_COUNTRIES_IMAGE, A6 ; load the image pointer
jsr $2RENDER_STATIC_IMAGE

; load the character grid image onto the screen
move.w #361, D6 ; set sprite index to 21
lea $2CHARACTER_GRID_IMAGE, A6 ; load the image pointer
jsr $2RENDER_STATIC_IMAGE

; now init is done, go into main char select routine
; if the timer has elapsed
; move.l #$2CHAR_SELECT_MAIN_ROUTINE, $108584

rts