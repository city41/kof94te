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
beq done ; it's not? let's try again next frame

move.l #$37eb2, $108584 ; it is, have the engine go to order select next
jsr $2CHAR_SELECT_TEARDOWN_ROUTINE

done:
rts