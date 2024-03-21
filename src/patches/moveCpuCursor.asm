move.b $CHAR_SELECT_COUNTER, D5

clr.w D0
; load current CPU index
move.b $1083c0, D0
; multiply it by 4 as each xy is 4 bytes
lsl.b #2, D0

lea $2TEAM_INDEX_TO_XY, A0
; jump ahead into the table based on which team is focused
adda.w D0, A0

; load up the parameters for moveSprite
move.w (A0)+, D1 ; X 
move.w (A0)+, D2 ; Y

btst #2, D5
beq blackCursor
move.w #$P2_CPU_CURSOR_WHITE_BORDER_SI, D0
bra moveCursor
blackCursor:
move.w #$P2_CPU_CURSOR_BLACK_BORDER_SI, D0
moveCursor:
jsr $2MOVE_SPRITE

;; now hide the one that should not be on screen
move.w #0, D1 ; X
move.w #272, D2 ; Y, which will be 224px, putting it off screen
btst #2, D5
beq hideWhiteCursor
move.w #$P2_CPU_CURSOR_BLACK_BORDER_SI, D0 ; load the cursor's sprite index
bra hideCursor
hideWhiteCursor:
move.w #$P2_CPU_CURSOR_WHITE_BORDER_SI, D0 ; load the cursor's sprite index
hideCursor:
jsr $2MOVE_SPRITE

rts