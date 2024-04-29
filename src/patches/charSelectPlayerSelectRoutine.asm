;; charSelectPlayerSelectRoutine
;; handles everything related to a human selecting their characters

btst #0, $PLAY_MODE ; is p1 playing?
beq skipPlayer1

move.b $BIOS_P1CHANGE, $P1_CUR_INPUT
;; the base address from which all other p1 values will derive from
lea $P1_CUR_INPUT, A0
lea $P2_CUR_INPUT, A1
bsr doSinglePlayer

skipPlayer1:
btst #1, $PLAY_MODE ; is p2 playing?
beq skipPlayer2

move.b $BIOS_P2CHANGE, $P2_CUR_INPUT
;; the base address from which all other p2 values will derive from
lea $P2_CUR_INPUT, A0
lea $P1_CUR_INPUT, A1
bsr doSinglePlayer

skipPlayer2:
rts

;;;;
;;;; SUBROUTINES BELOW
;;;;

; doSinglePlayer
; --------------
; handles character selection and cursor movement for either p1 or p2
;
; parameters
; A0: base pointer for p1 or p2 data
; A1: base pointer for other player's data
doSinglePlayer:

; how many characters have been chosen so far?
; don't let them choose more than 3

cmpi.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
beq skipChoosingChar ; if three have been chosen, don't choose more

; is this a single player game, they chose randomize when choosing their characters
; and now it's a subsequent fight? then randomize again
btst #5, $PLAY_MODE
bne doSlotMachine

; is this a single player game, and they are past the first fight? 
; then char select is just about showing who they fight next, don't
; let them do anything
btst #7, $PLAY_MODE
bne skipChoosingChar

;;;;;;;;;;;;;;;;;;; SLOT MACHINE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
doSlotMachine:
tst.b $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
beq skipSlotMachine

;; we are in the slot machine
;; this means the user chose random select and now we're just working
;; out who the randomly selected team will be over the course of about 36 frames
;; for visual effect

;; drop the counter down. When it hits 0 the slot machine will be done
subi.b #1, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)

;; now see if we are ready to save a character
cmpi.b #24, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
beq slotMachine_setupChooseChar
cmpi.b #12, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
beq slotMachine_setupChooseChar
cmpi.b #0, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
beq slotMachine_setupChooseChar
bra slotMachine_skipChooseChar
;; ready to choose the first character

slotMachine_setupChooseChar:
cmpi.b #$RANDOM_SELECT_TYPE_CHAR, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
beq slotMachine_chooseSingleChar
move.w #2, D3 ; this is team select, loop to select three chars
bra slotMachine_chooseChar
slotMachine_chooseSingleChar:
move.w #0, D3 ; this is char select, loop to select a single char

slotMachine_chooseChar:
;; take the palette flag choice they made before and restore it to D4
move.b $PX_RANDOM_SELECT_PALETTE_FLAG_CHOICE_OFFSET(A0), D4
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2
clr.w D0
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
lsl.b #1, D0 ; need to double it, as each character is a word: [char id]|[palette flag]
adda.w D0, A2   ; move forward based on how many characters are chosen
move.b (A2), D1 ; pull the chosen char back out
;; saveChar will take D1 (charId) and D4 (palette flag)
;; and do everything needed to save the character
bsr saveChar

;; now rerender the chosen avatar, in case the final palette is alternate

move.w D0, D6  ; move num of chosen characters in
subi.w #1, D6  ; but we already incremented, so it's one too big
mulu.w #2, D6
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D7
add.w D7, D6 ; add on the starting sprite index

;; parameters
;; D4.b - palette flag, already there
;; D6.w - sprite index
;; D7.w - character id
clr.w D7
move.b D1, D7
jsr $2RENDER_CHOSEN_AVATAR
dbra D3, slotMachine_chooseChar ; is this team select? go back and keep saving chars then


slotMachine_skipChooseChar:
;; not ready to choose, need to keep the randomization going
;; we'll jump to one of the randomization routines depending on
;; which type the player chose
cmpi.b #$RANDOM_SELECT_TYPE_CHAR, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
beq slotMachine_doCharRandomSelect
jsr $2TEAM_RANDOM_SELECT
bra slotMachine_done

