;;;; NOTE: using A5 needs to be done carefully, the main game
;;;; expects it when we rts
move.b #$f, $108235 ; p1 character one is Terry
move.b #$6, $108236 ; p1 character two is Kyo
move.b #$12, $108237 ; p1 character three is Ryo
move.b #$f, $108435 ; p2 character one is Terry
move.b #$f, $108436 ; p2 character two is Terry
move.b #$f, $108437 ; p2 character three is Terry

;;; increment the counter
move.b $CHAR_SELECT_COUNTER, D5
addi.b #1, D5
move.b D5, $CHAR_SELECT_COUNTER

;;;;;;;;;;;;;;;; CURSOR ;;;;;;;;;;;;;;;;;;;;
move.l A0, D1
move.l D1, $STORE_A0      ; store A0 as the game needs it
move.l A1, D1
move.l D1, $STORE_A1      ; store A1 as the game needs it

;;;; load the common values for MOVE_CURSOR that work for both
;;;; the black and white cursor
move.b $10fd96, D0        ; load BIOS_P1CURRENT
move.b #$a, D0            ; simulate right and down being pressed
lea $P1_CURSOR_X, A0      ; pointer to cursor X
lea $P1_CURSOR_Y, A1      ; pointer to cursor Y

;;;; now show the white or black cursor, depending on if the counter
;;;; is odd or not
btst #0, D5
beq blackCursor
move.w #$P1_CURSOR_WHITE_BORDER_SI, D1 ; load the cursor's sprite index
bra moveCursor
blackCursor:
move.w #$P1_CURSOR_BLACK_BORDER_SI, D1 ; load the cursor's sprite index
moveCursor:
jsr $2MOVE_CURSOR

;;;; now hide the one that should not be on screen
move.w #0, D1 ; X
move.w #272, D2 ; Y, which will be 224px, putting it off screen
btst #0, D5
beq hideWhiteCursor
move.w #$P1_CURSOR_BLACK_BORDER_SI, D0 ; load the cursor's sprite index
bra hideCursor
hideWhiteCursor:
move.w #$P1_CURSOR_WHITE_BORDER_SI, D0 ; load the cursor's sprite index
hideCursor:
jsr $2MOVE_SPRITE



;; restore the saved address registers
move.l $STORE_A0, D1
movea.l D1, A0
move.l $STORE_A1, D1
movea.l D1, A1

move.b $10fdac, D0 ; load BIOS_STATCURNT
btst #$0, D0 ; is p1 start pressed?
beq keepTimerGoing ; it's not? let's try again next frame

; move.l #$37eb2, $108584 ; it is, have the engine go to order select next
; it is, set the countdown to zero so the game will move onto order select on its own
move.w #0, $108654
bra done

keepTimerGoing:
; set the timer back to 1400 so we stay on team select indefinitely
move.w #$1400, $108654

done:
rts