;;; determinCpuTeamMode
;;;
;;; takes all factors into account and then decides if the CPU should
;;; use custom teams or original 8 teams.

;; first did the player override by holding C or D?
;; if so, that wins no matter what
cmpi.b #1, $OVERRODE_CPU_CSTM_FLAG
beq done

;; is this a subsequent single player fight?
;; then the cpu mode has already been decided
btst #7, $PLAY_MODE
bne done

;; did the player continue? 
;; then the cpu mode has already been decided
btst #6, $PLAY_MODE
bne done

;; did the player choose an original 8 team for themselves?
btst #0, $PLAY_MODE
beq checkOriginalTeamP2
;; human is player 1
lea $P1_CUR_INPUT, A0
bra checkOriginalTeam

checkOriginalTeamP2:
btst #1, $PLAY_MODE
beq diceRoll
;; human is player 2
lea $P2_CUR_INPUT, A0
bra checkOriginalTeam

checkOriginalTeam:
jsr $2SET_ORIGINAL_TEAM_ID
cmpi.b #$ff, $PX_ORIGINAL_TEAM_ID_OFFSET(A0)
beq diceRoll
;; the player chose an original team, have the cpu do it too
move.b #0, $CPU_CUSTOM_TEAMS_FLAG
bra done

diceRoll:
;; at this point we are down to a dice roll
;; 62% chance of getting original teams (4 in 7)
jsr $2582 ; call the game's rng, it leaves a random byte in D0
andi.b #7, D0 ; chop it down to 0-7
cmpi.b #2, D0 ; if 0-2 -> custom team, 3-7 -> origina8 teams
ble setCustomTeam
;; the dice roll determined original teams
move.b #0, $CPU_CUSTOM_TEAMS_FLAG
bra done
setCustomTeam:
move.b #1, $CPU_CUSTOM_TEAMS_FLAG

done:
move.b #0, $CPU_CUSTOM_TEAMS_FLAG
rts