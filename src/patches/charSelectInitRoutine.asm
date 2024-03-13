; originally 36e66 called these routines to set things up
; so far, just blindly calling them too
jsr $3604
jsr $15a0
jsr $25aa
jsr $5e72
; this is the bios routine for clearing all sprites
jsr $c004c8

; we don't want to call the below two, as loading the flags
; is required to get the background to show up. instead we need
; to understand these routines and recreate them as needed
; load the background
; jsr $371c4
; load the flags
; jsr $36ec0

; now init is done, go into main char select routine
move.l #$2CHAR_SELECT_MAIN_ROUTINE, $108584
rts