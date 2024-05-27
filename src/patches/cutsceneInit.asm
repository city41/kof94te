; first, did the player choose an original 8 team?
; if so, make sure that is the team id that is set then bail
; let the original cutscenes run

btst #0, $PLAY_MODE
beq checkOriginal8Player2
cmpi.b #$ff, $P1_ORIGINAL_TEAM_ID
beq notAnOriginalTeam
move.b $P1_ORIGINAL_TEAM_ID, $108231
bra originalTeamDone

checkOriginal8Player2:
cmpi.b #$ff, $P2_ORIGINAL_TEAM_ID
beq notAnOriginalTeam
move.b $P2_ORIGINAL_TEAM_ID, $108431

originalTeamDone:
;; HACK alert: this whole routine is a mess of three cutscenes and shoudl be cleaned up
;; instead for now, just jumping to cutscene 2 if appropriate
jsr $350f8 ; the built in "count defeated teams" subroutine

cmpi.w #8, D0 ; 8 defeated teams?
beq secondCutscene ; yes? then on to cutscene 2 
rts ; no? then bail

notAnOriginalTeam:

move.l A1, D7
;; A1 is only this at the start of cutscene 3,
;; it should be a reliable hook
cmpi.l #$10b9e3, D7
bne skipCutscene3
btst #0, $PLAY_MODE
beq cutscene3_skipPlayer1
lea $P1_CHOSEN_CHAR0, A0
bra doChooseEndingTeam

cutscene3_skipPlayer1:
lea $P2_CHOSEN_CHAR2, A0

doChooseEndingTeam:
bsr chooseEndingTeam ; the ending team is left in D0
;; only the playing player needs this done
;; but just do both for simplicity
move.b D0, $108231
move.b D0, $108431
rts

skipCutscene3:

;; first, which cutscene is this? let's count the number of defeated teams to determine that
jsr $350f8 ; the built in "count defeated teams" subroutine

cmpi.w #4, D0 ; 4 defeated teams?
bne secondCutscene ; no? must be second cutscene then

;; this is the first cutscene. The only thing we need to do is ensure
;; the player is set to team Brazil for its team id, so Rugal says generic stuff
btst #0, $PLAY_MODE
beq firstCutscene_setPlayer2
;; this is player one, set them to team Brazil
move.b #0, $108231
bra firstCutscene_done

firstCutscene_setPlayer2:
;; this is player two, set them to team Brazil
move.b #0, $108431

firstCutscene_done:
rts


secondCutscene:
;;;;;;;; Have the game use the chosen team ids instead of ones from a pre-formed team

;; need to use winning team list as game wants bytes, not words
lea $WINNING_TEAM_LIST, A0
btst #0, $PLAY_MODE
beq setupPlayer2
move.b $P1_CHOSEN_CHAR0, (A0)
move.b $P1_CHOSEN_CHAR1, $1(A0)
move.b $P1_CHOSEN_CHAR2, $2(A0)
cmpi.b #$ff, $P1_ORIGINAL_TEAM_ID
bne done ; this is an original team, don't clobber it
move.b #6, $108231 ; this is not an origianl team, so set the team to Mexico
bra done
setupPlayer2:
move.b $P2_CHOSEN_CHAR2, (A0)
move.b $P2_CHOSEN_CHAR1, $1(A0)
move.b $P2_CHOSEN_CHAR0, $2(A0)
cmpi.b #$ff, $P2_ORIGINAL_TEAM_ID
bne done ; this is an original team, don't clobber it
move.b #6, $108431 ; this is not an origianl team, so set the team to Mexico
done:

;; need to create the dynamic XY table based on the characters that will be displayed
lea $AFTER_SCREEN_POSITION_TABLE, A1 ; get our position table set up

;; team member 1, on the right side
clr.w D6
move.b (A0), D6 ; load the first team member id
add.w D6, D6    ; quadruple it for offsetting into the table
add.w D6, D6    ; quadruple it for offsetting into the table
lea $2CUTSCENE2_TABLES, A2
move.w (A2, D6.w), D7 ; jump into the table and grab the x word
move.w D7, (A1, D6.w) ; place the x word into our own dynamic table
addi.w #2, D6         ; move forward by two so we can get the y word
move.w (A2, D6.w), D7 ; jump into the table and grab the y word
move.w D7, (A1, D6.w) ; place the y word into our own dynamic table

