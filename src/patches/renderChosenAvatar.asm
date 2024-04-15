; renderChosenAvatar
;
; Places a chosen character avatar on p1 or p2 side,
; in one of the 0th, 1st or 2nd position
;
; parameters
; A0 - base pointer for p1 or p2 data
; D6 - which team member 0, 1 or 2
; D7 - starting sprite index

movem.l A0/A6/D1/D5-D7, $MOVEM_STORAGE

lea $2AVATARS_IMAGE, A6 ; load the pointer to the tile data

adda.w #$PX_CHOSEN_CHAR0_OFFSET, A0 ; move forward to first chosen char
adda.w D6, A0 ; get down to the character we are focused on
adda.w D6, A0 ; twice since characters are words

move.b A0, D1 ; load the char id
move.w #24, D5              ; offset into tile data, each avatar is 24 bytes
mulu.w D1, D5               ; multiply the offset by the character id to get the right avatar

; based on which team member we are rendering, set the sprite index
lsl.w #1, D6  ; mulitply by two as each avatar is two sprites
add.w D6, D7  ; add our offset onto the base sprite index
move.w D7, D6 ; move sprite index where RENDER_STATIC_IMAGE expects it

;; parameters
;; D5: offset into the data
;; D6: starting sprite index
;; A6: pointer to tile data
jsr $2RENDER_STATIC_IMAGE

;;; now move it into place
;; parameters
;; D0: sprite index
;; D1: x
;; D2: y
move.w D6, D0 ; now move the sprite index where MOVE_SPRITE expects it
subi.w #2, D0 ; RENDER_STATIC_IMAGE moved D6 forward by 2 sprites, moving back

move.w $PXCTSX_MULTIPLIER_OFFSET(A0), D2 ; set X to 32px or -32px
mulu.w D7, D2  ; move over for 1st and 2nd char

jsr $2MOVE_SPRITE


movem.l $MOVEM_STORAGE, A0/A6/D1/D5-D7