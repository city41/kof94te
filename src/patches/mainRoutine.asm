move.b $10fd96, d0 ; load BIOS_P1CURRENT
btst #$4, d0 ; is A pressed?
beq loop ; it's not? let's try again next frame
move.l #$37edc, $108584 ; it is, set up the order select routine (hopefully...)
bra done
loop:
move.l #$2bffc8, $108584 ; set up so the game will come back in here again
done:
rts