;; team member 2, in the center
clr.w D6
move.b $1(A0), D6 ; load the second team member id
add.w D6, D6    ; quadruple it for offsetting into the table
add.w D6, D6    ; quadruple it for offsetting into the table
lea $2CUTSCENE2_TABLES, A2
adda.w #96, A2 ; jump forward to the center table, (24 characters, each with double word pair)
move.w (A2, D6.w), D7 ; jump into the table and grab the x word
move.w D7, (A1, D6.w) ; place the x word into our own dynamic table
addi.w #2, D6         ; move forward by two so we can get the y word
move.w (A2, D6.w), D7 ; jump into the table and grab the y word
move.w D7, (A1, D6.w) ; place the y word into our own dynamic table

;; team member 3, on the left side
clr.w D6
move.b $2(A0), D6 ; load the third team member id
add.w D6, D6    ; quadruple it for offsetting into the table
add.w D6, D6    ; quadruple it for offsetting into the table
lea $2CUTSCENE2_TABLES, A2
adda.w #192, A2 ; jump forward to the center table, (24 characters, each with double word pair, times two)
move.w (A2, D6.w), D7 ; jump into the table and grab the x word
move.w D7, (A1, D6.w) ; place the x word into our own dynamic table
addi.w #2, D6         ; move forward by two so we can get the y word
move.w (A2, D6.w), D7 ; jump into the table and grab the y word
move.w D7, (A1, D6.w) ; place the y word into our own dynamic table


;; set it up so the game pulls from our chosen team instead of a canned team
lea $WINNING_TEAM_LIST, A0
suba.l D0, A0
rts

;;;;;; SUBROUTINES

;;; chooseEndingTeam
;;; chooses from England (7), Mexico (6), USA (3) or Japan (2) for the ending
;;; depending on which teams *don't* have members that the player
;;; chose
;;;
;;; parameters
;;; ----
;;; A0: pointer to chosen team list for the player (word sized entries)
;;;
;;; return
;;; ----
;;; D0.b: the chosen ending team id
chooseEndingTeam:

;;; first get a random byte
clr.w D0
movem.l A0, $MOVEM_STORAGE ; game's rng uses A0
jsr $2582 ; call the game's rng, it leaves a random byte in D0
movem.l $MOVEM_STORAGE, A0
andi.b #3, D0 ; chop the chosen byte down to 0-3


chooseEndingTeam_testTeam:
lea $2ENDING_TEAM_ID_TO_MEMBERS, A1
move.w D0, D1
add.w D1, D1 ; quadruple it for long offsetting
add.w D1, D1 ; quadruple it for long offsetting
adda.w D1, A1 ; offset to the current team we are examining
move.l (A1), D1
movea.l D1, A1

;; player's member 1
move.b (A0), D1
;; versus team member 1
cmp.b (A1), D1
beq chooseEndingTeam_tryNextTeam

;; player's member 1
;; versus team member 2
cmp.b $1(A1), D1
beq chooseEndingTeam_tryNextTeam

;; player's member 1
;; versus team member 3
cmp.b $2(A1), D1
beq chooseEndingTeam_tryNextTeam

;; player's member 2
move.b $1(A0), D1
;; versus team member 1
cmp.b (A1), D1
beq chooseEndingTeam_tryNextTeam

;; player's member 2
;; versus team member 2
cmp.b $1(A1), D1
beq chooseEndingTeam_tryNextTeam

;; player's member 2
;; versus team member 3
cmp.b $2(A1), D1
beq chooseEndingTeam_tryNextTeam

;; player's member 3
move.b $2(A0), D1
;; versus team member 1
cmp.b (A1), D1
beq chooseEndingTeam_tryNextTeam

;; player's member 3
;; versus team member 2
cmp.b $1(A1), D1
beq chooseEndingTeam_tryNextTeam

;; player's member 3
;; versus team member 3
cmp.b $2(A1), D1
beq chooseEndingTeam_tryNextTeam
bra chooseEndingTeam_returnTeam

chooseEndingTeam_tryNextTeam:
addi.w #1, D0
cmpi.w #4, D0
bne chooseEndingTeam_tryNextTeam_skipWrap
move.w #0, D0 ; need to wrap back around
chooseEndingTeam_tryNextTeam_skipWrap:
bra chooseEndingTeam_testTeam ; and try again with the next team

chooseEndingTeam_returnTeam:
;;; if we got here, we found a team that will work
lea $2ENDING_TEAM_INDEX_TO_ID, A0
adda.w D0, A0 ; offset to the chosen team
move.b (A0), D0
rts





