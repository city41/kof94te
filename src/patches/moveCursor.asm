;; moveCursor
;; Moves the input according to the input byte
;;
;; parameters
;; A0: base pointer to for p1 or p2 data
;; it is assumed the y index is 2 bytes after x

tst.b $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
bne done

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
btst #3, $100000 ; is the Rugal debug dip turned on?
beq doDeadSpot   ; Rugal is on, so there is no dead spot
bra notInDeadSpot

doDeadSpot:
cmpi.w#3, D1
ble notInDeadSpot
cmpi.w #5, D1
bge notInDeadSpot
cmpi.w #2, D2
bne notInDeadSpot
;; ok we are in the dead spot
;; we might have gotten here by turning on rugal dip -> nav to him -> turn it off
;; so in that case, there would be no input
;; the easiest way to get out is to jump to redoToAvoidChosenChar
;; which handles both having and not having input
bra redoToAvoidChosenChar ; uh oh, in a dead spot, run the routine again to get out

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
;; of it by setting the input to be right, and then rerun the routine
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

;; now move the sprites

;; move left sprite

;; check for nudge
move.w #0, D4 ; assume we're not nudging
cmpi.b #0, D1
beq nudgeForLeader
cmpi.b #3, D1
beq nudgeForLeader
cmpi.b #6, D1
beq nudgeForLeader
bra skipNudge


;; this is a leader, move its left cursor over 1 pixel
;; to make it look just a little better
nudgeForLeader:
move.w #1, D4

skipNudge:

;; check for Rugal nudge
move.w #0, D5  ; assume we're not nudging
btst #3, $100000 ; is the Rugal debug dip turned on?
beq skipRugalNudge ; nope, no Rugal, no nudge
; ok Rugal is on, but is the cursor at his location?
cmpi.b #4, D1
bne skipRugalNudge
cmpi.b #2, D2
bne skipRugalNudge

; we are on Rugal, need to nudge Y down
move.w #32, D5


skipRugalNudge:

mulu.w #32, D1 ; convert X index to X pixel
addi.w #15, D1  ; add the X offset (16px from edge of screen)
add.w D4, D1   ; add the nudge in
mulu.w #32, D2 ; convert Y index to Y pixel
addi.w #20, D2 ; add the Y offset (27px from top of screen)
add.w D5, D2   ; add in the Rugal nudge, if any
move.w #496, D3
sub.w D2, D3   ; D3 = D3 - D2, convert Y to the bizarre format the system wants
move.w D3, D2  ; move it back into D2, where moveSprite expects it
move.w $PX_CURSOR_SPRITEINDEX_OFFSET(A0), D0 ; load the sprite index

movem.w D1-D3, $MOVEM_STORAGE
jsr $2MOVE_SPRITE ; and finally, move the sprite
movem.w $MOVEM_STORAGE, D1-D3

;; and the right one
addi.w #19, D1
move.w $PX_CURSOR_SPRITEINDEX_OFFSET(A0), D0 ; load the sprite index
addi.w #1, D0 ; we need the sprite next door for right
jsr $2MOVE_SPRITE ; and finally, move the sprite

done:
rts