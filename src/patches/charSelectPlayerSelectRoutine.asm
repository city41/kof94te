;; charSelectPlayerSelectRoutine
;; handles everything related to a human selecting their characters

;; don't allow players to do anything during HERE COMES CHALLENGER
cmpi.b #1, $IN_HERE_COMES_CHALLENGER
beq skipPlayer2

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
bne threeCharsNotChosen ; if three have been chosen, don't choose more
bsr hidePlayerCursor
move.b #1, $PX_IS_READY_OFFSET(A0) ; let main know we are ready to move forward
bra skipChoosingChar

threeCharsNotChosen:
move.b #0, $PX_IS_READY_OFFSET(A0) ; play it safe and clear the flag


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
cmpi.b #20, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
beq slotMachine_setupChooseChar
cmpi.b #9, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
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

;; now we either need to use the real chosen char memory or the temp one
;; depending on if this is team or char select
cmpi.b #$RANDOM_SELECT_TYPE_CHAR, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
beq slotMachine_loadStartingAddressChar
;; this is team random, go off the temp ids set aside just for it
lea $PX_TEAM_RANDOM_TEMP_CHOSEN_CHARS_OFFSET(A0), A2
bra slotMachine_doneLoadStartingAddress

slotMachine_loadStartingAddressChar:
;; this is char random, use the real chose char ids
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A2

slotMachine_doneLoadStartingAddress:
clr.w D0
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
adda.w D0, A2   ; move forward based on how many characters are chosen
move.b (A2), D1 ; pull the chosen char back out
;; saveChar will take D1 (charId) and D4 (palette flag)
;; and do everything needed to save the character
cmpi.b #$RANDOM_SELECT_TYPE_CHAR, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
beq slotMachine_turnOnChoiceSoundEffect
cmpi.b #0, D3 ; this is team select, have we chosen the whole team?
beq slotMachine_turnOnChoiceSoundEffect ; we have? do sfx
move.b #$ff, D6 ; this is team select, but whole team has not been chosen, dont do the sound effect yet
bra slotMachine_doneChoiceSoundEffect
slotMachine_turnOnChoiceSoundEffect:
move.b #$0, D6 ; this is char select, or final team select, do sound effect
slotMachine_doneChoiceSoundEffect:
bsr saveChar
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
bra doPlayerCursor
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
move.b #$0, D6 ; do the sfx
bsr saveChar ; save the first Rugal
move.b #$19, D1
move.b #$ff, D6 ; skip the sfx
bsr saveChar ; save the second Rugal
move.b #$19, D1
move.b #$ff, D6 ; skip the sfx
bsr saveChar ; save the third Rugal

bra skipChoosingChar

skipChooseRugal:
lea $2GRID_TO_CHARACTER_ID, A3
adda.w D1, A3
move.b (A3), D1 ; character Id from grid is now in D1

bsr saveChar

skipChoosingChar:


;;;;;;;;;;;;;;;;;;; RANDOM SELECT ;;;;;;;;;;;;;;;;;;;;;;;;;
;; are they currently hovering on a random select space?
btst #7, $PLAY_MODE
bne doneRandomSelect ; no need to deal with random select on subsequent fights

move.w $PX_CURSOR_X_OFFSET(A0), D0
move.w $PX_CURSOR_Y_OFFSET(A0), D1

mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid


cmpi.w #21, D1 ; are they on the left random select space?
beq doCharRandomSelect
cmpi.w #23, D1 ; are they on the right random select space?
beq doTeamRandomSelect
bra noRandomSelect

doCharRandomSelect:
move.b #$RANDOM_SELECT_TYPE_CHAR, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
jsr $2CHAR_RANDOM_SELECT
bra doneRandomSelect

doTeamRandomSelect:
move.b #$RANDOM_SELECT_TYPE_TEAM, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
jsr $2TEAM_RANDOM_SELECT
bra doneRandomSelect

noRandomSelect:
move.b #$RANDOM_SELECT_TYPE_NONE, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)

doneRandomSelect:

;;;;;;;;;;;;;;;;;;; END RANDOM SELECT ;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; PLAYER CURSOR ;;;;;;;;;;;;;;;;;;;;

doPlayerCursor:

btst #7, $PLAY_MODE
bne skipCursor ; if past first fight, never show the player's cursor
cmpi.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
beq skipCursor ; all three chosen? no need for a cursor anymore

jsr $2MOVE_CURSOR
skipCursor:

done:
bsr renderChosenAvatars
;; render whatever choices the player has currently made down into the chosen area
;; this accounts for all possibilities: normal, rugal, random, etc
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
cmpi.b #3, $PLAY_MODE
bne flipPaletteFlagIfNeeded_done ; not versus mode
cmpi.b #0, $PX_NUM_CHOSEN_CHARS_OFFSET(A1)
beq flipPaletteFlagIfNeeded_done ; other player has not chosen any chars yet, no need to flip

;; is their first character what we just chose?
flipPaletteFlagIfNeeded_checkFirstChar:
cmpi.b #0, $PX_NUM_CHOSEN_CHARS_OFFSET(A1)
beq flipPaletteFlagIfNeeded_done ; other player has not chosen any characters, so no flipping needed
lea $PX_CHOSEN_CHAR0_OFFSET(A1), A6
cmp.b (A6), D1
bne flipPaletteFlagIfNeeded_checkSecondChar ; first character is someone else, move on
adda.w #3, A6 ; move forward to the palette flag
cmp.b (A6), D4 ; are the palettes the same?
bne flipPaletteFlagIfNeeded_done ; both teams chose the same char, but diff palettes, we are good
bra doFlip ; both teams chose same char, same palette, need to flip

