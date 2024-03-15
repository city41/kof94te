; originally 36e66 called these routines to set things up
; so far, just blindly calling them too
jsr $3604
jsr $15a0
jsr $25aa
jsr $5e72
; this is the bios routine for clearing all sprites
jsr $c004c8

; load the avatars onto the screen
; TODO: make sure this is done during vblank
; jsr $2LOAD_AVATARS

; now init is done, go into main char select routine
move.l #$2CHAR_SELECT_MAIN_ROUTINE, $108584
rts