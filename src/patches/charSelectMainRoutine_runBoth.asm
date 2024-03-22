;;;; NOTE: using A5 needs to be done carefully, the main game
;;;; expects it when we rts
move.l A0, D1
move.l D1, $STORE_A0      ; store A0 as the game needs it
move.l A1, D1
move.l D1, $STORE_A1      ; store A1 as the game needs it


;;;;; CHOOSE CHARACTER IF A IS PRESSED ;;;;;
; dont let them choose more than 3
move.b $P1_NUM_CHOSEN_CHARS, D0
cmpi.b #3, D0
beq skipChoosingChar

move.b $10fd97, D0 ; load BIOS_P1CHANGE
btst #$4, D0 ; is p1 A pressed?
beq skipChoosingChar ; it's not? not setting a character choice then

;; figure out the character id based on cursor's location
move.w $P1_CURSOR_X, D0
move.w $P1_CURSOR_Y, D1
mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid
lea $2GRID_TO_CHARACTER_ID, A0
adda.w D1, A0
move.b (A0), D1 ; character Id from grid is now in D1
lea $P1_CHOSEN_CHAR0, A0 ; load the first character chosen address
clr.w D0
move.b $P1_NUM_CHOSEN_CHARS, D0
adda.w D0, A0   ; move forward based on how many characters are chosen
move.b D1, (A0) ; set the chosen character
addi.b #1, D0
move.b D0, $P1_NUM_CHOSEN_CHARS ; increment number of chosen characters
move.b #$61, $320000  ; play the sound effect

skipChoosingChar:


;;; increment the counter
move.b $CHAR_SELECT_COUNTER, D5
addi.b #1, D5
move.b D5, $CHAR_SELECT_COUNTER

;;;;;;;;;;;;;;;; P1 CURSOR ;;;;;;;;;;;;;;;;;;;;

;;;; load the common values for MOVE_CURSOR that work for both
;;;; the black and white cursor
move.b $10fd97, D0        ; load BIOS_P1CHANGE
; move.b #$a, D0            ; simulate right and down being pressed
lea $P1_CURSOR_X, A0      ; pointer to cursor X
lea $P1_CURSOR_Y, A1      ; pointer to cursor Y

;;;; now show the white or black cursor, depending on if the counter
;;;; is odd or not
btst #2, D5
beq blackCursor
move.w #$P1_CURSOR_WHITE_BORDER_SI, D1 ; load the cursor's sprite index
bra moveCursor
blackCursor:
move.w #$P1_CURSOR_BLACK_BORDER_SI, D1 ; load the cursor's sprite index
moveCursor:
jsr $2MOVE_CURSOR

;;;; now hide the one that should not be on screen
move.w #0, D1 ; X
move.w #272, D2 ; Y, which will be 224px, putting it off screen
btst #2, D5
beq hideWhiteCursor
move.w #$P1_CURSOR_BLACK_BORDER_SI, D0 ; load the cursor's sprite index
bra hideCursor
hideWhiteCursor:
move.w #$P1_CURSOR_WHITE_BORDER_SI, D0 ; load the cursor's sprite index
hideCursor:
jsr $2MOVE_SPRITE

;;;;;;;;;;;;;;;;;; CPU CURSOR ;;;;;;;;;;;;;;;;;;;;;;;;
move.b $P1_NUM_CHOSEN_CHARS, D0
cmpi.b #2, D0
ble skipCpuCursor
jsr $2MOVE_CPU_CURSOR
skipCpuCursor:

;;;; CURRENTLY FOCUSED CHARACTER NAME
jsr $2RENDER_CUR_FOCUSED_CHAR_NAME


;;;; CHOSEN TEAM AVATARS ;;;;;;;
move.b $P1_NUM_CHOSEN_CHARS, D4
beq doneRenderingChosenTeam ; none chosen yet? skip this section

clr.w D7
move.b #0, D7 ; starting with the 0'th character on the team

renderChosenChar:
lea $P1_CHOSEN_CHAR0, A0 ; load the first character id address
adda.w D7, A0   ; move forward based on which character we are on
clr.w D2
move.b (A0), D2 ; load chosen character id

;; set up the sprite index based on character index
move.w D7, D6 
mulu.w #2, D6
addi.w #$T1C1_SI, D6

move.w #24, D5              ; offset into tile data, each avatar is 24 bytes
mulu.w D2, D5               ; multiply the offset by the character id to get the right avatar
lea $2AVATARS_IMAGE, A6 ; load the pointer to the tile data
jsr $2RENDER_STATIC_IMAGE

;;; now move it into place
;; set up the sprite index based on character index
move.w D7, D0 
mulu.w #2, D0
addi.w #$T1C1_SI, D0

move.w #32, D1 ; set X to 32px
mulu.w D7, D1  ; move over for 1st and 2nd char
addi.w #32, D1 ; offset X by 32px
move.w #315, D2 ; set Y to 181px
jsr $2MOVE_SPRITE

;; now loop to next char if there is one
addq.w #1, D7 ; increment to next character index
clr.w D0
move.b $P1_NUM_CHOSEN_CHARS, D0 ; how many characters there are
cmp.w D7, D0
bne renderChosenChar ; if D3 != D0, then there are more characters to render

doneRenderingChosenTeam:





;; restore the saved address registers
move.l $STORE_A0, D1
movea.l D1, A0
move.l $STORE_A1, D1
movea.l D1, A1

;;;;;; IS WHOLE TEAM CHOSEN? THEN MOVE ONTO ORDER SELECT ;;;;;
move.b $P1_NUM_CHOSEN_CHARS, D0
cmpi.b #$2, D0 ; have three characters been chosen?
ble done ; no? let's try again next frame
move.b #1, $READY_TO_EXIT_CHAR_SELECT ; team chosen, signal to exit

done:
rts