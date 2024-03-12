move.b $10fd96, d0 ; load BIOS_P1CURRENT
btst #$4, d0 ; is A pressed?
beq loop ; it's not? let's try again next frame
move.l #$37eb2, $108584 ; it is, have the engine go to order select next
move.b #$f, $108235 ; p1 character one is Terry
move.b #$6, $108236 ; p1 character two is Kyo
move.b #$12, $108237 ; p1 character three is Ryo
move.b #$f, $108435 ; p2 character one is Terry
move.b #$f, $108436 ; p2 character two is Andy
move.b #$f, $108437 ; p2 character three is King
bra done
loop:
move.l #$2bff98, $108584 ; set up so the game will come back in here again
done:
rts