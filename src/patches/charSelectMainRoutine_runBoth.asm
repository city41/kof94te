jsr $2LOAD_P_A_L_E_T_T_E_S

;;;; NOTE: using A5 needs to be done carefully, the main game
;;;; expects it when we rts
move.b #$f, $108235 ; p1 character one is Terry
move.b #$6, $108236 ; p1 character two is Kyo
move.b #$12, $108237 ; p1 character three is Ryo
move.b #$f, $108435 ; p2 character one is Terry
move.b #$f, $108436 ; p2 character two is Terry
move.b #$f, $108437 ; p2 character three is Terry


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