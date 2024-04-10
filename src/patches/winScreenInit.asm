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

;; first, who won? p1 or p2? need to consider versus mode
btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq onlyPlayerTwoIsHuman
cmpi.b #$80, $108238 ; player 1 is human, did they lose?
beq playerOneLost
lea $P1_CHOSEN_CHAR0, A6 ; player 1 won, get their characters ready
bra setupChars

playerOneLost:
; this branches here too because if only p2 is playing, they beat the cpu
; if the cpu won, we would have bailed up above
onlyPlayerTwoIsHuman:
lea $P2_CHOSEN_CHAR2, A6 ; player 2 won, get their characters ready


setupChars:

movem.l A4, $MOVEM_STORAGE

;;;just always pick the team leader routine for now
;;; there are three win screen init routines, each put characters in different locations
;;; depending on who won the match, D2 will be 0, 1 or 2
;;; and normally the game would use that to pick which init routine to use
move.w #0, D2 ; here we are just forcing the game to always choose the first routine

lea $AFTER_SCREEN_POSITION_TABLE, A0 ; get our position table set up
;; this winning team list is needed due to PX_CHOSEN_CHARS being word based
;; the game wants a byte based list
lea $WINNING_TEAM_LIST, A4 ; get the winning list ready to be populated

;; first character, move to center
clr.w D6
lea $62756, A2
move.b (A6), D6
move.b D6, (A4) ; stick it into the winning list
add.w D6, D6
add.w D6, D6
move.w (A2, D6.w), D7
move.w D7, (A0, D6.w)

;; second character, to a side
clr.w D6
lea $626ee, A2
move.b $2(A6), D6
move.b D6, $1(A4) ; stick it into the winning list
add.w D6, D6
add.w D6, D6
move.w (A2, D6.w), D7
move.w D7, (A0, D6.w)

;; third character, to a side
clr.w D6
lea $627be, A2
move.b $4(A6), D6
move.b D6, $2(A4) ; stick it into the winning list
add.w D6, D6
add.w D6, D6
move.w (A2, D6.w), D7
move.w D7, (A0, D6.w)

movea.l A4, A2 ; point the game at the winning team list instead of the canned ones

movem.l $MOVEM_STORAGE, A4

done:
rts