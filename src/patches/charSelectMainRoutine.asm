movem.l A0-A2,$STORE_A0A1A2

move.b $BIOS_PLAYER_MOD1, D1 ; is p1 playing?
beq skipPlayer1

move.b $BIOS_P1CHANGE, $P1_CUR_INPUT
;; the base address from which all other p1 values will derive from
lea $P1_CUR_INPUT, A0
move.w #$P1_CURSOR_SI, D6
move.w #$P1C1_SI, D7
jsr $2CHAR_SELECT_PLAYER_ROUTINE

skipPlayer1:
move.b $BIOS_PLAYER_MOD2, D1 ; is p2 playing?
beq skipPlayer2

move.b $BIOS_P2CHANGE, $P2_CUR_INPUT
;; the base address from which all other p2 values will derive from
lea $P2_CUR_INPUT, A0
move.w #$P2_CURSOR_SI, D6
move.w #$P2C1_SI, D7
jsr $2CHAR_SELECT_PLAYER_ROUTINE

skipPlayer2:

;;;;;;;;;;;;;;;;;; CPU CURSOR ;;;;;;;;;;;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD1, D1 ; is p1 playing?
beq prepCpuCursor ; not playing? then we know there is a cpu
move.b $BIOS_PLAYER_MOD2, D1 ; is p2 playing?
beq prepCpuCursor ; not playing? then we know there is a cpu
bra skipCpuCursor ; both players are playing, no cpu (versus mode)

prepCpuCursor:

move.b $BIOS_PLAYER_MOD1, D1 ; is p1 playing?
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




;; restore the saved address registers
movem.l $STORE_A0A1A2,A0-A2

;;;;;; IS WHOLE TEAM CHOSEN? THEN MOVE ONTO ORDER SELECT ;;;;;
move.b #0, D3 ; D3 will hold the number of needed chosen chars: either 3 or 6 (versus mode)

move.b $BIOS_PLAYER_MOD1, D0 ; is p1 playing?
beq readyToExit_skipPlayer1
move.b $P1_NUM_CHOSEN_CHARS, D1
addi.b #3, D3

readyToExit_skipPlayer1:

move.b $BIOS_PLAYER_MOD2, D0 ; is p2 playing?
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

rts