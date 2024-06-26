cmpi.b #$MAIN_PHASE_DONE, $MAIN_HACK_PHASE
bne runMain
bsr goToOrderSelect
rts

runMain:

jsr $2FLASH_CURSORS

btst #3, $100000 ; is the Rugal debug dip turned on?
beq takeRugalOffGrid
jsr $2PUT_RUGAL_ON_GRID
bra doneRugalOnGrid

takeRugalOffGrid:
jsr $2TAKE_RUGAL_OFF_GRID

doneRugalOnGrid:

;;; this is a generic counter used by parts of the hack that need throttling
addi.b #1, $THROTTLE_COUNTER

;; if this is versus or demo mode, randomize the team to get a random stage
cmpi.b #3, $PLAY_MODE ; is this versus mode?
beq pickRandomStage
cmpi.b #0, $PLAY_MODE ; is this demo mode?
beq pickRandomStage
bra skipVersusRandomStage

pickRandomStage:
;; get a random number between 0-7
;; the game's rng uses A0
movem.l A0, $MOVEM_STORAGE
jsr $2582 ; call the game's rng, it leaves a random byte in D0
movem.l $MOVEM_STORAGE, A0
andi.b #$7, D0; chop the random byte down to 3 bits -> 0 through 7
;; this is versus or demo mode, randomize the team ids to get a random stage
move.b D0, $108231 ; set team 1 to this random id
move.b D0, $108431 ; and team 2 too

skipVersusRandomStage:

cmpi.b #$MAIN_PHASE_PLAYER_SELECT, $MAIN_HACK_PHASE
beq doPlayerSelect
cmpi.b #$MAIN_PHASE_CPU_DELAY, $MAIN_HACK_PHASE
beq doCpuDelay
cmpi.b #$MAIN_PHASE_CPU_SELECT, $MAIN_HACK_PHASE
beq doCpuSelect
cmpi.b #$MAIN_PHASE_SUBSEQUENT_SINGLE_PLAYER_SELECT, $MAIN_HACK_PHASE
beq doSubsequentSelect
cmpi.b #$MAIN_PHASE_SCALE_GRID_DELAY, $MAIN_HACK_PHASE
beq doScaleGridDelay
cmpi.b #$MAIN_PHASE_SCALE_GRID_DOWN, $MAIN_HACK_PHASE
beq doScaleGridDown
cmpi.b #$MAIN_PHASE_SCALE_GRID_DONE, $MAIN_HACK_PHASE
beq doScaleGridDone
bra done


doPlayerSelect:
jsr $2CHAR_SELECT_PLAYER_SELECT_ROUTINE
bsr showCpuCursorAndTeamIfContinued
bsr checkIfPlayerSelectIsDone
cmpi.b #1, D6 ; if it is done, D6 will be 1
bne skipTransitionPastPlayerSelect ; not done yet
bsr transitionPastPlayerSelect ; move to next phase
skipTransitionPastPlayerSelect:
bra done

; delay a bit between player select and cpu select
; so that the final player select sound effect doesn't
; get cut off
doCpuDelay:
subi.b #1, $CPU_DELAY_COUNTDOWN
bne done
; countdown has hit zero, time to move to cpu
;
; custom or o8? we have to wait till now to figure this out
; because one input is what team the player chose
jsr $2DETERMINE_CPU_TEAM_MODE
; now that we know the mode, we can load cursors
jsr $2LOAD_CPU_CURSORS
move.b #$MAIN_PHASE_CPU_SELECT, $MAIN_HACK_PHASE
bra done



doCpuSelect:
jsr $2CHAR_SELECT_CPU_SELECT_ROUTINE
bsr checkIfCpuSelectIsDone
cmpi.b #1, D6 ; if it is done, D6 will be 1
bne skipTransitionPastCpuSelect
bsr transitionPastCpuSelect
skipTransitionPastCpuSelect:
bra done

