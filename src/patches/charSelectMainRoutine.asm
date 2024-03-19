start:
move.b #$f, $108235 ; p1 character one is Terry
move.b #$6, $108236 ; p1 character two is Kyo
move.b #$12, $108237 ; p1 character three is Ryo
move.b #$f, $108435 ; p2 character one is Terry
move.b #$f, $108436 ; p2 character two is Terry
move.b #$f, $108437 ; p2 character three is Terry

;; load up membdisp

move.w #$f, $102970


move.b $10fd97, D0 ; load BIOS_P1CHANGE
btst #$4, D0 ; is A pressed?
bne goToOrderSelect ; it is? off to order select

btst #$3, D0 ; is Right pressed?
bne incCursorX ; it is? move cursor right one

btst #$2, D0 ; is Left pressed?
bne decCursorX ; it is? move cursor left one

btst #$1, D0 ; is Down pressed?
bne incCursorY ; it is? move cursor down one

btst #$0, D0 ; is Up pressed?
bne decCursorY ; it is? move cursor up one

bra done ; A nor any directions were pressed

move.b $P1_CURSOR_X, D1 ; load current cursor X
move.b $P1_CURSOR_Y, D2 ; and Y

incCursorX:
addi.w #1, D1
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
move.b D1, $P1_CURSOR_X ; save the new X
move.b D2, $P1_CURSOR_Y ; save the new Y
mulu.w #16, D1 ; convert X index to X pixel
addi.w #8, D1  ; add the X offset (8px from edge of screen)
mulu.w #16, D2 ; convert Y index to Y pixel
addi.w #55, D2 ; add the Y offset (55px from top of screen)
move.w 496, D3
sub.w D2, D3   ; D3 = D3 - D2, convert Y to the bizarre format the system wants
move.w D3, D2  ; move it back into D2, where moveSprite expects it
move.w #$P1_CURSOR_SI, D0 ; load the sprite index
jsr $2MOVE_SPRITE ; and finally, move the sprite
bra done

goToOrderSelect:
move.l #$37eb2, $108584 ; it is, have the engine go to order select next
jsr $2CHAR_SELECT_TEARDOWN_ROUTINE

done:
rts