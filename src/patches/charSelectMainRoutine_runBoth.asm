;;;; NOTE: using A5 needs to be done carefully, the main game
;;;; expects it when we rts
move.b #$f, $108235 ; p1 character one is Terry
move.b #$6, $108236 ; p1 character two is Kyo
move.b #$12, $108237 ; p1 character three is Ryo
move.b #$f, $108435 ; p2 character one is Terry
move.b #$f, $108436 ; p2 character two is Terry
move.b #$f, $108437 ; p2 character three is Terry

;;;;;;;;;;;;;;;; P1 CURSOR LOGIC ;;;;;;;;;;;;;;;;;;;;
move.w $P1_CURSOR_X, D1 ; load current cursor X
move.w $P1_CURSOR_Y, D2 ; and Y

move.b $10fd96, D0 ; load BIOS_P1CURRENT
move.b #$8, D0     ; simulate right being pressed

btst #$3, D0 ; is Right pressed?
bne incCursorX ; it is? move cursor right one

btst #$2, D0 ; is Left pressed?
bne decCursorX ; it is? move cursor left one

btst #$1, D0 ; is Down pressed?
bne incCursorY ; it is? move cursor down one

btst #$0, D0 ; is Up pressed?
bne decCursorY ; it is? move cursor up one

bra doneWithCursor ; no direction is pushed

incCursorX:
addi.w #1, D1
cmpi.w #8, D1
ble.s skipUpperWrap
move.w #0, D1 ; x rolled over to zero
skipUpperWrap:
bra moveCursor

decCursorX:
subi.w #1, D1
bra moveCursor

incCursorY:
addi.w #1, D2
bra moveCursor

decCursorY:
subi.w #1, D2
;; fall through to moveCursor

moveCursor:
move.w D1, $P1_CURSOR_X ; save the new X
move.w D2, $P1_CURSOR_Y ; save the new Y
mulu.w #32, D1 ; convert X index to X pixel
addi.w #8, D1  ; add the X offset (8px from edge of screen)
mulu.w #32, D2 ; convert Y index to Y pixel
addi.w #55, D2 ; add the Y offset (55px from top of screen)
move.w #496, D3
sub.w D2, D3   ; D3 = D3 - D2, convert Y to the bizarre format the system wants
move.w D3, D2  ; move it back into D2, where moveSprite expects it
move.w #$P1_CURSOR_SI, D0 ; load the sprite index
jsr $2MOVE_SPRITE ; and finally, move the sprite

doneWithCursor:

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