;; moveCpuCustomCursor
;; moves the cpu cursors according to the custom team the cpu has chosen
;;
;; parameters
;; A0: pointer to PX_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING
;; D0.w: starting sprite index

move.b #2, D4 ; dbra counter

renderCursor:
move.b (A0), D3 ; load the first character id
bsr calcX       ; X is in D1
bsr calcY       ; Y is in D2
jsr $2MOVE_SPRITE

adda.w #1, A0   ; move to next character
addi.w #1, D0   ; move to next sprite
dbra D4, renderCursor


rts


;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;;;


calcX:
move.w #100, D1
rts


calcY:
move.w #396, D2
rts