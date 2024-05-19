;; initEmptyChosenAvatars
;;
;; inits the 12 sprites used for chosen avatars
;; puts them in the correct place, and populates them with empty tiles
;;
;; then renderChosenAvatar can just populate one with avatar tiles

;;;;;;;;;;; player 1 side, prodeed left to right ;;;;;;;;;;;;;;;;;;
;; first, left
move.w #$P1C1_SI, D6
lea $2EMPTY_CHOSEN_AVATAR, A6
move.w #0, D5 ;; no offset into the data
jsr $2RENDER_STATIC_IMAGE
move.w #$P1C1_SI, D0 ; move si where moveSprite wants it
move.w #32, D1 ; x is 32px
move.w #335, D2 ; y is 181px in the 496-y format
jsr $2MOVE_SPRITE

;; second, center
move.w #$P1C1_SI + 2, D6
lea $2EMPTY_CHOSEN_AVATAR, A6
move.w #0, D5 ;; no offset into the data
jsr $2RENDER_STATIC_IMAGE
move.w #$P1C1_SI + 2, D0 ; move si where moveSprite wants it
move.w #64, D1 ; x is 64px
move.w #335, D2 ; y is 181px in the 496-y format
jsr $2MOVE_SPRITE

;; third, right
move.w #$P1C1_SI + 4, D6
lea $2EMPTY_CHOSEN_AVATAR, A6
move.w #0, D5 ;; no offset into the data
jsr $2RENDER_STATIC_IMAGE
move.w #$P1C1_SI + 4, D0 ; move si where moveSprite wants it
move.w #96, D1 ; x is 64px
move.w #335, D2 ; y is 181px in the 496-y format
jsr $2MOVE_SPRITE
;;;;;;;;;;; end player 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;; player 2 side, prodeed right to left ;;;;;;;;;;;;;;;
;; first, right
move.w #$P2C1_SI, D6
lea $2EMPTY_CHOSEN_AVATAR, A6
move.w #0, D5 ;; no offset into the data
jsr $2RENDER_STATIC_IMAGE
move.w #$P2C1_SI, D0 ; move si where moveSprite wants it
move.w #256, D1 ; x is 256px
move.w #335, D2 ; y is 181px in the 496-y format
jsr $2MOVE_SPRITE

;; second, center
move.w #$P2C1_SI + 2, D6
lea $2EMPTY_CHOSEN_AVATAR, A6
move.w #0, D5 ;; no offset into the data
jsr $2RENDER_STATIC_IMAGE
move.w #$P2C1_SI + 2, D0 ; move si where moveSprite wants it
move.w #224, D1 ; x is 224px
move.w #335, D2 ; y is 181px in the 496-y format
jsr $2MOVE_SPRITE

;; third, left
move.w #$P2C1_SI + 4, D6
lea $2EMPTY_CHOSEN_AVATAR, A6
move.w #0, D5 ;; no offset into the data
jsr $2RENDER_STATIC_IMAGE
move.w #$P2C1_SI + 4, D0 ; move si where moveSprite wants it
move.w #192, D1 ; x is 192px
move.w #335, D2 ; y is 181px in the 496-y format
jsr $2MOVE_SPRITE
;;;;;;;;;;;; end player 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

rts