doSubsequentSelect:
jsr $2CHAR_SELECT_PLAYER_SELECT_ROUTINE
jsr $2CHAR_SELECT_CPU_SELECT_ROUTINE
bsr checkIfSubsequentSelectIsDone
cmpi.b #1, D6 ; if it is done, D6 will be 1
bne skipTransitionPastSubsequentSelect
bsr transitionPastSubsequentSelect
skipTransitionPastSubsequentSelect:
bra done

; delay a bit between character select and the grid scaling down
doScaleGridDelay:
subi.w #1, $SCALE_GRID_DELAY_COUNTDOWN
bne done
; countdown has hit zero, time to move to scale grid
move.b #$MAIN_PHASE_SCALE_GRID_DOWN, $MAIN_HACK_PHASE
move.w #$ff, $GRID_SCALE_COUNTDOWN

bsr doScaleGridPrep

bra done



doScaleGridDown:

jsr $2SCALE_GRID
jsr $2SLIDE_AVATARS

; cmpi.w #190, $GRID_SCALE_COUNTDOWN
; bge skipSlideAvatars
; jsr $2SLIDE_AVATARS
; skipSlideAvatars:

subi.w #30, $GRID_SCALE_COUNTDOWN
bpl done

move.b #$MAIN_PHASE_SCALE_GRID_DONE, $MAIN_HACK_PHASE
bra done


doScaleGridDone:
; move.w #$GRID_IMAGE_SI, D6
; move.w #1, D7
; jsr $2TRUNCATE_SPRITES_ROUTINE
move.b #$MAIN_PHASE_DONE, $MAIN_HACK_PHASE
bra done



done:
rts

;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;
 
;;; checkIfPlayerSelectIsDone
;;; looks to see if all human players (1 or 2 of them),
;;; have chosen their entire team.
;;;
;;; returns
;;; D6.b: 0 if not done, 1 if done
checkIfPlayerSelectIsDone:
move.b #0, D2 ; D2 will hold the number of needed ready flags: either 1 or 2 (versus mode)

clr.b D1

btst #0, $PLAY_MODE ; is p1 playing?
beq checkIfPlayerSelectIsDone_skipPlayer1
add.b $P1_IS_READY, D1 ; grab whether P1 is ready or not
addi.b #1, D2 ; increase number of checks needed

checkIfPlayerSelectIsDone_skipPlayer1:

btst #1, $PLAY_MODE ; is p2 playing?
beq checkIfPlayerSelectIsDone_skipPlayer2
add.b $P2_IS_READY, D1 ; grab whether P2 is ready or not
addi.b #1, D2 ; increase number of checks needed

checkIfPlayerSelectIsDone_skipPlayer2:

cmp.b D1, D2

;; nope, someone is not ready yet
bne checkIfPlayerSelectIsDone_notReady

; ; all players are ready, we are done with player select
move.b #1, D6
bra checkIfCpuSelectIsDone_done

checkIfPlayerSelectIsDone_notReady:
move.b #0, D6

checkIfPlayerSelectIsDone_done:
rts



;;; transitionPastPlayerSelect
;;; moves from player select to cpu or done,
;;; depending on if this is versus mode, if the player continued, or not
transitionPastPlayerSelect:
; is this versus mode? then we are totally done
cmpi.b #3, $PLAY_MODE
beq transitionPastPlayerSelect_setCharSelectDone
; did the player continue?
btst #6, $PLAY_MODE
; yes? then we are also totally done
bne transitionPastPlayerSelect_setCharSelectDone

; this is neither versus mode nor did the player continue,
; so we need to go to cpu phase, but first we will delay a bit
; to allow the player's final sound effect to finish
move.b #20, $CPU_DELAY_COUNTDOWN
move.b #$MAIN_PHASE_CPU_DELAY, $MAIN_HACK_PHASE
bra transitionPastPlayerSelect_done

