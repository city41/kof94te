; handles character selection and cursor movement for either p1 or p2
;
; parameters
; A0: base pointer for p1 or p2 data
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
move.b $SINGLE_PLAYER_PAST_FIRST_FIGHT, D0
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
; first set their palette flag
movea.l A0, A2 ; load the player struct starting address
adda.w #$PX_CHOSEN_CHAR0_OFFSET, A2 ; and move forward to first chosen char
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0 ; grab how many chars have been chosen so far
lsl.b #1, D0 ; double it, as characters are words : [char id]|[palette flag]
adda.w D0, A2
adda.w #1, A2 ; the palette flag is one byte past the character Id
move.b D4, (A2) ; set the palette flag (either 0 for reg, or 1 for alt)
; and then from here just set the character
;; figure out the character id based on cursor's location
move.w $PX_CURSOR_X_OFFSET(A0), D0
move.w $PX_CURSOR_Y_OFFSET(A0), D1
mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid
lea $2GRID_TO_CHARACTER_ID, A1
adda.w D1, A1
move.b (A1), D1 ; character Id from grid is now in D1
movea.l A0, A2 ; load the player struct starting address
adda.w #$PX_CHOSEN_CHAR0_OFFSET, A2 ; and move forward to first chosen char
clr.w D0
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
lsl.b #1, D0 ; need to double it, as each character is a word: [char id]|[palette flag]
adda.w D0, A2   ; move forward based on how many characters are chosen
move.b D1, (A2) ; set the chosen character
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

move.w #24, D5              ; offset into tile data, each avatar is 24 bytes
mulu.w D1, D5               ; multiply the offset by the character id to get the right avatar
lea $2AVATARS_IMAGE, A6 ; load the pointer to the tile data

;; parameters
;; D5: offset into the data
;; D6: starting sprite index
;; A6: pointer to tile data
movem.w D0-D3, $MOVEM_STORAGE
jsr $2RENDER_STATIC_IMAGE
movem.w $MOVEM_STORAGE, D0-D3

;;; now move it into place
;; set up the sprite index based on character index
move.w D0, D7 ; save num chosen chars
subi.w #1, D7 ; but we already incremented, so it's one too big
move.w D6, D0 ; move the sprite index where MOVE_SPRITE expects it
subi.w #2, D0 ; RENDER_STATIC_IMAGE moved D6 forward by 2 sprites, moving back
move.w $PXCTSX_MULTIPLIER_OFFSET(A0), D2 ; set X to 32px or -32px
mulu.w D7, D2  ; move over for 1st and 2nd char

move.w $PX_CHOSEN_TEAM_SCREEN_X_OFFSET(A0), D6
add.w D6, D2 ; offset X depending on if p1/p2
move.w D2, D1 ; move X where MOVE_SPRITE expects it
move.w #315, D2 ; set Y to 181px

;; parameters
;; D0: sprite index
;; D1: x
;; D2: y
movem.w D0-D3, $MOVEM_STORAGE
jsr $2MOVE_SPRITE
movem.w $MOVEM_STORAGE, D0-D3

skipChoosingChar:

;;;;;;;;;;;;;;;; PLAYER CURSOR ;;;;;;;;;;;;;;;;;;;;

move.b $SINGLE_PLAYER_PAST_FIRST_FIGHT, D0
bne hidePlayerCursor ; if past first fight, never show the player's cursor
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
cmpi.b #3, D0
beq hidePlayerCursor ; all three chosen? no need for a cursor anymore

move.w D6, D0 ; load the cursor's sprite index
; MOVE_CURSOR also wants the base player data in A0, which is already there
jsr $2MOVE_CURSOR
bra donePlayerCursor

hidePlayerCursor:
move.w D6, D0 ; load the cursor's sprite index
move.w #0, D1  ; x
move.w #272, D2 ; set y to 224, moving cursor off screen
jsr $2MOVE_SPRITE

donePlayerCursor:

; for the character currently under the cursor, show their name on the fix layer
jsr $2RENDER_CUR_FOCUSED_CHAR_NAME

rts