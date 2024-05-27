;;; flashCursors
;;;
;;; makes the cursors flash by swapping their tiles black<->white

move.w #1, $3c0004 ; VRAMMOD=1

btst #0, $PLAY_MODE
beq doP1AsCpu
;; player one is playing
btst #1, $CHAR_SELECT_COUNTER
beq p1CopyBlack

move.w #$P1_CURSOR_LEFT_SI, D0
lea $2P1_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyTiles

move.w #$P1_CURSOR_RIGHT_SI, D0
lea $2P1_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyTiles
bra p1DoneCopy

p1CopyBlack:
move.w #$P1_CURSOR_LEFT_SI, D0
lea $2P1_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyTiles

move.w #$P1_CURSOR_RIGHT_SI, D0
lea $2P1_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyTiles

p1DoneCopy:
bra doneP1

doP1AsCpu:
;; player one is a cpu
btst #1, $CHAR_SELECT_COUNTER
beq p1CpuCopyBlack

;; cursor 1, left
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P1_CPU_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 1, right
move.w #$P1_CPU_CURSOR_CHAR1_RIGHT_SI, D0
lea $2P1_CPU_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 2, left
move.w #$P1_CPU_CURSOR_CHAR2_LEFT_SI, D0
lea $2P1_CPU_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 2, right
move.w #$P1_CPU_CURSOR_CHAR2_RIGHT_SI, D0
lea $2P1_CPU_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 3, left
move.w #$P1_CPU_CURSOR_CHAR3_LEFT_SI, D0
lea $2P1_CPU_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 3, right
move.w #$P1_CPU_CURSOR_CHAR3_RIGHT_SI, D0
lea $2P1_CPU_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyTiles
bra p1CpuDoneCopy

p1CpuCopyBlack:
;; cursor 1, left
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P1_CPU_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 1, right
move.w #$P1_CPU_CURSOR_CHAR1_RIGHT_SI, D0
lea $2P1_CPU_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 2, left
move.w #$P1_CPU_CURSOR_CHAR2_LEFT_SI, D0
lea $2P1_CPU_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 2, right
move.w #$P1_CPU_CURSOR_CHAR2_RIGHT_SI, D0
lea $2P1_CPU_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 3, left
move.w #$P1_CPU_CURSOR_CHAR3_LEFT_SI, D0
lea $2P1_CPU_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 3, right
move.w #$P1_CPU_CURSOR_CHAR3_RIGHT_SI, D0
lea $2P1_CPU_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyTiles

p1CpuDoneCopy:
bra doneP1




doneP1:

btst #1, $PLAY_MODE
beq doP2AsCpu
;; player two is playing
btst #1, $CHAR_SELECT_COUNTER
beq p2CopyBlack

move.w #$P2_CURSOR_LEFT_SI, D0
lea $2P2_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyTiles

move.w #$P2_CURSOR_RIGHT_SI, D0
lea $2P2_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyTiles
bra p2DoneCopy

p2CopyBlack:
move.w #$P2_CURSOR_LEFT_SI, D0
lea $2P2_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyTiles

move.w #$P2_CURSOR_RIGHT_SI, D0
lea $2P2_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyTiles

p2DoneCopy:
bra doneP2

doP2AsCpu:
;; player two is a cpu
btst #1, $CHAR_SELECT_COUNTER
beq p2CpuCopyBlack

;; cursor 1, left
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P2_CPU_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 1, right
move.w #$P2_CPU_CURSOR_CHAR1_RIGHT_SI, D0
lea $2P2_CPU_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 2, left
move.w #$P2_CPU_CURSOR_CHAR2_LEFT_SI, D0
lea $2P2_CPU_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 2, right
move.w #$P2_CPU_CURSOR_CHAR2_RIGHT_SI, D0
lea $2P2_CPU_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 3, left
move.w #$P2_CPU_CURSOR_CHAR3_LEFT_SI, D0
lea $2P2_CPU_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyTiles

;; cursor 3, right
move.w #$P2_CPU_CURSOR_CHAR3_RIGHT_SI, D0
lea $2P2_CPU_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyTiles
bra p2CpuDoneCopy

p2CpuCopyBlack:
;; cursor 1, left
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P2_CPU_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 1, right
move.w #$P2_CPU_CURSOR_CHAR1_RIGHT_SI, D0
lea $2P2_CPU_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 2, left
move.w #$P2_CPU_CURSOR_CHAR2_LEFT_SI, D0
lea $2P2_CPU_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 2, right
move.w #$P2_CPU_CURSOR_CHAR2_RIGHT_SI, D0
lea $2P2_CPU_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 3, left
move.w #$P2_CPU_CURSOR_CHAR3_LEFT_SI, D0
lea $2P2_CPU_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyTiles

;; cursor 3, right
move.w #$P2_CPU_CURSOR_CHAR3_RIGHT_SI, D0
lea $2P2_CPU_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyTiles

p2CpuDoneCopy:
bra doneP2

doneP2:
done:
rts


;;;; SUBROUTINES

;;; copyTiles
;;;
;;; This is specific to cursors, so always assumes the first three tiles of a sprite
;;;
;;; parameters
;;; D0: sprite index
;;; A6: pointer to image
copyTiles:
lsl.w #6, D0 ; si * 64, since in SCB1 each sprite is 64 words
move.w D0, $3c0000 ; VRAMADDR to SCB1, sprite si
adda.w #4, A6 ; move past the width and height

;; copy all the tiles in
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002

rts