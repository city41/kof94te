;; moveCpuCustomCursor
;; moves the cpu cursors according to the custom team the cpu has chosen
;;
;; parameters
;; A0: pointer to a team character id list
;; D0.w: starting sprite index


move.w #2, D5 ; dbra counter

renderCursor:
clr.w D3
;; cursor left sprite
move.b (A0), D3 ; load the first character id
bsr calcX       ; X is in D1
bsr calcY       ; Y is in D2
jsr $2MOVE_SPRITE
;; cursor right sprite
clr.w D3
move.b (A0), D3 ; load the first character id
bsr calcX       ; X is in D1
bsr calcY       ; Y is in D2
addi.w #17, D1  ; move x over
addi.w #1, D0   ; move to next sprite
jsr $2MOVE_SPRITE

adda.w #1, A0   ; move to next character
addi.w #1, D0   ; move to next sprite
dbra D5, renderCursor

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