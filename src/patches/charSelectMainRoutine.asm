movem.l A0-A2,$STORE_A0A1A2

;; if this is versus mode, randomize the team to get a random stage
btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq skipVersusRandomStage ; nope not versus, as p1 is not playing
btst #1, $NUM_PLAYER_MODE ; is p2 playing?
beq skipVersusRandomStage ; nope not versus, as p2 is not playing
;; this is versus mode, randomize the team ids to get a random stage
move.b $CHAR_SELECT_COUNTER, D6 ; load the counter
addi.b #1, D6
move.b D6, $CHAR_SELECT_COUNTER ; save its new value
andi.b #$7, D6 ; only keep the bottom three bits, that is our team id
move.b D6, $108231 ; set team 1 to this random id
move.b D6, $108431 ; and team 2 too
skipVersusRandomStage:


btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq skipPlayer1

move.b $BIOS_P1CHANGE, $P1_CUR_INPUT
;; the base address from which all other p1 values will derive from
lea $P1_CUR_INPUT, A0
move.w #$P1_CURSOR_SI, D6
move.w #$P1C1_SI, D7
jsr $2CHAR_SELECT_PLAYER_ROUTINE

skipPlayer1:
btst #1, $NUM_PLAYER_MODE ; is p2 playing?
beq skipPlayer2

move.b $BIOS_P2CHANGE, $P2_CUR_INPUT
;; the base address from which all other p2 values will derive from
lea $P2_CUR_INPUT, A0
move.w #$P2_CURSOR_SI, D6
move.w #$P2C1_SI, D7
jsr $2CHAR_SELECT_PLAYER_ROUTINE

skipPlayer2:

;;;;;;;;;;;;;;;;;; CPU CURSOR ;;;;;;;;;;;;;;;;;;;;;;;;
btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq prepCpuCursor ; not playing? then we know there is a cpu
btst #1, $NUM_PLAYER_MODE ; is p2 playing?
beq prepCpuCursor ; not playing? then we know there is a cpu
bra skipCpuCursor ; both players are playing, no cpu (versus mode)

prepCpuCursor:

btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq cpuCursor_skipPlayer1
move.b $P1_NUM_CHOSEN_CHARS, D0
move.w #$P2_CURSOR_SI, D7 ; use player two's cursor sprites
lea $1083c0, A0           ; point to where the cpu index is for p1
bra doCpuCursor

cpuCursor_skipPlayer1:
move.b $P2_NUM_CHOSEN_CHARS, D0
move.w #$P1_CURSOR_SI, D7 ; use player one's cursor sprites
lea $1081c0, A0           ; point to where the cpu index is for p2

doCpuCursor:
; if the player has not chosen three characters yet, no need for cpu cursor
cmpi.b #2, D0
ble skipCpuCursor
jsr $2MOVE_CPU_CURSOR

skipCpuCursor:

;;;;;; IS WHOLE TEAM CHOSEN? THEN MOVE ONTO ORDER SELECT ;;;;;
move.b #0, D3 ; D3 will hold the number of needed chosen chars: either 3 or 6 (versus mode)

clr.b D1
clr.b D2

btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq readyToExit_skipPlayer1
move.b $P1_NUM_CHOSEN_CHARS, D1
addi.b #3, D3

readyToExit_skipPlayer1:

btst #1, $NUM_PLAYER_MODE ; is p2 playing?
beq readyToExit_skipPlayer2
move.b $P2_NUM_CHOSEN_CHARS, D2
addi.b #3, D3

readyToExit_skipPlayer2:

;; now add p1 and p2 chosen chars
add.b D1, D2
cmp.b D2, d3
bne done 

; the number of needed chosen characters matches how many are 
; actually chosen, we are done with character select
move.b #1, $READY_TO_EXIT_CHAR_SELECT ; team chosen, signal to exit
done:

;; restore the saved address registers
movem.l $STORE_A0A1A2,A0-A2

rts