slotMachine_doCharRandomSelect:
jsr $2CHAR_RANDOM_SELECT

slotMachine_done:
rts
;;;;;;;;;;;;;;;;;;; END SLOT MACHINE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
skipSlotMachine:

;;;;;;;;;;;;;;;;;;; CHECK IF PLAYER CHOSE A CHARACTER ;;;;;;;;;;;;;;
move.b $PX_CUR_INPUT_OFFSET(A0), D0 ; load effectively BIOS_PXCHANGE
btst #$4, D0 ; is A pressed?
bne choosingCharRegPalette ; yes? go on and set the character, regular palette
btst #$5, D0 ; What about B?
bne choosingCharRegPalette ; yes? go on and set the character, regular palette
btst #$6, D0 ; Now C
bne choosingCharAltPalette ; yes? set the character and alternate palette
btst #$7, D0 ; And finally D
bne choosingCharAltPalette ; yes? set the character and alternate palette
bra skipChoosingChar ; nothing is pressed? then don't choose a character

choosingCharRegPalette:
move.b #0, D4 ; move the regular palette flag value into D4
bra choosingChar

choosingCharAltPalette:
move.b #1, D4 ; move the alternate palette flag value into D4
bra choosingChar

choosingChar:
; and then from here just set the character
;; first, figure out the character id based on cursor's location
move.w $PX_CURSOR_X_OFFSET(A0), D0
move.w $PX_CURSOR_Y_OFFSET(A0), D1
mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid

cmpi.b #21, D1 ; are they on the left random select?
beq chooseCharRandomSelect
cmpi.b #23, D1 ; are they on the right random select?
beq chooseTeamRandomSelect
bra skipChooseRandomSelect

chooseCharRandomSelect:
;; first remember the palette flag choice, as we won't apply it for several frames
;; it will also be used for future randomizations in single player mode
move.b D4, $PX_RANDOM_SELECT_PALETTE_FLAG_CHOICE_OFFSET(A0)
;; set the flag so in subsequent single player fights we can re-random
move.b #$RANDOM_SELECT_TYPE_CHAR, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
;; remember how many characters were not randomly selected, so subsequent re-randomizes
;; will only rerandom the random characters
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D4
move.b D4, $PX_NUM_NON_RANDOM_CHARS_OFFSET(A0)

;; set up the countdown which will allow gradually choosing the characters
;; set the countdown based on number of characters chosen. More characters -> shorter countdown
;; 0 characters chosen -> countdown = 36
;; 1 character chosen -> countdown = 24
;; 2 character chosen -> countdown = 12
move.b #36, D5
clr.w D4
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D4
mulu.w #12, D4
sub.b D4, D5
move.b D5, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
bra skipChoosingChar

chooseTeamRandomSelect:
;; first remember the palette flag choice, as we won't apply it for several frames
;; it will also be used for future randomizations in single player mode
move.b D4, $PX_RANDOM_SELECT_PALETTE_FLAG_CHOICE_OFFSET(A0)
;; set the flag so in subsequent single player fights we can re-random
move.b #$RANDOM_SELECT_TYPE_TEAM, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
;; since this is whole team random select, set num of non-random chars to zero
move.b #0, $PX_NUM_NON_RANDOM_CHARS_OFFSET(A0)
move.b #0, $PX_NUM_CHOSEN_CHARS_OFFSET(A0) ; ensure any saved characters are overwritten
;; since this whole team random select, set the timer lower than char select
move.b #11, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
bra skipChoosingChar

skipChooseRandomSelect:
cmpi.b #22, D1 ; are they on Rugal (with debug dip on?)
bne skipChooseRugal
;; they chose Rugal
move.b #0, $PX_NUM_CHOSEN_CHARS_OFFSET(A0) ; first reset back to an unchosen team
move.b #$18, D1
bsr saveChar ; save the first Rugal
move.b #$19, D1
bsr saveChar ; save the second Rugal
move.b #$19, D1
bsr saveChar ; save the third Rugal
;; now render him as the first chosen char
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6
move.w #$18, D7
move.b #0, D4 ; palette flag, this is correct as Rugal doesn't have an alternate avatar
jsr $2RENDER_CHOSEN_AVATAR
;; now clear out the second chosen char
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6
addi.w #2, D6
jsr $2CLEAR_CHOSEN_AVATAR
;; now clear out the third chosen char
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6
addi.w #4, D6
jsr $2CLEAR_CHOSEN_AVATAR
;; and done, Rugal is all set
bra skipChoosingChar

