jsr $2FLASH_CURSORS

btst #0, $10fdac ; is p1 start down?
bne renderVersion
bra clearVersion

renderVersion:
move.b #1, $VSTRING_DATA + 6
;;; now show the qr image
move.w #0, D5 ; image data offset
move.w #$QR_SI, D6
lea $2QR_IMAGE, A6
jsr $2RENDER_STATIC_IMAGE
bra doVersionString

clearVersion:
move.b #0, $VSTRING_DATA + 6
;;; now clear the qr image
move.w #$QR_SI, D6
move.w #2, D7
jsr $2TRUNCATE_SPRITES_ROUTINE


doVersionString:
lea $VSTRING_DATA, A6
;; need to save A5 as the game's rng relies on it
movem.l A5, $MOVEM_STORAGE
jsr $2STRING_TO_FIX_LAYER_ROUTINE
movem.l $MOVEM_STORAGE, A5

btst #3, $100000 ; is the Rugal debug dip turned on?
beq takeRugalOffGrid
jsr $2PUT_RUGAL_ON_GRID
bra doneRugalOnGrid

takeRugalOffGrid:
cmpi.b #$ff, $DEFEATED_TEAMS
beq doneRugalOnGrid ; don't remove him if this is the Rugal fight
move.w #$RUGAL_SI, D6
jsr $2CLEAR_CHOSEN_AVATAR

doneRugalOnGrid:

;; this counter is used just below for random stages in versus mode
;; it's also used to throttle character random select
move.b $CHAR_SELECT_COUNTER, D6 ; load the counter
addi.b #1, D6
move.b D6, $CHAR_SELECT_COUNTER ; save its new value

;; if this is versus mode, randomize the team to get a random stage
cmpi.b #3, $PLAY_MODE
bne skipVersusRandomStage ; nope not versus
;; this is versus mode, randomize the team ids to get a random stage
andi.b #$7, D6 ; only keep the bottom three bits, that is our team id
move.b D6, $108231 ; set team 1 to this random id
move.b D6, $108431 ; and team 2 too
skipVersusRandomStage:

cmpi.b #$MAIN_PHASE_DONE, $MAIN_HACK_PHASE
;; once we hit done, the game comes in here many times
;; not we can do but wait for the game to move on
beq done
cmpi.b #$MAIN_PHASE_PLAYER_SELECT, $MAIN_HACK_PHASE
beq doPlayerSelect
cmpi.b #$MAIN_PHASE_CPU_SELECT, $MAIN_HACK_PHASE
beq doCpuSelect
cmpi.b #$MAIN_PHASE_WRAP_UP, $MAIN_HACK_PHASE
beq doCharSelectWrapUp
bra done


doPlayerSelect:
jsr $2CHAR_SELECT_PLAYER_SELECT_ROUTINE
bsr checkIfPlayerSelectIsDone
bra done

doCpuSelect:
jsr $2CHAR_SELECT_CPU_SELECT_ROUTINE
bsr checkIfCpuSelectIsDone
bra done

doCharSelectWrapUp:
jsr $2CHAR_SELECT_WRAP_UP_ROUTINE
bsr checkIfWrapUpIsDone
bra done

done:
rts

;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;
 
;;; checkIfPlayerSelectIsDone
;;; looks to see if all human players (1 or 2 of them),
;;; have chosen their entire team. If so, sets phase to CPU_SELECT
checkIfPlayerSelectIsDone:
move.b #0, D3 ; D3 will hold the number of needed chosen chars: either 3 or 6 (versus mode)

clr.b D1
clr.b D2

btst #0, $PLAY_MODE ; is p1 playing?
beq checkIfPlayerSelectIsDone_skipPlayer1
move.b $P1_NUM_CHOSEN_CHARS, D1
addi.b #3, D3

checkIfPlayerSelectIsDone_skipPlayer1:

btst #1, $PLAY_MODE ; is p2 playing?
beq checkIfPlayerSelectIsDone_skipPlayer2
move.b $P2_NUM_CHOSEN_CHARS, D2
addi.b #3, D3

checkIfPlayerSelectIsDone_skipPlayer2:

;; now add p1 and p2 chosen chars
add.b D1, D2
cmp.b D2, d3

;; nope, more characters need to be selected, try again next frame
bne checkIfPlayerSelectIsDone_done

; the number of needed chosen characters matches how many are 
; actually chosen, we are done with player select

; is this versus mode? then we are totally done
cmpi.b #3, $PLAY_MODE
bne checkIfPlayerSelectIsDone_setCpuPhase
;; this is versus mode, char select is now done
move.b #$MAIN_PHASE_DONE, $MAIN_HACK_PHASE
move.b #1, $READY_TO_EMPTY_TEAM_SELECT_TIMER
move.b #1, $READY_TO_EXIT_CHAR_SELECT
bra checkIfPlayerSelectIsDone_done