transitionPastPlayerSelect_setCharSelectDone:
move.b #$MAIN_PHASE_SCALE_GRID_DELAY, $MAIN_HACK_PHASE
move.w #$SCALE_GRID_DELAY_DURATION, $SCALE_GRID_DELAY_COUNTDOWN

transitionPastPlayerSelect_done:
rts



;;; checkIfCpuSelectIsDone
;;; looks to see if the cpu randomization is done
;;;
;;; returns
;;; D6.b: 0 if not done, 1 if done
checkIfCpuSelectIsDone:
cmpi.b #0, $CPU_TEAM_SELECT_COUNTDOWN
beq checkIfCpuSelectIsDone_cpuIsDone
bra checkIfCpuSelectIsDone_notYet

checkIfCpuSelectIsDone_cpuIsDone:
move.b #1, D6
bra checkIfCpuSelectIsDone_done

checkIfCpuSelectIsDone_notYet:
move.b #0, D6

checkIfCpuSelectIsDone_done:
rts


;;; transitionPastCpuSelect
;;; moves from cpu select to done,
transitionPastCpuSelect:
; cpu is done, show their team in the chosen section
bsr renderCpuChosenTeam
move.b #$MAIN_PHASE_SCALE_GRID_DELAY, $MAIN_HACK_PHASE
move.w #$SCALE_GRID_DELAY_DURATION, $SCALE_GRID_DELAY_COUNTDOWN
rts



;;; checkIfSubsequentSelectIsDone
;;; this is for single player games beyond the first
;;; fight. The char select screen is basically read-only
;;; but we still need to do the slot machine and cpu custom teams
;;; in some cases
;;;
;;; returns
;;; D6.b: 0 if not done, 1 if done
checkIfSubsequentSelectIsDone:
bsr checkIfPlayerSelectIsDone ; go see if the player is done
cmpi.b #0, D6
beq checkIfSubsequentSelectIsDone_notYet ; player is not done yet
;; ok player is done, what about cpu?
bsr checkIfCpuSelectIsDone 
cmpi.b #0, D6
beq checkIfSubsequentSelectIsDone_notYet ; cpu is not done yet

checkIfSubsequentSelectIsDone_subsequentIsDone:
move.b #1, D6
bra checkIfSubsequentSelectIsDone_done

checkIfSubsequentSelectIsDone_notYet:
move.b #0, D6

checkIfSubsequentSelectIsDone_done:
rts

;;; transitionPastSubsequentSelect
;;; moves from subsequent select to done,
transitionPastSubsequentSelect:
;;; for now, this just does the same thing as cpu
bsr transitionPastCpuSelect
rts


;;; renderCpuChosenTeam
;;; takes the cpu's chosen team and renders it into the chosen avatar area
;;; this is to match what KOF95 does
renderCpuChosenTeam:
clr.w D1
btst #0, $PLAY_MODE ; is p1 playing?
bne renderCpuChosenTeam_checkP2 ; player 1 is playing, go check p2
;; p1 is not playing, so p1 is a cpu 
move.b #0, D4
move.w #1, D6 ; avatar index 1
move.b $108231, D1 ; load the chosen team ID
lea $P1_CHOSEN_CHAR0, A1
lea $P2_CHOSEN_CHAR0, A2
bsr renderCpuChosenTeam_doRender

renderCpuChosenTeam_checkP2:
btst #1, $PLAY_MODE ; is p2 playing?
bne renderCpuChosenTeam_done ; they are playing, nothing to do
;; p2 is not playing, so p2 is a cpu 
move.b #1, D4
move.w #4, D6 ; avatar index 4
move.b $108431, D1 ; load the chosen team ID
lea $P2_CHOSEN_CHAR0, A1
lea $P1_CHOSEN_CHAR0, A2
bsr renderCpuChosenTeam_doRender

renderCpuChosenTeam_done:
rts



