
;; clear out most of the fix layer, leaving top and bottom
;; intact otherwise we will fight the game

movem.w D3-D7, $MOVEM_STORAGE

; move.w #$17, D5     ; clear out 24 rows using dbra
move.w #$0, D5     ; clear out 1 row
clearRow:
; move.w #$7004, D3    ; the first row's starting address
move.w #$702d, D3    ; the first row's starting address
add.w D5, D3        ; add on to get to the current row's starting address
move.w D3, $3c0000  ; set VRAMADDR
move.w #32, $3c0004 ; set VRAMMOD
move.w #$25, D4     ; going to clear 38 chars per row

clearTile:
move.w #$20, $3c0002
dbra D4, clearTile
dbra D5, clearRow

;; then a test message

move.w #$72cd, $3c0000
move.w #32, $3c0004

move.w #$48, $3c0002 ;; 'H'
move.w #$45, $3c0002 ;; 'E'
move.w #$4C, $3c0002 ;; 'L'
move.w #$4C, $3c0002 ;; 'L'
move.w #$4F, $3c0002 ;; '0'

move.b #1, $IN_THANK_YOU_FLAG

movem.w $MOVEM_STORAGE, D3-D7
rts