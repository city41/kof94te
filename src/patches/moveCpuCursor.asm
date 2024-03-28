; moves the cpu cursor based on its current location in memory
;
; parameters:
; d7: sprite index of cpu cursor
; A0: address of current CPU index


clr.w D0
; load current CPU index
move.b (A0), D0
; multiply it by 4 as each xy is 4 bytes
lsl.b #2, D0

lea $2TEAM_INDEX_TO_XY, A0
; jump ahead into the table based on which team is focused
adda.w D0, A0

; LEFT SIDE
; load up the parameters for moveSprite
move.w (A0), D1 ; X 
move.w $2(A0), D2 ; Y

move.w D7, D0
jsr $2MOVE_SPRITE

; RIGHT SIDE
move.w (A0), D1 ; X 
move.w $2(A0), D2 ; Y
addi.w #80, D1  ; the ride side is 80px over
addi.w #1, D7   ; move onto next sprite index
move.w D7, D0
jsr $2MOVE_SPRITE

rts