skipChooseRugal:
lea $2GRID_TO_CHARACTER_ID, A3
adda.w D1, A3
move.b (A3), D1 ; character Id from grid is now in D1

bsr saveChar

;;; now render the newly chosen character into chosen team area
;; set up the sprite index based on character index
move.w D0, D6  ; move num of chosen characters in
subi.w #1, D6  ; but we already incremented, so it's one too big
mulu.w #2, D6
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D7
add.w D7, D6 ; add on the starting sprite index

;; parameters
;; D4.b - palette flag
;; D6.w - sprite index
;; D7.w - character id
clr.w D7
move.b D1, D7
jsr $2RENDER_CHOSEN_AVATAR

skipChoosingChar:

;;;;;;;;;;;;;;;; PLAYER CURSOR ;;;;;;;;;;;;;;;;;;;;

btst #7, $PLAY_MODE
bne skipCursor ; if past first fight, never show the player's cursor
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
cmpi.b #3, D0
beq doHidePlayerCursor ; all three chosen? no need for a cursor anymore

jsr $2MOVE_CURSOR
bra donePlayerCursor

doHidePlayerCursor:
bsr hidePlayerCursor

skipCursor:
donePlayerCursor:

;;;;;;;;;;;;;;;;;;; RANDOM SELECT ;;;;;;;;;;;;;;;;;;;;;;;;;
;; are they currently hovering on a random select space?
move.w $PX_CURSOR_X_OFFSET(A0), D0
move.w $PX_CURSOR_Y_OFFSET(A0), D1

mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid


cmpi.w #21, D1 ; are they on the left random select space?
beq doCharRandomSelect
cmpi.w #23, D1 ; are they on the right random select space?
beq doTeamRandomSelect
bra doClearRandomSelect

doCharRandomSelect:
jsr $2CHAR_RANDOM_SELECT
bra doneRandomSelect

doTeamRandomSelect:
jsr $2TEAM_RANDOM_SELECT
bra doneRandomSelect

doClearRandomSelect:
;; if they aren't on random select, then possibly they were before
;; need to clean up the left behind random avatars
bsr clearRandomSelect

doneRandomSelect:
;;;;;;;;;;;;;;;;;;; END RANDOM SELECT ;;;;;;;;;;;;;;;;;;;;;;;;;



done:
; for the character currently under the cursor, show their name on the fix layer
jsr $2RENDER_CUR_FOCUSED_CHAR_NAME

rts




;; flipPaletteFlagIfNeeded
;; -----
;; given the incoming character and palette flag, switches to the other palette flag if:
;; - this is versus mode
;; - and the other player has already chosen this char/palette
;;
;; parameters
;; ----------
;; D1: the character id that was just chosen
;; D4: the palette flag that was chosen
;; A1: base pointer for other player's data
;; 
;; return
;; -----
;; D4: the palette flag, flipped if needed

flipPaletteFlagIfNeeded:
;; first see if this is versus mode
btst #0, $PLAY_MODE
beq flipPaletteFlagIfNeeded_done ; p1 is not playing, not versus mode
btst #1, $PLAY_MODE
beq flipPaletteFlagIfNeeded_done ; p2 is not playing, not versus mode
;; this is versus mode
cmpi.b #0, $PX_NUM_CHOSEN_CHARS_OFFSET(A1)
beq flipPaletteFlagIfNeeded_done ; other player has not chosen any chars yet, no need to flip

