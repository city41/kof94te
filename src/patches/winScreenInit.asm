;;; setup the win screen based on the custom team the player chose
;;; if the cpu won, we bail out to the original win screen routines
;;; note the character id of who won the match is in D0

;;; nothing to restore from the clobber


;; did the cpu win? if so, bail and just let the original win scene routines run
btst #0, $PLAY_MODE ; is p1 playing?
beq checkPlayerTwo
btst #1, $PLAY_MODE ; is p2 playing?
bne humanWon ; versus mode, so a human won
; player 2 is the cpu, did player 1 lose?
cmpi.b #$80, $108238 ; player 1 is human, did they lose?
bne humanWon
bra cpuWon

checkPlayerTwo:
;; we already know we are not in versus mode, otherwise we would not have branched here
cmpi.b #$80, $108438 ; player 2 is human, did they lose?
bne humanWon

;; cpu won
;; leave the cpu team id alone, but set the player's team id
;; based on which player lost the match to whoever their "real"
;; team is. This will cause the CPU's win quote to be pretty good
;; and pretty topical
;;
;; TODO: this does not work when there is a timeout. The losing
;; character Id is not loaded into 100971
;;
cpuWon:
movem.l A4/D2, $MOVEM_STORAGE
clr.w D2
btst #0, $PLAY_MODE ; is p1 playing?
beq cpuWon_setP2Team
move.b $108171, D2 ; load the losing p1 char id
lea $2CHAR_ID_TO_TEAM_ID, A4
adda.w D2, A4
move.b (A4), D2 ; go from char id to team id
move.b D2, $108231 ; set P1's team to match the falling character
bra cpuWon_done

cpuWon_setP2Team:
move.b $108371, D2 ; load the losing p2 char id
lea $2CHAR_ID_TO_TEAM_ID, A4
adda.w D2, A4
move.b (A4), D2 ; go from char id to team id
move.b D2, $108431 ; set P1's team to match the falling character

cpuWon_done:
movem.l $MOVEM_STORAGE, A4/D2
jsr $3fd58
rts

humanWon:
movem.l A4/A5, $MOVEM_STORAGE
cmpi.b #3, $PLAY_MODE ; is this versus mode?
bne doneAlteringTeams ; only alter teams in versus mode

cmpi.b #$80, $108238 ; did player 1 lose?
beq alteringTeams_doP2
;; p1 won, so alter the teams based on p1's winner
lea $108231, A4
lea $108431, A5
bsr fudgeTeams
bra doneAlteringTeams

alteringTeams_doP2:
;; p2 won, so alter the teams based on p2's winner
lea $108431, A4
lea $108231, A5
bsr fudgeTeams


doneAlteringTeams:
;; second, who won? p1 or p2? need to consider versus mode
btst #0, $PLAY_MODE ; is p1 playing?
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

move.b #0, $AFTER_SCREEN_ALREADY_SET_LEFT

;;; there are three win screen init routines, each put characters in different locations
;;; depending on who won the match, D2 will be 0, 1 or 2
;;; and normally the game would use that to pick which init routine to use
; here we are just forcing the game to always choose the first routine
; and we have altered the first routine to meet custom team needs
move.w #0, D2 

lea $AFTER_SCREEN_POSITION_TABLE, A0 ; get our position table set up
;; this winning team list is needed due to PX_CHOSEN_CHARS being word based
;; the game wants a byte based list
lea $WINNING_TEAM_LIST, A4 ; get the winning list ready to be populated


;; loop all three characters in
move.w #2, D5   ; our loop counter

loadCharactersLoop:
clr.w D6
lea $2WIN_SCREEN_TABLES, A2 ; load the x/y table starting addresses
move.b (A6), D6 ; get the character id into d6
;; the winner of the match is in D0, a gift to us from the game
cmp.b D0, D6 ; did this character win the match?
beq setWinner
cmpi.b #1, $AFTER_SCREEN_ALREADY_SET_LEFT
beq setRight

;;; ok this will be the left character
move.b #1, $AFTER_SCREEN_ALREADY_SET_LEFT
adda.w #96, A2 ; move forward to the left table
move.b D6, $1(A4) ; stick it second in the winning list
bra finishSettingUpChar

setRight:
adda.w #192, A2 ; move forward to the right table
move.b D6, $2(A4) ; stick it third in the winning list
bra finishSettingUpChar

setWinner:
move.b D6, (A4) ; stick it first into the winning list
bra finishSettingUpChar

finishSettingUpChar:
adda.w #2, A6   ; move the pointer to the next character
add.w D6, D6    ; quadruple it as we are about to index into a table of double words 
add.w D6, D6    ; quadruple it as we are about to index into a table of double words
move.w (A2, D6.w), D7 ; jump into the table and grab the x word
move.w D7, (A0, D6.w) ; place the x word into our own dynamic table
addi.w #2, D6         ; move forward by two so we can get the y word
move.w (A2, D6.w), D7 ; jump into the table and grab the y word
move.w D7, (A0, D6.w) ; place the y word into our own dynamic table
dbra D5, loadCharactersLoop

movea.l A4, A2 ; point the game at the winning team list instead of the canned ones

humanWon_done:
movem.l $MOVEM_STORAGE, A4/A5
rts

;;; fudgeTeams
; a routine that will make sure
; - the team in question is not england
; - the teams are not a "mirror match"
; - it will adjust the team ids in memory as needed
; parameters
; -- A4: the first team's id address (either 108231 or 108431)
; -- A5: the opposite team's id address
fudgeTeams:
cmpi.b #$7, (A4)
bne fudgeTeams_p1doneWithEnglandCheck
move.b #$5, (A4) ; they were England, so make them Italy
fudgeTeams_p1doneWithEnglandCheck:

;; now see if the winner is on the other player's team, according to vanilla
;; so let's say the winner is Athena, is the other team China?
;; if so, change the other team to avoid mirror quotes
clr.w D2
move.b (A5), D2 ; move the other team's id in
mulu.w #3, D2 ; multiply the team id by two, team id->team leader character id 
move.w D0, D3 ; copy over winner, as we need to clobber it in a sub
sub.w D2, D3 ; D3 = <winner> - <other team leader id>
cmpi.w #0, D3 ; a diff of zero means the winner is mirrored to the other team
bra fudgeTeams_mirrorMatch
cmpi.w #1, D3 ; a diff of one means the winner is mirrored to the other team
bra fudgeTeams_mirrorMatch
cmpi.w #2, D3 ; a diff of two means the winner is mirrored to the other team
bra fudgeTeams_mirrorMatch
bra fudgeTeams_done
fudgeTeams_mirrorMatch:
addi.b #1, (A5) ; increment current team to the next one
cmpi.b #6, (A5)
ble fudgeTeams_done
move.b #0, (A5) ; either team id got out of range or became England, either case, set it to Brazil

fudgeTeams_done:
rts