checkIfPlayerSelectIsDone_setCpuPhase:
move.b #$MAIN_PHASE_CPU_SELECT, $MAIN_HACK_PHASE
;; signal out that the game should move on
move.b #1, $READY_TO_EMPTY_TEAM_SELECT_TIMER

checkIfPlayerSelectIsDone_done:
rts


;;; checkIfCpuSelectIsDone
;;; looks to see if the cpu randomization is done
;;; if so, sets phase to DONE

checkIfCpuSelectIsDone:
btst #0, $PLAY_MODE ; is player 1 playing?
beq checkIfCpuSelectIsDone_skipPlayer1
cmpi.b #$ff, $CPU_RANDOM_SELECT_COUNTER_FOR_P1
beq checkIfCpuSelectIsDone_cpuIsDone
cmpi.b #8, $108431 ; is the next fight rugal?
beq checkIfCpuSelectIsDone_cpuIsDone

;;; HACK: this is to account for one usecase
;; p1 beats the cpu
;; p2 challenges
;; p2 beats p2
;; p1 goes back to single player
;; this detects that case and moves past char select
;; after two seconds
;; this is a hacky/fragile way to solve this. Another problem
;; when returning to single player, it will randomly pick a new team
;; instead of refighting the one you were interrupted on
btst #7, $PLAY_MODE
beq checkIfCpuSelectIsDone_done
cmpi.b #$12, $108654
beq checkIfCpuSelectIsDone_cpuIsDone
bra checkIfCpuSelectIsDone_done

checkIfCpuSelectIsDone_skipPlayer1:
;; now check player 2, either player 1 isn't playing
;; or this is demo mode. Either way, checking p2 will work
cmpi.b #$ff, $CPU_RANDOM_SELECT_COUNTER_FOR_P2
beq checkIfCpuSelectIsDone_cpuIsDone
cmpi.b #8, $108231 ; is the next fight rugal?
beq checkIfCpuSelectIsDone_cpuIsDone

;; see hack alert above
btst #7, $PLAY_MODE
beq checkIfCpuSelectIsDone_done
cmpi.b #$12, $108654
beq checkIfCpuSelectIsDone_cpuIsDone
bra checkIfCpuSelectIsDone_done

checkIfCpuSelectIsDone_cpuIsDone:
;; cpu is done, show their team in the chosen section
bsr renderCpuChosenTeam
move.b #$MAIN_PHASE_WRAP_UP, $MAIN_HACK_PHASE

checkIfCpuSelectIsDone_done:
rts

;;; checkIfWrapUpIsDone
checkIfWrapUpIsDone:
cmpi.b #$ff, $WRAP_UP_COUNTDOWN
bne checkIfWrapUpIsDone_done
;;; wrap up has concluded, time to signal char select is done
move.b #$MAIN_PHASE_DONE, $MAIN_HACK_PHASE
move.b #1, $READY_TO_EXIT_CHAR_SELECT

checkIfWrapUpIsDone_done:
rts

;;; renderCpuChosenTeam
;;; takes the cpu's chosen team and renders it into the chosen avatar area
;;; this is to match what KOF95 does
renderCpuChosenTeam:
clr.w D1
btst #0, $PLAY_MODE ; is p1 playing?
bne renderCpuChosenTeam_renderCpuOnP2Side
;; p1 is not playing, so cpu is p1
move.w #$P1C1_SI, D6
move.b $108231, D1
lea $P2_CHOSEN_CHAR2, A2
bra renderCpuChosenTeam_doRender

renderCpuChosenTeam_renderCpuOnP2Side:
;; p1 is playing, so cpu is p2
move.w #$P2C1_SI, D6
move.b $108431, D1
lea $P1_CHOSEN_CHAR0, A2


renderCpuChosenTeam_doRender:
cmpi.b #8, D1 ; is this Rugal?
beq renderCpuChosenTeam_rugal

move.w #2, D3 ; get dba primed, 2 since it hinges on -1

;; ok, we have the cpu team id, but not the characters, we need to look them up
lea $534DC, A0 ; load the starting team->character list address
mulu.w #4, D1  ; multiply team id by 4, as there are 4 bytes per team (three characters and a ff delimiter)
adda.w D1, A0  ; move into the list to the correct team


renderCpuChosenTeam_renderChar:
clr.w D7
move.b (A0), D7 ; load character id

;;; get the cpu palette flag
;;; params
;;; D7: char id
;;; A2: the player's chosen char starting address 
movem.w D3, $MOVEM_STORAGE
jsr $2DETERMINE_CPU_CHAR_PALETTE_FLAG
movem.w $MOVEM_STORAGE, D3

jsr $2RENDER_CHOSEN_AVATAR
adda.w #1, A0 ; move to next character
addi.w #2, D6 ; move to next sprite index
dbra D3, renderCpuChosenTeam_renderChar
bra renderCpuChosenTeam_done

renderCpuChosenTeam_rugal:
move.w #$18, D7 ; ensure Rugal's id is loaded
move.b #0, D4   ; palette flag
jsr $2RENDER_CHOSEN_AVATAR

renderCpuChosenTeam_done:
rts