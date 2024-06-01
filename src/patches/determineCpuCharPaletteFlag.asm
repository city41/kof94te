;;; determineCpuCharPaletteFlag
;;;
;;; Figures out if a cpu character should use the alternate palette flag or not,
;;; based on the player's character/palette choices
;;;
;;; parameters
;;; ----------
;;; D7.b the character id of the cpu character in question
;;; A2 the player's chosen characters starting address
;;;
;;; used registers: D2, D3, D5
;;;
;;; returns
;;; -------
;;; D4.b: the palette flag, either 0, or 1

move.b (A2), D5 ; load the other team's first character
cmp.b D7, D5 ; does the other team's first character match the cpu character we are focused on?
bne determineCpuCharPaletteFlag_cpu_checkChar1
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $3(A2), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D3, D2 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D2, D4 ; move the final answer into D4, the "return value"
bra determineCpuCharPaletteFlag_done

determineCpuCharPaletteFlag_cpu_checkChar1:
move.b $1(A2), D5 ; load the other team's second character
cmp.b D7, D5
bne determineCpuCharPaletteFlag_cpu_checkChar2
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $4(A2), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D3, D2 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D2, D4 ; move the final answer into D4, the "return value"
bra determineCpuCharPaletteFlag_done

determineCpuCharPaletteFlag_cpu_checkChar2:
move.b $2(A2), D5 ; load the other team's third character
cmp.b D7, D5
bne determineCpuCharPaletteFlag_defaultChoice ; chose a character the human didn't choose? just go with reg palette
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $5(A2), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D3, D2 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D2, D4 ; move the final answer into D4, the "return value"
bra determineCpuCharPaletteFlag_done

determineCpuCharPaletteFlag_defaultChoice:
move.b #0, D4

determineCpuCharPaletteFlag_done:
rts