move.b $CHAR_SELECT_COUNTER, D5

clr.w D0
; load current CPU index
move.b $1083c0, D0
; multiply it by 4 as each xy is 4 bytes
lsl.b #2, D0

lea $2TEAM_INDEX_TO_XY, A0
; jump ahead into the table based on which team is focused
adda.w D0, A0

; load X/Y 
move.w (A0)+, D6 ; X 
move.w (A0)+, D7 ; Y

; LEFT SIDE
; load up the parameters for moveSprite
move.w D6, D1 ; X 
move.w D7, D2 ; Y

move.w #$P2_CURSOR_SI, D0
jsr $2MOVE_SPRITE

; RIGHT SIDE
move.w D6, D1 ; X 
move.w D7, D2 ; Y
addi.w #80, D1  ; the ride side is 80px over
move.w #$P2_CURSOR_SI + 1, D0
jsr $2MOVE_SPRITE

rts