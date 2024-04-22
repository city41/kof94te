; handles character selection and cursor movement for either p1 or p2
;
; parameters
; A0: base pointer for p1 or p2 data
; A1: base pointer for other player's data
; D6: sprite index start for cursor
; D7: sprite index start for chosen team

; how many characters have been chosen so far?
; don't let them choose more than 3
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
cmpi.b #3, D0
beq skipChoosingChar ; if three have been chosen, don't choose more
; is this a single player game, and they are past the first fight? 
; then char select is just about showing who they fight next, don't
; let them do anything
btst #7, $PLAY_MODE
; if it is not zero, then the flag is set, don't let them choose
bne skipChoosingChar

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
lea $2GRID_TO_CHARACTER_ID, A3
adda.w D1, A3
move.b (A3), D1 ; character Id from grid is now in D1

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

;;; now render the newly chosen character into chosen team area
;; set up the sprite index based on character index
move.w D0, D6  ; move num of chosen characters in
subi.w #1, D6  ; but we already incremented, so it's one too big
mulu.w #2, D6
add.w D7, D6 ; add on the starting sprite index

;; parameters
;; D6.w - sprite index
;; D7.w - character id
clr.w D7
move.b D1, D7
jsr $2RENDER_CHOSEN_AVATAR

; move.w #24, D5              ; offset into tile data, each avatar is 24 bytes
; mulu.w D1, D5               ; multiply the offset by the character id to get the right avatar
; lea $2AVATARS_IMAGE, A6 ; load the pointer to the tile data

; ;; parameters
; ;; D5: offset into the data
; ;; D6: starting sprite index
; ;; A6: pointer to tile data
; movem.w D0-D3, $MOVEM_STORAGE
; jsr $2RENDER_STATIC_IMAGE
; movem.w $MOVEM_STORAGE, D0-D3

; ;;; now move it into place
; ;; set up the sprite index based on character index
; move.w D0, D7 ; save num chosen chars
; subi.w #1, D7 ; but we already incremented, so it's one too big
; move.w D6, D0 ; move the sprite index where MOVE_SPRITE expects it
; subi.w #2, D0 ; RENDER_STATIC_IMAGE moved D6 forward by 2 sprites, moving back
; move.w $PXCTSX_MULTIPLIER_OFFSET(A0), D2 ; set X to 32px or -32px
; mulu.w D7, D2  ; move over for 1st and 2nd char

; move.w $PX_CHOSEN_TEAM_SCREEN_X_OFFSET(A0), D6
; add.w D6, D2 ; offset X depending on if p1/p2
; move.w D2, D1 ; move X where MOVE_SPRITE expects it
; move.w #315, D2 ; set Y to 181px

; ;; parameters
; ;; D0: sprite index
; ;; D1: x
; ;; D2: y
; movem.w D0-D3, $MOVEM_STORAGE
; jsr $2MOVE_SPRITE
; movem.w $MOVEM_STORAGE, D0-D3

skipChoosingChar:

;;;;;;;;;;;;;;;; PLAYER CURSOR ;;;;;;;;;;;;;;;;;;;;

btst #7, $PLAY_MODE
bne hidePlayerCursor ; if past first fight, never show the player's cursor
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
cmpi.b #3, D0
beq hidePlayerCursor ; all three chosen? no need for a cursor anymore

move.w D6, D0 ; load the cursor's sprite index
; MOVE_CURSOR also wants the base player data in A0, which is already there
jsr $2MOVE_CURSOR
bra donePlayerCursor

hidePlayerCursor:
;; hide the left cursor
move.w D6, D0 ; load the cursor's sprite index
move.w #0, D1  ; x
move.w #272, D2 ; set y to 224, moving cursor off screen
jsr $2MOVE_SPRITE
;; and now the right
move.w D6, D0 ; load the cursor's sprite index
addi.w #1, D0 ; bump to next sprite
move.w #0, D1  ; x
move.w #272, D2 ; set y to 224, moving cursor off screen
jsr $2MOVE_SPRITE

donePlayerCursor:

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