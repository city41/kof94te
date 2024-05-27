; clearChosenAvatar
;
; clears out a chosen character 
; in one of the 0th, 1st or 2nd position
;
; parameters
; D6.w - avatar index 
;  1  - P1C1 (on the outside)
;  2  - P1C2 (on the inside)
;  3  - P1C3
;  4  - P2C1 (on the outside)
;  5  - P2C2
;  6  - P2C3 (on the inside)

movem.l D5, $MOVEM_STORAGE

;;;;;;; SCB1: load sprite tiles
move.w #1, $3c0004 ; VRAMMOD=1

;; figure out the vram address based on passed in avatar index
bsr calcVramAddress
move.w D5, $3c0000 ; VRAMADDR to SCB1, sprite si

;;;;;;;; column 1 ;;;;;;;;;;;
;; tile 1
move.w #0, $3c0002 ; lsb of tile
move.w #0, $3c0002 ; palette/etc of tile
;; tile 2
move.w #0, $3c0002 ; lsb of tile
move.w #0, $3c0002 ; palette/etc of tile

;;;;;;;; column 2 ;;;;;;;;;;;
;; first move to the next sprite
addi.w #64, D5
move.w D5, $3c0000 ; VRAMADDR to SCB1, sprite si
;; now push the data across
;; tile 1
move.w #0, $3c0002 ; lsb of tile
move.w #0, $3c0002 ; palette/etc of tile
;; tile 2
move.w #0, $3c0002 ; lsb of tile
move.w #0, $3c0002 ; palette/etc of tile

movem.l $MOVEM_STORAGE, D5

rts


;;; SUBROUTINES ;;;;;

;; calcVramAddress
;; given 1-6, determines where in vram to start placing the tiles using the grid si
;;
;; parameters
;; D6.w - avatar index, 1 through 6
;; returns
;; D5.w - the vram address for the left upper corner tile of the avatar
;;
;; TODO: this was copied verbatim from renderChosenAvatar

calcVramAddress:
move.w #$GRID_IMAGE_SI, D5
cmpi.w #1, D6
beq calcVramAddress_doOneIndex
cmpi.w #2, D6
beq calcVramAddress_doTwoIndex
cmpi.w #3, D6
beq calcVramAddress_doThreeIndex
cmpi.w #4, D6
beq calcVramAddress_doFourIndex
cmpi.w #5, D6
beq calcVramAddress_doFiveIndex
bra calcVramAddress_doSixIndex

calcVramAddress_doOneIndex:
addi.w #1, D5 ; move foward one column
bra calcVramAddress_finishCalc

calcVramAddress_doTwoIndex:
addi.w #3, D5 ; move foward three columns
bra calcVramAddress_finishCalc

calcVramAddress_doThreeIndex:
addi.w #5, D5 ; move foward five columns
bra calcVramAddress_finishCalc

calcVramAddress_doFourIndex:
addi.w #15, D5 ; move foward 15 columns, clear to outside right avatar
bra calcVramAddress_finishCalc

calcVramAddress_doFiveIndex:
addi.w #13, D5 ; move foward 13 columns, clear to center right avatar
bra calcVramAddress_finishCalc

calcVramAddress_doSixIndex:
addi.w #11, D5 ; move foward 11 columns, clear to inner right avatar

calcVramAddress_finishCalc:
lsl.w #6, D5 ; multiple the SI by 64, to get to first tile's vram address
addi.w #18, D5 ; now go down 9 tiles, this is where the corner address is

rts






