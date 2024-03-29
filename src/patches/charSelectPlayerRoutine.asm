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

move.b $PX_CUR_INPUT_OFFSET(A0), D0 ; load effectively BIOS_PXCHANGE
btst #$4, D0 ; is A pressed?
beq skipChoosingChar ; no? not setting a character choice then

;; figure out the character id based on cursor's location
move.w $PX_CURSOR_X_OFFSET(A0), D0
move.w $PX_CURSOR_Y_OFFSET(A0), D1
mulu.w #9, D1 ; multiply Y by 9
add.w D0, D1  ; then add X to get the index into the grid
lea $2GRID_TO_CHARACTER_ID, A1
adda.w D1, A1
move.b (A1), D1 ; character Id from grid is now in D1
movea.l A0, A2 ; load the first character chosen address
adda.w #$PX_CHOSEN_CHAR0_OFFSET, A2
clr.w D0
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0
adda.w D0, A2   ; move forward based on how many characters are chosen
move.b D1, (A2) ; set the chosen character
addi.b #1, D0
move.b D0, $PX_NUM_CHOSEN_CHARS_OFFSET(A0) ; increment number of chosen characters
move.b #$61, $320000  ; play the sound effect

skipChoosingChar:

;;;;;;;;;;;;;;;; PLAYER CURSOR ;;;;;;;;;;;;;;;;;;;;

move.b $PX_CUR_INPUT_OFFSET(A0), D0 ; load effectively BIOS_PXCHANGE
lea $PX_CURSOR_X_OFFSET(A0), A1      ; pointer to cursor X
move.w D6, D1 ; load the cursor's sprite index
jsr $2MOVE_CURSOR



;;;; RENDER CHOSEN TEAM ;;;;;;;;;;;;;;
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D1
beq doneRenderingChosenTeam ; none chosen yet? skip this section

clr.w D3 ; starting with the 0'th character on the team

renderChosenChar:
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A1 ; load the first character id address
adda.w D3, A1   ; move forward based on which character we are on
clr.w D2
move.b (A1), D2 ; load chosen character id

;; set up the sprite index based on character index
move.w D3, D6 
mulu.w #2, D6
add.w D7, D6 ; add on the starting sprite index

move.w #24, D5              ; offset into tile data, each avatar is 24 bytes
mulu.w D2, D5               ; multiply the offset by the character id to get the right avatar
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
move.w D3, D0 
mulu.w #2, D0
add.w D7, D0

move.w #32, D1 ; set X to 32px
mulu.w D3, D1  ; move over for 1st and 2nd char

move.w $PX_CHOSEN_TEAM_SCREEN_X_OFFSET(A0), D6
add.w D6, D1 ; offset X depending on if p1/p2
move.w #315, D2 ; set Y to 181px

;; parameters
;; D0: sprite index
;; D1: x
;; D2: y
movem.w D0-D3, $MOVEM_STORAGE
jsr $2MOVE_SPRITE
movem.w $MOVEM_STORAGE, D0-D3

;; now loop to next char if there is one
addq.w #1, D3 ; increment to next character index
clr.w D0
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D0 ; how many characters there are
cmp.w D3, D0
bne renderChosenChar ; if D3 != D0, then there are more characters to render

doneRenderingChosenTeam:


;;;; CURRENTLY FOCUSED CHARACTER NAME
;;; this clobbers A0, so putting last allows it to run safely
jsr $2RENDER_CUR_FOCUSED_CHAR_NAME

rts