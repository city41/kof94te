;;; setup the win screen based on the custom team the player chose
;;; if the cpu won, we bail out to the original win screen routines

;;; nothing to restore from the clobber

;; did the cpu win? if so, bail and just let the original win scene routines run
btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq checkPlayerTwo
btst #1, $NUM_PLAYER_MODE ; is p2 playing?
bne humanWon ; versus mode, so a human won
; player 2 is the cpu, did player 1 lose?
cmpi.b #$80, $108238 ; player 1 is human, did they lose?
bne humanWon
bra cpuWon

checkPlayerTwo:
;; we already know we are not in versus mode, otherwise we would not have branched here
cmpi.b #$80, $108438 ; player 2 is human, did they lose?
bne humanWon

;; cpu won, so just run the original routines
cpuWon:
jsr $3fd58
bra done

humanWon:
;;;just always pick the team leader routine for now
;;; there are three win screen init routines, each put characters in different locations
;;; depending on who won the match, D2 will be 0, 1 or 2
;;; and normally the game would use that to pick which init routine to use
move.w #0, D2 ; here we are just forcing the game to always choose the first routine

lea $AFTER_SCREEN_POSITION_TABLE, A0 ; get our position table set up

;; first character, move to center
clr.w D6
lea $62756, A2
move.b $P1_CHOSEN_CHAR0, D6
add.w D6, D6
add.w D6, D6
move.w (A2, D6.w), D7
move.w D7, (A0, D6.w)

;; second character, to a side
clr.w D6
lea $626ee, A2
move.b $P1_CHOSEN_CHAR1, D6
add.w D6, D6
add.w D6, D6
move.w (A2, D6.w), D7
move.w D7, (A0, D6.w)

;; third character, to a side
clr.w D6
lea $627be, A2
move.b $P1_CHOSEN_CHAR2, D6
add.w D6, D6
add.w D6, D6
move.w (A2, D6.w), D7
move.w D7, (A0, D6.w)

lea $P1_CHOSEN_CHAR0, A2 ; point the game at our custom team list instead of the canned ones

done:
rts