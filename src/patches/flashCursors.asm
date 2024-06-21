;;; flashCursors
;;;
;;; makes the cursors flash by swapping their tiles black<->white

move.w #1, $3c0004 ; VRAMMOD=1

btst #0, $PLAY_MODE
beq doP1AsCpu
;; player one is playing
btst #1, $THROTTLE_COUNTER
beq p1CopyBlack

move.w #$P1_CURSOR_LEFT_SI, D0
lea $2P1_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyOneSidePlayerTiles
move.w #$P1_CURSOR_RIGHT_SI, D0
lea $2P1_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyOneSidePlayerTiles
bra p1DoneCopy

p1CopyBlack:
move.w #$P1_CURSOR_LEFT_SI, D0
lea $2P1_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyOneSidePlayerTiles
move.w #$P1_CURSOR_RIGHT_SI, D0
lea $2P1_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyOneSidePlayerTiles

p1DoneCopy:
bra doneP1

doP1AsCpu:
;; special case, don't flash cpu cursors when the
;; player just continued. This matches KOF95
btst #6, $PLAY_MODE
bne doneP1

cmpi.b #0, $CPU_CUSTOM_TEAMS_FLAG
beq p1CpuCopyWhite_original8

p1CpuCopyWhite_custom:
btst #1, $THROTTLE_COUNTER
beq p1CpuCopyBlack_custom

move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P1_CPU_CURSOR_CUSTOM_WHITE_IMAGE, A6
bsr copyCpuTiles
bra p1CpuDoneCopy

p1CpuCopyBlack_custom:
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P1_CPU_CURSOR_CUSTOM_BLACK_IMAGE, A6
bsr copyCpuTiles
bra p1CpuDoneCopy

p1CpuCopyWhite_original8:
btst #1, $THROTTLE_COUNTER
beq p1CpuCopyBlack_original8

move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P1_CPU_CURSOR_ORIGINAL8_WHITE_IMAGE, A6
bsr copyCpuTiles
bra p1CpuDoneCopy

p1CpuCopyBlack_original8:
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P1_CPU_CURSOR_ORIGINAL8_BLACK_IMAGE, A6
bsr copyCpuTiles

p1CpuDoneCopy:
bra doneP1




doneP1:

btst #1, $PLAY_MODE
beq doP2AsCpu
;; player two is playing
btst #1, $THROTTLE_COUNTER
beq p2CopyBlack

move.w #$P2_CURSOR_LEFT_SI, D0
lea $2P2_CURSOR_LEFT_WHITE_IMAGE, A6
bsr copyOneSidePlayerTiles
move.w #$P2_CURSOR_RIGHT_SI, D0
lea $2P2_CURSOR_RIGHT_WHITE_IMAGE, A6
bsr copyOneSidePlayerTiles
bra p2DoneCopy

p2CopyBlack:
move.w #$P2_CURSOR_LEFT_SI, D0
lea $2P2_CURSOR_LEFT_BLACK_IMAGE, A6
bsr copyOneSidePlayerTiles
move.w #$P2_CURSOR_RIGHT_SI, D0
lea $2P2_CURSOR_RIGHT_BLACK_IMAGE, A6
bsr copyOneSidePlayerTiles

p2DoneCopy:
bra doneP2

doP2AsCpu:
;; special case, don't flash cpu cursors when the
;; player just continued. This matches KOF95
btst #6, $PLAY_MODE
bne doneP2

cmpi.b #0, $CPU_CUSTOM_TEAMS_FLAG
beq p2CpuCopyWhite_original8

p2CpuCopyWhite_custom:
btst #1, $THROTTLE_COUNTER
beq p2CpuCopyBlack_custom

move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P2_CPU_CURSOR_CUSTOM_WHITE_IMAGE, A6
bsr copyCpuTiles
bra p2CpuDoneCopy

p2CpuCopyBlack_custom:
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P2_CPU_CURSOR_CUSTOM_BLACK_IMAGE, A6
bsr copyCpuTiles
bra p2CpuDoneCopy

p2CpuCopyWhite_original8:
btst #1, $THROTTLE_COUNTER
beq p2CpuCopyBlack_original8

move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P2_CPU_CURSOR_ORIGINAL8_WHITE_IMAGE, A6
bsr copyCpuTiles
bra p2CpuDoneCopy

p2CpuCopyBlack_original8:
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
lea $2P2_CPU_CURSOR_ORIGINAL8_BLACK_IMAGE, A6
bsr copyCpuTiles

p2CpuDoneCopy:
bra doneP2

doneP2:
done:
rts


;;;; SUBROUTINES

;;; copyOneSidePlayerTiles
;;;
;;; Takes the tiles that make up an one half of a player cursor and copies them into vram
;;;
;;; parameters
;;; D0: sprite index
;;; A6: pointer to image
copyOneSidePlayerTiles:

adda.w #4, A6 ; move past the width and height
lsl.w #6, D0 ; si * 64, since in SCB1 each sprite is 64 words
move.w D0, $3c0000 ; VRAMADDR to SCB1, sprite si
;; copy all the tiles in
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
rts


;;; copyCpuTiles
;;;
;;; Takes the tiles that make up an entire cpu cursor (original or custom) and copies them into vram
;;;
;;; parameters
;;; D0: sprite index
;;; A6: pointer to image
copyCpuTiles:

move.w #5, D4 ; dbra counter
adda.w #4, A6 ; move past the width and height
lsl.w #6, D0 ; si * 64, since in SCB1 each sprite is 64 words
copyCpuTiles_renderColumn:
move.w D0, $3c0000 ; VRAMADDR to SCB1, sprite si
;; copy all the tiles in
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
move.w (A6)+, $3c0002
;; one column done, now to move onto the next one
adda.w #4, A6 ; move past SCB3 and SCB4
addi.w #64, D0 ; move to the next sprite vram address
dbra D4, copyCpuTiles_renderColumn
rts
