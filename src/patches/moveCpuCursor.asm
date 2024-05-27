; moves the cpu cursor based on its current location in memory
;
; parameters:
; d7: sprite index of cpu cursor
; A0: address of current CPU index

cmpi.b #$ff, $DEFEATED_TEAMS ; have all the teams been defeated?
bne doRegularCpuCursor
;; all teams have been defeated, place the cursor on Rugal

;; left side for Rugal
move.w #142, D1 ; X 
move.w #374, D2 ; Y
move.w D7, D0
jsr $2MOVE_SPRITE

;; right side for Rugal
move.w #160, D1 ; X 
move.w #374, D2 ; Y
move.w D7, D0
addi.w #1, D0   ; move onto next sprite index
jsr $2MOVE_SPRITE
bra done

doRegularCpuCursor:
clr.w D0
; load current CPU index
move.b (A0), D0
; multiply it by 4 as each xy is 4 bytes
lsl.b #2, D0

lea $2TEAM_INDEX_TO_XY, A0
; jump ahead into the table based on which team is focused
adda.w D0, A0

; cpu cursor 1
; LEFT SIDE
; load up the parameters for moveSprite
move.w (A0), D1 ; X 
move.w $2(A0), D2 ; Y

move.w D7, D0
jsr $2MOVE_SPRITE

; RIGHT SIDE
move.w (A0), D1 ; X 
addi.w #16, D1  ; the ride side is 16px over
move.w $2(A0), D2 ; Y
addi.w #1, D7   ; move onto next sprite index
move.w D7, D0
jsr $2MOVE_SPRITE

; cpu cursor 2
; LEFT SIDE
; load up the parameters for moveSprite
move.w (A0), D1 ; X 
addi.w #32, D1  ; the ride side is 16px over
move.w $2(A0), D2 ; Y
addi.w #1, D7   ; move onto next sprite index
move.w D7, D0
jsr $2MOVE_SPRITE

; RIGHT SIDE
move.w (A0), D1 ; X 
addi.w #48, D1  ; the ride side is 16px over
move.w $2(A0), D2 ; Y
addi.w #1, D7   ; move onto next sprite index
move.w D7, D0
jsr $2MOVE_SPRITE

; cpu cursor 3
; LEFT SIDE
; load up the parameters for moveSprite
move.w (A0), D1 ; X 
addi.w #64, D1  ; the ride side is 16px over
move.w $2(A0), D2 ; Y
addi.w #1, D7   ; move onto next sprite index
move.w D7, D0
jsr $2MOVE_SPRITE

; RIGHT SIDE
move.w (A0), D1 ; X 
addi.w #80, D1  ; the ride side is 16px over
move.w $2(A0), D2 ; Y
addi.w #1, D7   ; move onto next sprite index
move.w D7, D0
jsr $2MOVE_SPRITE

done:
rts