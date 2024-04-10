;; moveCursor
;; Moves the input according to the input byte
;;
;; parameters
;; D0: the cursor's sprite index
;; A0: base pointer to for p1 or p2 data
;; it is assumed the y index is 2 bytes after x

move.w D0, D6 ; move the sprite index off to the side

move.b $PX_CUR_INPUT_OFFSET(A0), D0 ; move current input into D0
move.w $PX_CURSOR_X_OFFSET(A0), D1 ; load current cursor X
move.w $PX_CURSOR_Y_OFFSET(A0), D2 ; and Y

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
move.b #$60, $320000  ; play the sound effect
addi.w #1, D2
cmpi.w #2, D2
ble.s skipUpperYWrap
move.w #0, D2
skipUpperYWrap:
skipIncCursorY:

btst #$0, D0 ; is Up pressed?
beq skipDecCursorY ; it's not? skip the decrement
move.b #$60, $320000  ; play the sound effect
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

;; is the cursor on a character the player already chose? If so, run the routine again to get out
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D4 ; load how many characters they have chosen so far
beq moveCursor ; none chosen? then no need to check if cursor is on a chosen character

;; from cursor -> char id of the character the cursor is over
move.w D2, D3 ;; copy Y to D3 as we are about to clobber it with multiply
mulu.w #9, D3 ; multiply the Y copy by 9
add.w D1, D3  ; then add X to get the index into the grid
lea $2GRID_TO_CHARACTER_ID, A1
adda.w D3, A1 ; add on the current index to the address to offset into it
move.b (A1), D3 ; character Id from grid is now in D3

move.b $PX_CHOSEN_CHAR0_OFFSET(A0), D5
cmp.b D3, D5 ; are they over their first chosen char?
beq redoToAvoidChosenChar ; they are, uh oh, run the routine again to get out
; they are not over their first char, have they chosen their second?
cmpi.b #1, D4
ble moveCursor ; they haven't, so we are done
move.b $PX_CHOSEN_CHAR1_OFFSET(A0), D5
cmp.b D3, D5 ; are they over their second chosen char?
beq redoToAvoidChosenChar ; they are, uh oh, run the routine again to get out
; they are not over their second char, so we are done
; no need to check the third, if they have chosen three chars, their cursor disappears
bra moveCursor

;; if we get in here, they are currently over a character they have chosen, get them off
;; of it by setting the input to be down, and then rerun the routine
redoToAvoidChosenChar:
btst #0, D0 ; did the player push up?
bne checkInput ; they did press up, so just use it again
btst #1, D0 ; did they player push down?
bne checkInput ; they did press down, so just use it again
btst #2, D0 ; did they player push left?
bne checkInput ; they did press left, so just use it again
btst #3, D0 ; did they player push right?
bne checkInput ; they did press right, so just use it again
move.b #8, D0 ; no current input, so set it to right
bra checkInput ; and rerun the routine with right
; I think down is better, but KOF95 used right...


moveCursor:
move.w D1, $PX_CURSOR_X_OFFSET(A0) ; save the new X
move.w D2, $PX_CURSOR_Y_OFFSET(A0) ; save the new Y
mulu.w #32, D1 ; convert X index to X pixel
addi.w #16, D1  ; add the X offset (16px from edge of screen)
mulu.w #32, D2 ; convert Y index to Y pixel
addi.w #54, D2 ; add the Y offset (54px from top of screen)
move.w #496, D3
sub.w D2, D3   ; D3 = D3 - D2, convert Y to the bizarre format the system wants
move.w D3, D2  ; move it back into D2, where moveSprite expects it
move.w D6, D0 ; load the sprite index
jsr $2MOVE_SPRITE ; and finally, move the sprite

rts