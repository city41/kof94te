; renderChosenAvatar
;
; Places a chosen character avatar on p1 or p2 side,
; in one of the 0th, 1st or 2nd position
;
; parameters
; D4.b - palette flag (0 = reg, 1 = alt)
; D6.w - sprite index
; D7.w - character Id to be rendered

movem.l A1/A6/D5/D6, $MOVEM_STORAGE

cmpi.w #$18, D7 ; is this Rugal?
bne setupForRegularCharacter
;; this is Rugal
lea $2RUGAL_CG_IMG, A6
lea $4(A6), A6 ; move forward past the width and height words
bra renderCharacter

setupForRegularCharacter:
cmpi.b #0, D4
bne setAltAvatarImg
;; set up A6 to point to the avatar data
lea $2AVATARS_IMAGE, A6 ; load the pointer to the tile data
bra setAvatarImgDone

setAltAvatarImg:
lea $2AVATARS_ALT_IMAGE, A6 ; load the pointer to the tile data

setAvatarImgDone:
lea $4(A6), A6 ; move forward past the width and height words
move.w #24, D5              ; offset into tile data, each avatar is 24 bytes
mulu.w D7, D5               ; multiply the offset by the character id to get the right avatar
;; account for the offset to jump into an array of images
adda.w D5, A6

renderCharacter:
;;;;;;; SCB1: load sprite tiles
lea $3c0002, A1    ; VRAMRW
move.w #1, $3c0004 ; VRAMMOD=1

;; set VRAMADDR to sprite index in D6
lsl.w #6, D6 ; si * 64, since in SCB1 each sprite is 64 words
move.w D6, $3c0000 ; VRAMADDR to SCB1, sprite si

;;;;;;;; column 1 ;;;;;;;;;;;
;; tile 1
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile
;; tile 2
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile

;;;;;;;; column 2 ;;;;;;;;;;;
;; first move to the next sprite
addi.w #64, D6 ; move to next sprite
move.w D6, $3c0000 ; VRAMADDR to SCB1, sprite si
;; now move to the next column's SCB1 data, skip past SCB3 and SCB4 data
move.w #4, D6
adda.w D6, A6
;; now push the data across
;; tile 1
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile
;; tile 2
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile

movem.l $MOVEM_STORAGE, A1/A6/D5/D6

rts