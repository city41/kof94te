movem.l A0-A2,$STORE_A0A1A2

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

cmpi.b #$PHASE_DONE, $HACK_PHASE
;; once we hit done, the game comes in here many times
;; not we can do but wait for the game to move on
beq done
cmpi.b #$PHASE_PLAYER_SELECT, $HACK_PHASE
beq doPlayerSelect
cmpi.b #$PHASE_CPU_SELECT, $HACK_PHASE
beq doCpuSelect


doPlayerSelect:
jsr $2CHAR_SELECT_PLAYER_SELECT_ROUTINE
bsr checkIfPlayerSelectIsDone
bra done

doCpuSelect:
jsr $2CHAR_SELECT_CPU_SELECT_ROUTINE
bsr checkIfCpuSelectIsDone
bra done

done:
movem.l $STORE_A0A1A2,A0-A2
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
move.b #$PHASE_DONE, $HACK_PHASE
move.b #1, $READY_TO_EMPTY_TEAM_SELECT_TIMER
move.b #1, $READY_TO_EXIT_CHAR_SELECT
bra checkIfPlayerSelectIsDone_done

checkIfPlayerSelectIsDone_setCpuPhase:
move.b #$PHASE_CPU_SELECT, $HACK_PHASE
;; signal out that the game should move on
move.b #1, $READY_TO_EMPTY_TEAM_SELECT_TIMER

checkIfPlayerSelectIsDone_done:
rts


;;; checkIfCpuSelectIsDone
;;; looks to see if the cpu randomizatoin is done
;;; if so, sets phase to DONE

checkIfCpuSelectIsDone:
btst #0, $PLAY_MODE ; is player 1 playing?
beq checkIfCpuSelectIsDone_skipPlayer1
cmpi.b #$ff, $CPU_RANDOM_SELECT_COUNTER_FOR_P1
beq checkIfCpuSelectIsDone_cpuIsDone
cmpi.b #8, $108431 ; is the next fight rugal?
beq checkIfCpuSelectIsDone_cpuIsDone

checkIfCpuSelectIsDone_skipPlayer1:
;; now check player 2, either player 1 isn't playing
;; or this is demo mode. Either way, checking p2 will work
cmpi.b #$ff, $CPU_RANDOM_SELECT_COUNTER_FOR_P2
beq checkIfCpuSelectIsDone_cpuIsDone
cmpi.b #8, $108231 ; is the next fight rugal?
beq checkIfCpuSelectIsDone_cpuIsDone
bra checkIfCpuSelectIsDone_done

checkIfCpuSelectIsDone_cpuIsDone:
;; cpu is done, so set the signal
move.b #1, $READY_TO_EXIT_CHAR_SELECT

checkIfCpuSelectIsDone_done:
rts


