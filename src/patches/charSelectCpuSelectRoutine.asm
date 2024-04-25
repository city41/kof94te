; charSelectCpuSelectRoutine
; does everything related to the cpu choosing their team. This is mostly
; moving the cpu cursor around as the randomization happens, which the 
; the main game does for us

cmpi.b #0, $PLAY_MODE ; is this demo mode?
bne prepCpuCursorForSinglePlayerMode
;; this is demo mode, there are two cpu cursors
;; first, cpu 1
move.w #$P1_CURSOR_LEFT_SI, D7 ; use player one's cursor sprites
lea $1081c0, A0           ; point to where the cpu index is for p1
jsr $2MOVE_CPU_CURSOR
move.w #$P2_CURSOR_LEFT_SI, D7 ; use player two's cursor sprites
lea $1083c0, A0           ; point to where the cpu index is for p2
jsr $2MOVE_CPU_CURSOR
bra done

prepCpuCursorForSinglePlayerMode:
btst #0, $PLAY_MODE ; is p1 playing?
beq cpuCursor_skipPlayer1
move.w #$P2_CURSOR_LEFT_SI, D7 ; use player two's cursor sprites
lea $1083c0, A0           ; point to where the cpu index is for p1
bra doCpuCursor

cpuCursor_skipPlayer1:
move.w #$P1_CURSOR_LEFT_SI, D7 ; use player one's cursor sprites
lea $1081c0, A0           ; point to where the cpu index is for p2

doCpuCursor:
jsr $2MOVE_CPU_CURSOR

done:
rts