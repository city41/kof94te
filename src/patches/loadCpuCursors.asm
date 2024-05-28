;; loadCpuCursors
;;
;; loads the cpu cursors for a single player game. This happens just before character select switches
;; from human to cpu. It's main job is to load the correct style of cursor depending on if
;; the cpu is using custom or original teams

btst #0, $PLAY_MODE ; is p1 human?
bne doP2Cpu ; they are human, check the other side
;; p1 is not human, so load a CPU cursor on the p1 side

cmpi.b #1, $CPU_CUSTOM_TEAMS_FLAG ;; is cpu is custom team mode?
bne doP1Original8

doP1Custom:
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D6
lea $2P1_CPU_CURSOR_CUSTOM_WHITE_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE
bra doP2Cpu

doP1Original8:
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D6
lea $2P1_CPU_CURSOR_ORIGINAL8_WHITE_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE


doP2Cpu:
btst #1, $PLAY_MODE ; is p2 human?
bne done ; they are human, nothing to do
;; p2 is not human, so load a CPU cursor on the p2 side

cmpi.b #1, $CPU_CUSTOM_TEAMS_FLAG ;; is cpu is custom team mode?
bne doP2Original8

doP2Custom:
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D6
lea $2P2_CPU_CURSOR_CUSTOM_WHITE_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE
bra done

doP2Original8:
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D6
lea $2P2_CPU_CURSOR_ORIGINAL8_WHITE_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

done:
rts