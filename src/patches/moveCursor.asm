;; moveCursor
;; Moves the input according to the input byte
;;
;; parameters
;; D0: the input byte, typically pulled from BIOS_PXCURRENT
;; D1: the cursor's sprite index
;; A0: pointer to the words of the cursor's x index
;; A1: pointer to the words of the cursor's y index

move.w D1, D4 ; move the sprite index off to the side

move.w (A0), D1 ; load current cursor X
move.w (A1), D2 ; and Y

checkInput:
btst #$3, D0 ; is Right pressed?
beq skipIncCursorX ; it's not? skip the increment
addi.w #1, D1
cmpi.w #8, D1
ble.s skipUpperXWrap
move.w #0, D1 ; x wrapped around to zero
skipUpperXWrap:
skipIncCursorX:

btst #$2, D0 ; is Left pressed?
beq skipDecCursorX ; it's not? skip the decrement
subi.w #1, D1
cmpi.w #$ffff, D1
bne skipLowerXWrap
move.w #8, D1
skipLowerXWrap:
skipDecCursorX:

btst #$1, D0 ; is Down pressed?
beq skipIncCursorY ; it's not? skip the increment
addi.w #1, D2
cmpi.w #2, D2
ble.s skipUpperYWrap
move.w #0, D2
skipUpperYWrap:
skipIncCursorY:

btst #$0, D0 ; is Up pressed?
beq skipDecCursorY ; it's not? skip the decrement
subi.w #1, D2
cmpi.w #$ffff, D2
bne skipLowerYWrap
move.w #2, D2
skipLowerYWrap:
skipDecCursorY:

;; did the cursor land in a dead spot?
cmpi.w#2, D1
ble notInDeadSpot
cmpi.w #6, D1
bge notInDeadSpot
cmpi.w #2, D2
bne notInDeadSpot
bra checkInput ; uh oh, in a dead spot, run the routine again to get out

notInDeadSpot:


moveCursor:
move.w D1, (A0) ; save the new X
move.w D2, (A1) ; save the new Y
mulu.w #32, D1 ; convert X index to X pixel
addi.w #8, D1  ; add the X offset (8px from edge of screen)
mulu.w #32, D2 ; convert Y index to Y pixel
addi.w #53, D2 ; add the Y offset (55px from top of screen)
move.w #496, D3
sub.w D2, D3   ; D3 = D3 - D2, convert Y to the bizarre format the system wants
move.w D3, D2  ; move it back into D2, where moveSprite expects it
move.w D4, D0 ; load the sprite index
jsr $2MOVE_SPRITE ; and finally, move the sprite

rts