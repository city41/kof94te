;;; continue screen init
;;; this routine clobbers the existing continue screen init routine
;;; here we set it up to show the actually chosen custom team instead of
;;; a canned team
;;; nothing to restore from the clobber

btst #0, $PLAY_MODE ; is p1 playing?
beq setForPlayerTwo
lea $P1_CHOSEN_CHAR0, A2 ; set it up to use p1 characters
move.b $108171, D0 ; load the p1 character who lost
bra doneChoosingPlayer
setForPlayerTwo:
;; CHAR2 since p2 characters are mapped in memory backwards
lea $P2_CHOSEN_CHAR2, A2 ; set it up to use p2 characters
move.b $108371, D0 ; load the p2 character who lost
doneChoosingPlayer:


;; load the character ids from the team where the game will look for them
move.b (A2), $5552(A5)
move.b $1(A2), $5553(A5)
move.b $2(A2), $5554(A5)

lea $AFTER_SCREEN_POSITION_TABLE, A0 ; get our position table set up
lea $ROM_CONTINUE_POSITION_TABLE, A1 ; get our position table set up
move.b #0, $AFTER_SCREEN_ALREADY_SET_LEFT

;; loop all three characters in
move.w #2, D4   ; our loop counter

loadCharactersLoop:
clr.w D6
move.b (A2), D6 ; get the character id into d6
;; the loser of the match is in D0
cmp.b D0, D6 ; did this character lose the match?
beq setLoser
cmpi.b #1, $AFTER_SCREEN_ALREADY_SET_LEFT
beq setRight

;;; ok this will be the left character
move.b #1, $AFTER_SCREEN_ALREADY_SET_LEFT
move.l #90, D5 ; get our X ready, left side
bra finishSettingUpChar

setRight:
move.l #230, D5 ; get our X ready, right side
bra finishSettingUpChar

setLoser:
move.l #160, D5 ; get our X ready, center
bra finishSettingUpChar

finishSettingUpChar:
add.w D6, D6 ; setting a long in memory, need to quadruple the offset
add.w D6, D6 ; setting a long in memory, need to quadruple the offset
move.l (A1, D6.w), D7 ; get the canned position which is an x word followed by a y word
andi.l #$0000ffff, D7 ; wipe out the x word
lsl.l #8, D5 ; shift X into the upper word, 8 bits at a time
lsl.l #8, D5 ; shift X into the upper word, 8 bits at a time
or.l D5, D7 ; replace the x word with our new one and leave the y word alone 
move.l D7, (A0, D6.w) ; and stick it in place so the game can read it
adda.w #1, A2 ; move to next character on team
dbra D4, loadCharactersLoop

rts