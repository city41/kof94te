; clearChosenAvatar
;
; clears out a chosen character 
; in one of the 0th, 1st or 2nd position
;
; parameters
; D6.w - sprite index

;;;;;;; SCB1: load sprite tiles
move.w #1, $3c0004 ; VRAMMOD=1

;; set VRAMADDR to sprite index in D6
lsl.w #6, D6 ; si * 64, since in SCB1 each sprite is 64 words
move.w D6, $3c0000 ; VRAMADDR to SCB1, sprite si

;;;;;;;; column 1 ;;;;;;;;;;;
;; tile 1
move.w #0, $3c0002 ; lsb of tile
move.w #0, $3c0002 ; palette/etc of tile
;; tile 2
move.w #0, $3c0002 ; lsb of tile
move.w #0, $3c0002 ; palette/etc of tile

;;;;;;;; column 2 ;;;;;;;;;;;
;; first move to the next sprite
addi.w #64, D6 ; move to next sprite
move.w D6, $3c0000 ; VRAMADDR to SCB1, sprite si
;; now push the data across
;; tile 1
move.w #0, $3c0002 ; lsb of tile
move.w #0, $3c0002 ; palette/etc of tile
;; tile 2
move.w #0, $3c0002 ; lsb of tile
move.w #0, $3c0002 ; palette/etc of tile

rts