;;; setup the win screen based on the custom team the winner chose
;;; nothing to restore from the clobber
;;; with cpu custom teams, this now sets up the win screen no matter who won
;;; and doesn't get involved in changing team ids at all. Changing the cpu team id
;;; is very dangerous, it almost always leads to an address exception.

movem.l A4/A5, $MOVEM_STORAGE

;; who won? p1 or p2?
cmpi.b #$80, $108238 ; player 1 is human, did they lose?
beq loadPlayer2
lea $P1_CHOSEN_CHAR0, A6 ; player 1 won, get their characters ready
bra doneLoading

loadPlayer2:
lea $P2_CHOSEN_CHAR0, A6 ; player 2 won, get their characters ready

doneLoading:

;; now with the proper team pointer set, load up the character's x/y positions
;; into a dynamic table and pass that table to the game to use. It will think it's
;; using a static table from ROM

;; this is a little flag to make sure we only put one character on the left side
move.b #0, $AFTER_SCREEN_ALREADY_SET_LEFT


lea $AFTER_SCREEN_POSITION_TABLE, A0 ; get our position table set up
;; TODO: WINNING_TEAM_LIST was originally used because PX_CHOSEN_CHARS was word based
;; it's now byte based, and so WINNING_TEAM_LIST is no longer needed, but still being used
lea $WINNING_TEAM_LIST, A4 ; get the winning list ready to be populated


;; loop all three characters in
move.w #2, D5   ; our loop counter

loadCharactersLoop:
clr.w D6
lea $2WIN_SCREEN_TABLES, A2 ; load the x/y table starting addresses
move.b (A6), D6 ; get the character id into d6

;; if Rugal won the match, force the winning ID (either regular or second form Rugal)
;; to be the entire team.
cmpi.b #$18, D0
beq forceRugal
cmpi.b #$19, D0
beq forceRugal
bra skipForceRugal
forceRugal:
move.b D0, D6
move.b D0, (A4)
move.b D0, $1(A4)
move.b D0, $2(A4)
skipForceRugal:
;; the winner of the match is in D0, a gift to us from the game
cmp.b D0, D6 ; did this character win the match?
beq setWinner
cmpi.b #1, $AFTER_SCREEN_ALREADY_SET_LEFT
beq setRight

;;; ok this will be the left character
move.b #1, $AFTER_SCREEN_ALREADY_SET_LEFT
adda.w #104, A2 ; move forward to the left table
move.b D6, $1(A4) ; stick it second in the winning list
bra finishSettingUpChar

setRight:
adda.w #208, A2 ; move forward to the right table
move.b D6, $2(A4) ; stick it third in the winning list
bra finishSettingUpChar

setWinner:
move.b D6, (A4) ; stick it first into the winning list
bra finishSettingUpChar

finishSettingUpChar:
adda.w #1, A6   ; move the pointer to the next character
add.w D6, D6    ; quadruple it as we are about to index into a table of double words 
add.w D6, D6    ; quadruple it as we are about to index into a table of double words
move.w (A2, D6.w), D7 ; jump into the table and grab the x word
move.w D7, (A0, D6.w) ; place the x word into our own dynamic table
addi.w #2, D6         ; move forward by two so we can get the y word
move.w (A2, D6.w), D7 ; jump into the table and grab the y word
move.w D7, (A0, D6.w) ; place the y word into our own dynamic table
dbra D5, loadCharactersLoop

movea.l A4, A2 ; point the game at the winning team list instead of the canned ones

movem.l $MOVEM_STORAGE, A4/A5

;;; there are three win screen init routines, each put characters in different locations
;;; depending on who won the match, D2 will be 0, 1 or 2
;;; and normally the game would use that to pick which init routine to use
; here we are just forcing the game to always choose the first routine
; and we have altered the first routine to meet custom team needs
move.w #0, D2 
rts
