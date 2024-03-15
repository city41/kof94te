start:
jsr $2LOAD_AVATARS
move.b #$f, $108235 ; p1 character one is Terry
move.b #$6, $108236 ; p1 character two is Kyo
move.b #$12, $108237 ; p1 character three is Ryo
move.b #$f, $108435 ; p2 character one is Terry
move.b #$f, $108436 ; p2 character two is Terry
move.b #$f, $108437 ; p2 character three is Terry


move.b $10fd96, d0 ; load BIOS_P1CURRENT
btst #$4, d0 ; is A pressed?
beq loop ; it's not? let's try again next frame
move.l #$37eb2, $108584 ; it is, have the engine go to order select next
bra done

loop:
; since patchRom does not support recursive symbols, this lea
; is the same as loading the start of this routine back into 108584
; TODO: not sure this is needed, as 108584 should already be this routine
move.l a6, d0 ; save a6 incase the game needs it
lea start(pc), a6
move.l a6, $108584
movea.l d0, a6 ; restore a6
done:
rts