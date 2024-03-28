;;;; NOTE: using A5 needs to be done carefully, the main game
;;;; expects it when we rts
movem.l A0-A2,$STORE_A0A1A2

move.b $BIOS_PLAYER_MOD1, D1 ; is p1 playing?
beq skipPlayer1

move.b $BIOS_P1CHANGE, $P1_CUR_INPUT
lea $P1_CUR_INPUT, A0
move.w #$P1_CURSOR_SI, D6
move.w #$P1C1_SI, D7
jsr $2CHAR_SELECT_PLAYER_ROUTINE

skipPlayer1:
move.b $BIOS_PLAYER_MOD2, D1 ; is p2 playing?
beq skipPlayer2

move.b $BIOS_P2CHANGE, $P2_CUR_INPUT
lea $P2_CUR_INPUT, A0
move.w #$P2_CURSOR_SI, D6
move.w #$P2C1_SI, D7
jsr $2CHAR_SELECT_PLAYER_ROUTINE

skipPlayer2:

;;;;;;;;;;;;;;;;;; CPU CURSOR ;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO skip in versus mode
; bra skipCpuCursor  

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
cmpi.b #2, D0
ble skipCpuCursor
jsr $2MOVE_CPU_CURSOR
skipCpuCursor:




;; restore the saved address registers
movem.l $STORE_A0A1A2,A0-A2

;;;;;; IS WHOLE TEAM CHOSEN? THEN MOVE ONTO ORDER SELECT ;;;;;
;;; TODO: need to account for versus mode
move.b $BIOS_PLAYER_MOD1, D1 ; is p1 playing?
beq readyToExit_skipPlayer1
move.b $P1_NUM_CHOSEN_CHARS, D0
bra doReadyToExit

readyToExit_skipPlayer1:
move.b $P2_NUM_CHOSEN_CHARS, D0

doReadyToExit:
cmpi.b #2, D0
ble done
move.b #1, $READY_TO_EXIT_CHAR_SELECT ; team chosen, signal to exit
done:

rts