;; moveCpuCustomCursor
;; moves the cpu cursors according to the custom team the cpu has chosen
;;
;; parameters
;; A0: pointer to a player's base data
;; D0.w: starting sprite index


move.w #2, D5 ; dbra counter
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A2

renderCursor:
clr.w D3
;; cursor left sprite
move.b (A2), D3 ; load the first character id
bsr calcX       ; X is in D1
bsr calcY       ; Y is in D2
jsr $2MOVE_SPRITE
;; cursor right sprite
clr.w D3
move.b (A2), D3 ; load the first character id
bsr calcX       ; X is in D1
bsr calcY       ; Y is in D2
addi.w #16, D1  ; move x over
addi.w #1, D0   ; move to next sprite
jsr $2MOVE_SPRITE

adda.w #1, A2   ; move to next character
addi.w #1, D0   ; move to next sprite
dbra D5, renderCursor

;; play the movement sound effect
;; kof95 never plays a choice sound effect in this scenario
;; so we won't either
move.b #$60, $320000 ; play movement sfx
rts


;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;;;


;; calcX
;; given the character ID in D3,
;; returns the appropriate X value in D1
calcX:
lea $2CHARID_TO_GRID_X, A1 
adda.w D3, A1  ; offset into the list based on char id
adda.w D3, A1  ; twice since this list is words
move.w (A1), D1
rts


;; calcX
;; given the character ID in D3,
;; returns the appropriate y value in D2
calcY:
lea $2CHARID_TO_GRID_Y, A1 
adda.w D3, A1  ; offset into the list based on char id
adda.w D3, A1  ; twice since this list is words
move.w (A1), D2
rts