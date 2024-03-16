; Given a pointer to a static image, such as the one in bg_oceans.asm,
; writes to vram such that the image is on the screen
;
; inputs
; ------
; d6: starting sprite index (si)
; A6: address of static image (sa)

;;;;;;; SCB1: load sprite tiles
lea $3c0002, A1    ; VRAMRW
move.w #1, $3c0004 ; VRAMMOD=1

move.w (A6)+, D1   ; how wide the image is, in tiles/sprites
move.w (A6)+, D2   ; how tall the image is, in tiles
move.w D2, D3      ; save height

subi.w #1, D1      ; since dbra hinges on -1 not zero
loadSprite:
;; set VRAMADDR to sprite index in D6
move.w D6, D0
lsl.w #6, D0 ; si * 64, since in SCB1 each sprite is 64 words
move.w D0, $3c0000 ; VRAMADDR to SCB1, sprite si

subi.w #1, D2      ; since dbra hinges on -1 not zero
loadSpriteTiles:   ; for now, just loading one column
move.w (A6)+, (A1) ; lsb of tile
move.w (A6)+, (A1) ; palette/etc of tile
dbra D2, loadSpriteTiles

;;;;;;; SCB3: y position and size
move.w #$8200, D0  ; SCB3 base address
add.w D6, D0    ; move forward by si words
move.w D0, $3c0000 ; VRAMADDR to SCB3, set to si'th sprite
move.w (A6)+, (A1) ; throw the scb3 word up there

;;;;;;; scb4: x position
move.w #$8400, D0  ; SCB4 base address
add.w D6, D0    ; move forward by si words
move.w D0, $3c0000 ; VRAMADDR to SCB4, set to si'th sprite
move.w (A6)+, (A1) ; X=32, manually calculated
addi.w #1, D6      ; go to next sprite index
move.w D3, D2      ; set height back to loop another column
dbra D1, loadSprite

rts