;;; making this its own subroutine as it needs to get called
;;; multiple times depending on if single player or demo mode
;;;
;;; parameters
;;; D4.b: 0 for p1 or 1 for p2
;;; D6.w: avatar index
;;; D1.b: chosen team id
;;; A1: this team's chosen character list 
;;; A2: other team's chosen characters list
renderCpuChosenTeam_doRender:
cmpi.b #8, D1 ; is this Rugal?
beq renderCpuChosenTeam_doRender_done ; then nothing to do, Rugal isn't shown in this situation

move.w #2, D3 ; get dba primed, 2 since it hinges on -1

cmpi.b #1, $CPU_CUSTOM_TEAMS_FLAG
bne renderCpuChosenTeam_original8
;; this is cpu custom teams, and the custom team was handed to us in A1
movea.l A1, A0
bra renderCpuChosenTeam_renderChar

renderCpuChosenTeam_original8:
;; this is cpu original 8 teams. In this case we have the team ID, with that 
;; we need to go get the character ids
lea $534DC, A0 ; load the starting team->character list address
mulu.w #4, D1  ; multiply team id by 4, as there are 4 bytes per team (three characters and a ff delimiter)
adda.w D1, A0  ; move into the list to the correct team


renderCpuChosenTeam_renderChar:
clr.w D7
move.b (A0), D7 ; load character id

cmpi.b #0, $PLAY_MODE ; is this demo mode?
beq renderCpuChosenTeam_doRender_renderChosenAvatar ; then palette flag is already in D4
;;; get the cpu palette flag
;;; params
;;; D7: char id
;;; A2: the player's chosen char starting address 
movem.w D3, $MOVEM_STORAGE
jsr $2DETERMINE_CPU_CHAR_PALETTE_FLAG
movem.w $MOVEM_STORAGE, D3

renderCpuChosenTeam_doRender_renderChosenAvatar:
jsr $2RENDER_CHOSEN_AVATAR
adda.w #1, A0 ; move to next character
addi.w #1, D6 ; move to next avatar index
dbra D3, renderCpuChosenTeam_renderChar
bra renderCpuChosenTeam_doRender_done

renderCpuChosenTeam_doRender_done:
rts


;; showCpuCursorAndTeamIfContinued
;;
;; if the player just continued, show the cpu cursor 
;; during player select, as well as the chosen avatars
;; for the cpu team
showCpuCursorAndTeamIfContinued:
btst #6, $PLAY_MODE ; did they continue?
beq showCpuCursorAndTeamIfContinued_done ; no? nothing to do

;;; first, render their chosen avatars
bsr renderCpuChosenTeam

btst #0, $PLAY_MODE
beq showCpuCursorAndTeamIfContinued_setupForPlayer2
lea $P2_CUR_INPUT, A0
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
bra showCpuCursorAndTeamIfContinued_doCursor

showCpuCursorAndTeamIfContinued_setupForPlayer2:
lea $P1_CUR_INPUT, A0
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0

showCpuCursorAndTeamIfContinued_doCursor:
jsr $2MOVE_CPU_CURSOR

showCpuCursorAndTeamIfContinued_done:
rts

;; doScaleGridPrep
;;
;; preps for scaling the grid. Things like hide the chosen avatars and cursors
doScaleGridPrep:

;; hide all cursors
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D6
move.w #6, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D6
move.w #6, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

;; set up the grid y position
move.w #$SCALE_GRID_Y_STARTING_POSITION, $SCALE_GRID_Y_POSITION

rts


;; goToOrderSelect
;; sends the game to order select by having team select run for just one (maybe two or three)
;; frames. This allows team select to prep and setup order select for us
;; normally this means waiting for team select to finish its cpu team selection
;; but there is a patch at the bottom of kof94te.json that drains that timer down to 1
goToOrderSelect:
;; set the function pointer to team select
move.l #$37046, $108584
;; drain the timer, so it stays in team select as little as possible
move.w #0, $108654
move.b #1, $READY_TO_EXIT_CHAR_SELECT

rts