;; is their first character what we just chose?
flipPaletteFlagIfNeeded_checkFirstChar:
lea $PX_CHOSEN_CHAR0_OFFSET(A1), A6
cmp.b (A6), D1
bne flipPaletteFlagIfNeeded_checkSecondChar ; first character is someone else, move on
adda.w #1, A6 ; move forward to the palette flag
cmp.b (A6), D4 ; are the palettes the same?
bne flipPaletteFlagIfNeeded_done ; both teams chose the same char, but diff palettes, we are good
bra doFlip ; both teams chose same char, same palette, need to flip

flipPaletteFlagIfNeeded_checkSecondChar:
lea $PX_CHOSEN_CHAR1_OFFSET(A1), A6
cmp.b (A6), D1
bne flipPaletteFlagIfNeeded_checkThirdChar ; second character is someone else, move on
adda.w #1, A6 ; move forward to the palette flag
cmp.b (A6), D4 ; are the palettes the same?
bne flipPaletteFlagIfNeeded_done ; both teams chose the same char, but diff palettes, we are good
bra doFlip ; both teams chose same char, same palette, need to flip

flipPaletteFlagIfNeeded_checkThirdChar:
lea $PX_CHOSEN_CHAR2_OFFSET(A1), A6
cmp.b (A6), D1
bne flipPaletteFlagIfNeeded_done ; third character is someone else, we are good
adda.w #1, A6 ; move forward to the palette flag
cmp.b (A6), D4 ; are the palettes the same?
bne flipPaletteFlagIfNeeded_done ; both teams chose the same char, but diff palettes, we are good
bra doFlip ; both teams chose same char, same palette, need to flip

doFlip:
move.b #1, D2 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
sub.b D4, D2  ; move the answer to D4, where it is expected
move.b D2, D4

flipPaletteFlagIfNeeded_done:
rts

;; clearRandomSelect
;; clears out any avatars in chosen area that are unchosen
;; this cleans up the random avatars that randomSelect may have placed there
clearRandomSelect:
cmpi.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
beq clearRandomSelect_done ; chose three characters? don't clear then

move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6 ; load si
add.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D6 ; move si forward to first unchosen character
add.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D6 ; twice since avatars are 2 sprites each
move.w #2, D4
sub.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D4 ; decrement D4 by number already chosen

clearRandomSelect_clearChar:
;; parameters
;; D6.w - sprite index
move.w D6, D3
jsr $2CLEAR_CHOSEN_AVATAR
move.w D3, D6

addi.w #2, D6 ; move to next avatar
dbra D4, clearRandomSelect_clearChar

clearRandomSelect_done:
rts

;; saveChar
;; saves the current character into the team
;;
;; paramters
;; A0: player base data
;; D1: chosen char id to save
;; D4: chosen palette flag to save
saveChar:
; now set the chosen char id
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2
clr.w D0
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
lsl.b #1, D0 ; need to double it, as each character is a word: [char id]|[palette flag]
adda.w D0, A2   ; move forward based on how many characters are chosen
move.b D1, (A2) ; set the chosen character

; then set their palette flag
bsr flipPaletteFlagIfNeeded
adda.w #1, A2 ; move forward one byte to the palette flag
move.b D4, (A2) ; set the palette flag (either 0 for reg, or 1 for alt)

; now store how many characters have been chosen
lsr.b #1, D0 ; and de-double it, as we need to store how many chars are selected
addi.b #1, D0
move.b D0, $PX_NUM_CHOSEN_CHARS_OFFSET(A0) ; increment number of chosen characters
move.b #$61, $320000  ; play the sound effect

rts

;; hides the player's cursor by moving it off screen
hidePlayerCursor:
;; hide the left cursor
move.w $PX_CURSOR_SPRITEINDEX_OFFSET(A0), D0 ; load the cursor's sprite index
move.w #0, D1  ; x
move.w #272, D2 ; set y to 224, moving cursor off screen
jsr $2MOVE_SPRITE
;; and now the right
move.w $PX_CURSOR_SPRITEINDEX_OFFSET(A0), D0 ; load the cursor's sprite index
addi.w #1, D0 ; bump to next sprite
move.w #0, D1  ; x
move.w #272, D2 ; set y to 224, moving cursor off screen
jsr $2MOVE_SPRITE
rts