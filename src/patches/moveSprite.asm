;; moveSprite
;; updates a sprite's SCB3 and SCB4 to the new x/y location
;; only operates on one sprite, sticky sprites are recommended
;; 
;; parameters
;; D0: si
;; D1: x
;; D2: y

;;;;;;; SCB3: y position, sticky, and size
move.w #$8200, D3  ; SCB3 base address
add.w D0, D3       ; move forward by si words
move.w D3, $3c0000 ; VRAMADDR to SCB3, set to si'th sprite
move.w $3C0002, D4 ; grab the current word
andi.w #$7f, D4    ; wipe out the current Y
lsl.w #7, D2       ; take the incoming Y and shift it into position
or.w D2, D4        ; set the new Y into the word
move.w D4, $3c0002 ; put the new value back into vram

;;;;;;; SCB4: x position
move.w #$8400, D3  ; SCB4 base address
add.w D0, D3       ; move forward by si words
move.w D3, $3c0000 ; VRAMADDR to SCB4, set to si'th sprite
lsl.w #7, D1       ; move the new X into position
move.w D1, $3c0002 ; put the new value back into vram

rts