flipPaletteFlagIfNeeded_checkSecondChar:
cmpi.b #1, $PX_NUM_CHOSEN_CHARS_OFFSET(A1)
ble flipPaletteFlagIfNeeded_done ; other player has not chosen two characters, so no flipping needed
lea $PX_CHOSEN_CHAR0_OFFSET(A1), A6
adda.w #1, A6 ; move to their second character
cmp.b (A6), D1
bne flipPaletteFlagIfNeeded_checkThirdChar ; second character is someone else, move on
adda.w #3, A6 ; move forward to the palette flag
cmp.b (A6), D4 ; are the palettes the same?
bne flipPaletteFlagIfNeeded_done ; both teams chose the same char, but diff palettes, we are good
bra doFlip ; both teams chose same char, same palette, need to flip

flipPaletteFlagIfNeeded_checkThirdChar:
cmpi.b #2, $PX_NUM_CHOSEN_CHARS_OFFSET(A1)
ble flipPaletteFlagIfNeeded_done ; other player has not chosen three characters, so no flipping needed
lea $PX_CHOSEN_CHAR0_OFFSET(A1), A6
adda.w #2, A6 ; move to their third character
cmp.b (A6), D1
bne flipPaletteFlagIfNeeded_done ; third character is someone else, we are good
adda.w #3, A6 ; move forward to the palette flag
cmp.b (A6), D4 ; are the palettes the same?
bne flipPaletteFlagIfNeeded_done ; both teams chose the same char, but diff palettes, we are good
bra doFlip ; both teams chose same char, same palette, need to flip

doFlip:
move.b #1, D2 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
sub.b D4, D2  ; move the answer to D4, where it is expected
move.b D2, D4

flipPaletteFlagIfNeeded_done:
rts

;; saveChar
;; saves the current character into the team
;;
;; paramters
;; A0: player base data
;; D1: chosen char id to save
;; D4: chosen palette flag to save
;; D5: skip sound effect if ff
saveChar:
; now set the chosen char id
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A2
clr.w D0
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
adda.w D0, A2   ; move forward based on how many characters are chosen
move.b D1, (A2) ; set the chosen character

; then set their palette flag
bsr flipPaletteFlagIfNeeded
adda.w #3, A2 ; move forward three bytes to the palette flag
move.b D4, (A2) ; set the palette flag (either 0 for reg, or 1 for alt)

; now store how many characters have been chosen
addi.b #1, D0
move.b D0, $PX_NUM_CHOSEN_CHARS_OFFSET(A0) ; increment number of chosen characters
cmpi.b #$ff, D5
beq saveChar_skipSoundEffect
move.b #$61, $320000  ; play the sound effect
saveChar_skipSoundEffect:

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

; renderChosenAvatars
; renders the chosen avatars for the player in A0
; handles rugal and clearing avatars as needed
renderChosenAvatars:
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A2
cmpi.b #$18, (A2) ; did they choose rugal?
beq renderChosenAvatars_rugal
cmpi.b #$RANDOM_SELECT_TYPE_CHAR, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
beq renderChosenAvatars_charRandomSelect
cmpi.b #$RANDOM_SELECT_TYPE_TEAM, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
beq renderChosenAvatars_teamRandomSelect
bra renderChosenAvatars_noRandomSelect

renderChosenAvatars_rugal:
;; this should be either 0 (no character has actually been selected, Rugals' id is stale data)
;; or 3 (player has chosen Rugal, so their team is 18/19/19)
;; in that case, we need to go down to 1
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D3
cmpi.b #0, D3
beq renderChosenAvatar_rugal_skipClamp
move.b #1, D3 ; ok it's too big, clamp back to 1
renderChosenAvatar_rugal_skipClamp:
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A2 ; draw from real chosen chars
bra renderChosenAvatars_renderAvatars

renderChosenAvatars_charRandomSelect:
move.b #3, D3 ; this is random, so always render 3 avatars
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A2 ; draw from real chosen chars
bra renderChosenAvatars_renderAvatars

renderChosenAvatars_teamRandomSelect:
move.b #3, D3 ; this is random, so always render 3 avatars
lea $PX_TEAM_RANDOM_TEMP_CHOSEN_CHARS_OFFSET(A0), A2 ; draw from the temp chosen chars
bra renderChosenAvatars_renderAvatars

renderChosenAvatars_noRandomSelect:
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D3 ; this is not random, render the actual number chosen
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A2 ; draw from real chosen chars
bra renderChosenAvatars_renderAvatars

renderChosenAvatars_renderAvatars:
clr.b D5 ; loop counter
move.w $PX_CHOSEN_TEAM_AVATARINDEX_OFFSET(A0), D6 ; load the player's starting avatar index (1 or 4)

renderChosenAvatars_renderOneAvatar:
cmp.b D3, D5 ; see if we need to render or clear based on how many avatars to render
bge renderChosenAvatar_clearOneAvatar

clr.w D7
move.b (A2), D7 ; load the char id
move.b $3(A2), D4 ; palette flag
move.b D7, D1 ; flipPaletteFlagIfNeeded needs char id here
bsr flipPaletteFlagIfNeeded
jsr $2RENDER_CHOSEN_AVATAR
bra renderChosenAvatar_doneRenderingOneAvatar

renderChosenAvatar_clearOneAvatar:
jsr $2CLEAR_CHOSEN_AVATAR

renderChosenAvatar_doneRenderingOneAvatar:

adda.w #1, A2 ; move to next character
addi.w #1, D6 ; move to next avatar index
addi.b #1, D5 ; increment the counter
cmpi.b #3, D5 ; and loop if we've done less than 3 characters
bne renderChosenAvatars_renderOneAvatar

renderChosenAvatars_done:
rts