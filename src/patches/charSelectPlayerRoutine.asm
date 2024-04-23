; handles character selection and cursor movement for either p1 or p2
;
; parameters
; A0: base pointer for p1 or p2 data
; A1: base pointer for other player's data

; how many characters have been chosen so far?
; don't let them choose more than 3
cmpi.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
beq skipChoosingChar ; if three have been chosen, don't choose more

; is this a single player game, and they are past the first fight? 
; then char select is just about showing who they fight next, don't
; let them do anything
btst #7, $PLAY_MODE
bne skipChoosingChar

;;;;;;;;;;;;;;;;;;; SLOT MACHINE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
beq slotMachine_chooseChar
cmpi.b #12, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
beq slotMachine_chooseChar
cmpi.b #0, $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
beq slotMachine_chooseChar
bra slotMachine_skipChooseChar
;; ready to choose the first character

slotMachine_chooseChar:
;; take the palette flag choice they made before and restore it to D4
move.b $PX_RANDOM_SELECT_PALETTE_FLAG_CHOICE_OFFSET(A0), D4
movea.l A0, A2 ; load the player struct starting address
adda.w #$PX_CHOSEN_CHAR0_OFFSET, A2 ; and move forward to first chosen char
clr.w D0
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
lsl.b #1, D0 ; need to double it, as each character is a word: [char id]|[palette flag]
adda.w D0, A2   ; move forward based on how many characters are chosen
move.b (A2), D1 ; pull the chosen char back out
;; saveChar will take D1 (charId) and D4 (palette flag)
;; and do everything needed to save the character
bsr saveChar

slotMachine_skipChooseChar:
bsr randomSelect

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
beq chooseRandomSelect
cmpi.b #23, D1 ; are they on the right random select?
beq chooseRandomSelect
bra skipChooseRandomSelect

chooseRandomSelect:
;; first remember the palette flag choice, as we won't apply it for several frames
move.b D4, $PX_RANDOM_SELECT_PALETTE_FLAG_CHOICE_OFFSET(A0)

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

skipChooseRandomSelect:
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
;; D6.w - sprite index
;; D7.w - character id
clr.w D7
move.b D1, D7
jsr $2RENDER_CHOSEN_AVATAR

skipChoosingChar:

;;;;;;;;;;;;;;;; PLAYER CURSOR ;;;;;;;;;;;;;;;;;;;;

btst #7, $PLAY_MODE
bne doHidePlayerCursor ; if past first fight, never show the player's cursor
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
cmpi.b #3, D0
beq doHidePlayerCursor ; all three chosen? no need for a cursor anymore

jsr $2MOVE_CURSOR
bra donePlayerCursor

doHidePlayerCursor:
bsr hidePlayerCursor
bra donePlayerCursor


donePlayerCursor:

;;;;;;;;;;;;;;;;;;; RANDOM SELECT ;;;;;;;;;;;;;;;;;;;;;;;;;
;; are they currently hovering on a random select space?
move.w $PX_CURSOR_X_OFFSET(A0), D0
move.w $PX_CURSOR_Y_OFFSET(A0), D1

mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid


cmpi.w #21, D1 ; are they on the left random select space?
beq doRandomSelect
cmpi.w #23, D1 ; are they on the right random select space?
beq doRandomSelect
bra doClearRandomSelect

doRandomSelect:
bsr randomSelect
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


;;;;
;;;; SUBROUTINES BELOW
;;;;


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


;; randomSelect
;; called if a player's cursor is over random select
;; need to fill the chosen team section with random characters
randomSelect:
cmpi.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
beq randomSelect_done ; chose three characters? don't randomize then

;; throttle back the speed of random select
move.b $CHAR_SELECT_COUNTER, D4
andi.b #$3, D4
;; if there are any lower bits, bail
;; this means only random select every 4 frames
bne randomSelect_done

move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6 ; load si
add.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D6 ; move si forward to first unchosen character
add.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D6 ; twice since avatars are 2 sprites each
move.w #2, D4
sub.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D4 ; decrement D4 by number already chosen

randomSelect_pickRandomChar:
;; get a random number between 0-23
;; the game's rng uses A0
movem.l A0, $MOVEM_STORAGE
jsr $2582 ; call the game's rng, it leaves a random byte in D0
movem.l $MOVEM_STORAGE, A0
andi.b #$1f, D0 ; chop the random byte down to 5 bits -> 0 through 31
cmpi.b #24, D0
bge randomSelect_pickRandomChar ;; it was too big, try again

cmpi.b #0, D4
bne randomSelect_checkFirst
;; this means D0 is destined for the third character
;; let's make sure char 0 and 1 aren't already this character
cmp.b $PX_CHOSEN_CHAR0_OFFSET(A0), D0
beq randomSelect_pickRandomChar ; they already have this character, choose again
cmp.b $PX_CHOSEN_CHAR1_OFFSET(A0), D0
beq randomSelect_pickRandomChar ; they already have this character, choose again
randomSelect_checkFirst:
cmpi.b #1, D4
bne randomSelect_saveChar ; if D4 is 2, then this is the very first character, no checks needed
;; this makes D0 is destined for the second characterG
;; let's make sure char 0 isn't already this character
cmp.b $PX_CHOSEN_CHAR0_OFFSET(A0), D0
beq randomSelect_pickRandomChar ; they already have this character, choose again


randomSelect_saveChar:
;; save the chosen id into CHOSEN_CHAR
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A1
move.w #2, D5
sub.w D4, D5
adda.w D5, A1 ; add it twice since chosen chars are words
adda.w D5, A1 ; add it twice since chosen chars are words
move.b D0, (A1)

clr.w D7
move.b D0, D7 ; load up the random char id
;; parameters
;; D6.w - sprite index
;; D7.w - character id
move.w D6, D3
jsr $2RENDER_CHOSEN_AVATAR
move.w D3, D6
tst.b $PX_SLOT_MACHINE_COUNTDOWN_OFFSET(A0)
; don't play the sfx during slot machine, as kof94 can only play one sfx at a time
bne randomSelect_skipSoundEffect ; don't play the sfx during slot machine
move.b #$60, $320000  ; play the sound effect
randomSelect_skipSoundEffect:

addi.w #2, D6 ; move to next avatar
dbra D4, randomSelect_pickRandomChar

randomSelect_done:
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
movea.l A0, A2 ; load the player struct starting address
adda.w #$PX_CHOSEN_CHAR0_OFFSET, A2 ; and move forward to first chosen char
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