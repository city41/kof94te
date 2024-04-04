;;; continue screen init
;;; this routine clobbers the existing continue screen init routine
;;; here we set it up to show the actualy chosen custom team instead of
;;; a canned team
;;; nothing to restore from the clobber

btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq setForPlayerTwo
lea $P1_CHOSEN_CHAR0, A2 ; set it up to use p1 characters
bra doneChoosingPlayer
setForPlayerTwo:
;; CHAR2 since p2 characters are mapped in memory backwards
lea $P2_CHOSEN_CHAR2, A2 ; set it up to use p2 characters
doneChoosingPlayer:


;; load the character ids from the team where the game will look for them
move.b (A2), $5552(A5)
move.b $1(A2), $5553(A5)
move.b $2(A2), $5554(A5)

lea $AFTER_SCREEN_POSITION_TABLE, A0 ; get our position table set up
lea $ROM_CONTINUE_POSITION_TABLE, A1 ; get our position table set up

;; first character, move to center
clr.w D6
move.b (A2), D6 ; get char0's character id
add.w D6, D6 ; setting a long in memory, need to quadruple the offset
add.w D6, D6 ; setting a long in memory, need to quadruple the offset
move.l (A1, D6.w), D7 ; get the canned position which is an x word followed by a y word
andi.l #$0000ffff, D7 ; wipe out the x word
move.l #160, D5 ; get our X ready
lsl.l #8, D5 ; shift X into the upper word, 8 bits at a time
lsl.l #8, D5 ; shift X into the upper word, 8 bits at a time
or.l D5, D7 ; replace the x word with our new one and leave the y word alone 
move.l D7, (A0, D6.w) ; and stick it in place so the game can read it

;; second character, move to left
clr.w D6
move.b $1(A2), D6 ; get char1's character id
add.w D6, D6 ; setting a long in memory, need to quadruple the offset
add.w D6, D6 ; setting a long in memory, need to quadruple the offset
move.l (A1, D6.w), D7 ; get the canned position which is an x word followed by a y word
andi.l #$0000ffff, D7 ; wipe out the x word
move.l #90, D5 ; get our X ready
lsl.l #8, D5 ; shift X into the upper word, 8 bits at a time
lsl.l #8, D5 ; shift X into the upper word, 8 bits at a time
or.l D5, D7 ; replace the x word with our new one and leave the y word alone 
move.l D7, (A0, D6.w) ; and stick it in place so the game can read it

;; third character, move to right
clr.w D6
move.b $2(A2), D6 ; get char2's character id
add.w D6, D6 ; setting a long in memory, need to quadruple the offset
add.w D6, D6 ; setting a long in memory, need to quadruple the offset
move.l (A1, D6.w), D7 ; get the canned position which is an x word followed by a y word
andi.l #$0000ffff, D7 ; wipe out the x word
move.l #230, D5 ; get our X ready
lsl.l #8, D5 ; shift X into the upper word, 8 bits at a time
lsl.l #8, D5 ; shift X into the upper word, 8 bits at a time
or.l D5, D7 ; replace the x word with our new one and leave the y word alone 
move.l D7, (A0, D6.w) ; and stick it in place so the game can read it

rts