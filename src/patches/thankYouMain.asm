cmpi.b #$THANK_YOU_PHASE_FADEIN_BG, $THANK_YOU_HACK_PHASE
beq doFadeInBg
cmpi.b #$THANK_YOU_PHASE_WAIT, $THANK_YOU_HACK_PHASE
beq doWait
cmpi.b #$THANK_YOU_PHASE_REMOVE_DELAY, $THANK_YOU_HACK_PHASE
beq doRemoveDelay
bra done

doFadeInBg:
jsr $2THANK_YOU_FADEIN_BG_ROUTINE

cmpi.w #17, $THANK_YOU_FADEIN_BG_COUNT
bne skipStartMusic
move.b #$2c, $320000 ; play the credits music
skipStartMusic:
bsr checkIfFadeInBgDone
bra done

doWait:
jsr $2THANK_YOU_WAIT_ROUTINE

;; see if the player pressed A to go to credits
cmpi.b #1, $BIOS_PLAYER_MOD1 ; is player 1 playing?
bne skipPlayer1
move.b $BIOS_P1CHANGE, D1
bra checkForExit
skipPlayer1:
move.b $BIOS_P2CHANGE, D1

checkForExit:
btst #$4, D1
beq done
;; player pressed A to exit, we need to wait a bit before removing
;; otherwise there will be a blip of the ending showing
move.b #$THANK_YOU_PHASE_REMOVE_DELAY, $THANK_YOU_HACK_PHASE
move.b #0, $CHAR_SELECT_COUNTER
;; jump to credits which will start playing behind the thank you message
;; but that is needed to get the ending off the screen
move.l #$443fc, $108584
bra done

doRemoveDelay:
addi.b #1, $CHAR_SELECT_COUNTER
cmpi.b #20, $CHAR_SELECT_COUNTER
bne done
; ok we have waited long enough, remove it and move on
jsr $2TAKE_THANK_YOU_DOWN
move.b #$THANK_YOU_PHASE_DONE, $THANK_YOU_HACK_PHASE

done:
rts

checkIfFadeInBgDone:
cmpi.w #34, $THANK_YOU_FADEIN_BG_COUNT
bne checkIfFadeInBgDone_done
;; the fade in is done, move on
move.b #$THANK_YOU_PHASE_WAIT, $THANK_YOU_HACK_PHASE

checkIfFadeInBgDone_done:
rts
