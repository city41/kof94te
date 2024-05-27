; renderChosenAvatar
;
; Places a chosen character avatar on p1 or p2 side,
; in one of the 0th, 1st or 2nd position
;
; parameters
; D4.b - palette flag (0 = reg, 1 = alt)
; D6.w - avatar index 
;  1  - P1C1 (on the outside)
;  2  - P1C2 (on the inside)
;  3  - P1C3
;  4  - P2C1 (on the outside)
;  5  - P2C2
;  6  - P2C3 (on the inside)
; D7.w - character Id to be rendered

movem.l A1/A6/D5/D6, $MOVEM_STORAGE

cmpi.b #0, D4
bne setAltAvatarImg
;; set up A6 to point to the avatar data
lea $2AVATARS_IMAGE, A6 ; load the pointer to the tile data
bra setAvatarImgDone

setAltAvatarImg:
lea $2AVATARS_ALT_IMAGE, A6 ; load the pointer to the tile data

setAvatarImgDone:
move.w #16, D5              ; offset into tile data, each avatar is 16 bytes
mulu.w D7, D5               ; multiply the offset by the character id to get the right avatar
;; account for the offset to jump into an array of images
adda.w D5, A6

renderCharacter:
;;;;;;; SCB1: load sprite tiles
lea $3c0002, A1    ; VRAMRW
move.w #1, $3c0004 ; VRAMMOD=1

;; figure out the vram address based on passed in avatar index
bsr calcVramAddress
move.w D5, $3c0000 ; VRAMADDR to SCB1, sprite si

;;;;;;;; column 1 ;;;;;;;;;;;
;; tile 1
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile
;; tile 2
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile

;;;;;;;; column 2 ;;;;;;;;;;;
;; first move to the next sprite
addi.w #64, D5
move.w D5, $3c0000 ; VRAMADDR to SCB1, sprite si
;; now push the data across
;; tile 1
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile
;; tile 2
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile

movem.l $MOVEM_STORAGE, A1/A6/D5/D6

rts


;;; SUBROUTINES ;;;;;

;; calcVramAddress
;; given 1-6, determines where in vram to start placing the tiles using the grid si
;;
;; parameters
;; D6.w - avatar index, 1 through 6
;; returns
;; D5.w - the vram address for the left upper corner tile of the avatar

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






