; reads the avatars in AVATAR_TABLE and loads them into vram

; sprite index
move.w #200, D2

;;;;;;; SCB1: load sprite tiles
lea $2AVATAR_TABLE, A0
lea $3c0002, A1    ; VRAMRW
move.w #1, $3c0004 ; VRAMMOD=1
;; set VRAMADDR to sprite D2
move.w D2, D0
lsl.w #6, D0 ; D2 * 64, since in SCB1 each sprite is 64 words
move.w D0, $3c0000 ; VRAMADDR to SCB1, sprite D2
move.w (A0)+, D1   ; how many avatars are in the table
subi.w #1, D1      ; since dbra hinges on -1 not zero
loadSpriteTiles:   ; for now, just loading the left side of the avatar
move.w (A0)+, (A1) ; lsb of tile 1
move.w (A0)+, (A1) ; palette/etc of tile 1
move.w (A0)+, (A1) ; lsb of tile 2
move.w (A0)+, (A1) ; palette/etc of tile 2
dbra D1, loadSpriteTiles ; TODO: really loop for all avatars

;;;;;;; SCB3: y position and size
lea $2AVATAR_TABLE, A0
move.w #$8200, D0  ; SCB3 base address
add.w D2, D0    ; D2 further for D2th sprite
move.w D0, $3c0000 ; VRAMADDR to SCB3, sprite 0
move.w (A0)+, D1   ; how many avatars are in the table
subi.w #1, D1      ; since dbra hinges on -1 not zero
loadSpriteYHeight: ; for now, just loading the left side of the avatar
move.w #$f302, (A1) ; Y=486, not sticky, H=2, manually calculated
dbra D1, loadSpriteYHeight

;;;;;;; scb4: x position
lea $2AVATAR_TABLE, A0
move.w #$8400, D0  ; SCB4 base address
add.w D2, D0    ; D2 further for D2th sprite
move.w D0, $3c0000 ; VRAMADDR to SCB4, sprite 0
move.w (A0)+, D1   ; how many avatars are in the table
subi.w #1, D1      ; since dbra hinges on -1 not zero
loadSpriteX: ; for now, just loading the left side of the avatar
move.w #$800, (A1) ; X=32, manually calculated
dbra D1, loadSpriteX
rts