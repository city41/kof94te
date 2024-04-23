move.b #1, $IN_CHAR_SELECT_FLAG

;; reset the player mode, we'll figure it out through the course of init
;; 
;; PLAY_MODE values:
;; 0 - no players, demo mode
;; bit 0       | 1 | - single player, p1 side
;; bit 1       | 2 | - single player, p2 side
;; bit 0 and 1 | 3 | - versus mode
;; bit 6       |   | - single player continued
;; bit 7       |   | - single player, char select should be read only
;;   --- this happens when the player has beaten their first team
;;   --- all subsequent char selects are read only
;;   --- but if they lose and continue, this bit will be uncleared
move.b #0, $PLAY_MODE

move.w #$P1_CURSOR_LEFT_SI, $P1_CURSOR_SPRITEINDEX
move.w #$P2_CURSOR_LEFT_SI, $P2_CURSOR_SPRITEINDEX
move.w #$P1C1_SI, $P1_CHOSEN_TEAM_SPRITEINDEX
move.w #$P2C1_SI, $P2_CHOSEN_TEAM_SPRITEINDEX


;; reset these back to zero, we'll set them to 3 down below if needed
move.b #0, $P1_NUM_CHOSEN_CHARS
move.b #0, $P2_NUM_CHOSEN_CHARS

jsr $2LOAD_P_A_L_E_T_T_E_S

;; set the auto animation speed for the cursors
move.w #$200, $3C0006

; load the character grid image onto the screen
move.w #$GRID_IMAGE_SI, D6 ; set sprite index
move.w #0, D5              ; offset into tile data
lea $2CHARACTER_GRID_IMAGE, A6 ; load the image pointer
jsr $2RENDER_STATIC_IMAGE


;;;;;;;;;;;;;; INIT PLAYER 1 ;;;;;;;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD1, D6 ; are they even playing?
cmpi.b #1, D6 ;; look specifically for 1: playing
bne skipPlayer1 ; no? check player 2

;; side p1 is playing, add it to the mode
ori.b #1, $PLAY_MODE

; load the p1 cursor, left
; it loads into the correct spot, no need to move it
move.w #$P1_CURSOR_LEFT_SI, D6
lea $2P1_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the p1 cursor, right
; it loads into the correct spot, no need to move it
move.w #$P1_CURSOR_RIGHT_SI, D6
lea $2P1_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; initialize cursor's location
; this is a 2d index into the grid, not pixels
move.w #0, $P1_CURSOR_X ; start at Terry
move.w #0, $P1_CURSOR_Y

;;;;;;;;;;;;;;; INIT CPU AGAINST P1 ;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD2, D6 ; are they even playing?
cmpi.b #1, D6 ;; look specifically for 1: playing
beq skipPlayer1 ; player 2 is playing, this is versus mode, so don't do cpu
; load the cpu cursor, left side
; it loads itself off screen, no need to move it
move.w #$P2_CURSOR_LEFT_SI, D6
lea $2CPU_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the cpu cursor, right side
; it loads itself off screen, no need to move it
move.w #$P2_CURSOR_RIGHT_SI, D6
lea $2CPU_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE
;;;;;;;;;;;;;;;; END INIT PLAYER 1 ;;;;;;;;;;;;;;

skipPlayer1:

;;;;;;;;;;;;;; INIT PLAYER 2 ;;;;;;;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD2, D6
cmpi.b #1, D6 ;; look specifically for 1: playing
bne skipPlayer2 ; skip if p2 is not playing

;; side p2 is playing, add it to the mode
ori.b #2, $PLAY_MODE

; load the p2 cursor, left
; it loads into the correct spot, no need to move it
move.w #$P2_CURSOR_LEFT_SI, D6
lea $2P2_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the p2 cursor, right
; it loads into the correct spot, no need to move it
move.w #$P2_CURSOR_RIGHT_SI, D6
lea $2P2_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; initialize cursor's location
; this is a 2d index into the grid, not pixels
move.w #8, $P2_CURSOR_X ; start at Clark
move.w #0, $P2_CURSOR_Y

;;;;;;;;;;;;;;; INIT CPU AGAINST P2 ;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD1, D6 ; are they even playing?
cmpi.b #1, D6 ;; look specifically for 1: playing
beq skipPlayer2 ; player 1 is playing, this is versus mode, so don't do cpu
; load the cpu cursor, left side
; it loads itself off screen, no need to move it
move.w #$P1_CURSOR_LEFT_SI, D6
lea $2CPU_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the cpu cursor, right side
; it loads itself off screen, no need to move it
move.w #$P1_CURSOR_RIGHT_SI, D6
lea $2CPU_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE
;;;;;;;;;;;;;;;; END INIT PLAYER 2 ;;;;;;;;;;;;;;

skipPlayer2:

;;;;;;;;;;;;;;;;; DEMO MODE INIT ;;;;;;;;;;;;;;;;;

cmpi.b #0, $PLAY_MODE
bne skipDemoMode
;; this is demo mode, we need to do both cpu cursors

;; p1 side cpu cursor, left half
move.w #$P1_CURSOR_LEFT_SI, D6
lea $2CPU_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; p1 side cpu cursor, right half
; it loads itself off screen, no need to move it
move.w #$P1_CURSOR_RIGHT_SI, D6
lea $2CPU_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

;; p1 side cpu cursor, left half
move.w #$P2_CURSOR_LEFT_SI, D6
lea $2CPU_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; p1 side cpu cursor, right half
; it loads itself off screen, no need to move it
move.w #$P2_CURSOR_RIGHT_SI, D6
lea $2CPU_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

;;;;;;;;;;;;;;;;; END DEMO MODE INIT ;;;;;;;;;;;;;;;;;

skipDemoMode:

cmpi.b #$ff, $DEFEATED_TEAMS
beq doRugal
bra skipRugal

doRugal:
jsr $2PUT_RUGAL_ON_GRID
skipRugal:


cmpi.b #0, $PLAY_MODE
beq skipGreyOut ; don't grey out in demo mode
cmpi.b #3, $PLAY_MODE
beq skipGreyOut ; don't grey out in versus mode
jsr $2GREY_OUT_TEAMS
skipGreyOut:

jsr $2INIT_EMPTY_AVATARS

;; GENERAL VALUE INITIALIZATION
bsr setCpuAlreadyUsedIndex
; cmpi.b #0, $DEFEATED_TEAMS ; if there are zero defeated teams
; bne skipResetIndexes
; move.b #0, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES ; then reset the rng tracker byte
; skipResetIndexes:



btst #0, $PLAY_MODE
beq p1_pastReady ; p1 isn't playing? skip
btst #1, $PLAY_MODE ; but p2 is playing too? versus mode, skip
; jumping here sets up char select well for versus mode
; but it does let p1 rechoose their team. The original game did not do this
; but it's a nice bonus, so letting it slide
bne p1_firstCharSelect

; single player mode, p1 side
cmpi.b #$80, $108238 ; player 1 is human, did they lose?
;; if it is $80, then they lost and they continued, this is the very first char select
beq p1_continued
cmpi.b #$80, $108438
bne p1_firstCharSelect ; if player 2 hasn't lost, then this is the first char select
;; set flag to indicate to main this is not the first char select
bset #7, $PLAY_MODE
;; have main move onto cpu select right away
move.b #1, $READY_TO_EXIT_CHAR_SELECT
;; by setting to 3 chars, cpu randomization happens
move.b #3, $P1_NUM_CHOSEN_CHARS
bra p1_pastReady
p1_continued:
;; set the continue flag so char select knows to show the cpu team
bset #6, $PLAY_MODE
p1_firstCharSelect: 
;; first time in char select for single player, p1 side
move.b #0, $READY_TO_EXIT_CHAR_SELECT
move.b #0, $P1_NUM_CHOSEN_CHARS
p1_pastReady:

btst #1, $PLAY_MODE
beq p2_pastReady ; p2 isn't playing? skip
btst #0, $PLAY_MODE ; but p1 is playing too? versus mode, skip
; jumping here sets up char select well for versus mode
; but it does let p1 rechoose their team. The original game did not do this
; but it's a nice bonus, so letting it slide
bne p2_firstCharSelect

; single player mode, p2 side
cmpi.b #$80, $108438 ; player 2 is human, did they lose?
;; if it is $80, then they lost and they continued, this is the very first char select
beq p2_continued
cmpi.b #$80, $108238
bne p2_firstCharSelect ; if player 1 hasn't lost, then this is the first char select
;; set flag to indicate to main this is not the first char select
bset #7, $PLAY_MODE
;; have main move onto cpu select right away
move.b #1, $READY_TO_EXIT_CHAR_SELECT
;; by setting to 3 chars, cpu randomization happens
move.b #3, $P2_NUM_CHOSEN_CHARS
bra p2_pastReady
p2_continued:
;; set the continue flag so char select knows to show the cpu team
bset #6, $PLAY_MODE
p2_firstCharSelect: 
;; first time in char select for single player, p2 side
move.b #0, $READY_TO_EXIT_CHAR_SELECT
move.b #0, $P2_NUM_CHOSEN_CHARS
p2_pastReady:


;; focused character names
move.w #$P1_FOCUSED_NAME_FIX_ADDRESS_VALUE, $P1_FOCUSED_CHAR_NAME_FIX_ADDRESS
move.l #$2P1_CHAR_NAME_TABLE, $P1_CHAR_NAME_TABLE_ADDRESS
move.w #$P2_FOCUSED_NAME_FIX_ADDRESS_VALUE, $P2_FOCUSED_CHAR_NAME_FIX_ADDRESS
move.l #$2P2_CHAR_NAME_TABLE, $P2_CHAR_NAME_TABLE_ADDRESS

bsr renderChosenAvatars

;;; put the disclaimer string up
;;; [w:fix layer location][l: string pointer][w: countdown]
move.w #$7024, $FIX_STRING_DATA         ; set up the version string's fix write location
move.l #$2HACK_ISNT_FINISHED_YET, $FIX_STRING_DATA + 2 ; set up the pointer to the version string
move.w #300, $FIX_STRING_DATA + 6      ; countdown

move.w #$7025, $MORE_STRING_DATA         ; set up the version string's fix write location
move.l #$2MORE_INFO, $MORE_STRING_DATA + 2 ; set up the pointer to the version string
move.w #300, $MORE_STRING_DATA + 6      ; countdown

;;; put the version string up
move.w #$7026, $VSTRING_DATA         ; set up the version string's fix write location
move.l #$2VERSION, $VSTRING_DATA + 2 ; set up the pointer to the version string
move.w #300, $VSTRING_DATA + 6      ; countdown

rts




;; consults the team defeat byte and sets
;; the already used indexes byte accordingly
setCpuAlreadyUsedIndex:

btst #0, $PLAY_MODE
beq setCpuAlreadyUsedIndex_player2 ; player 1 is not playing, onto player 2

clr.b $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

btst #0, $DEFEATED_TEAMS
beq p1_skipBrazil
bset #2, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p1_skipBrazil:
btst #1, $DEFEATED_TEAMS
beq p1_skipChina
bset #6, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p1_skipChina:
btst #2, $DEFEATED_TEAMS
beq p1_skipJapan
bset #5, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p1_skipJapan:
btst #3, $DEFEATED_TEAMS
beq p1_skipUSA
bset #4, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p1_skipUSA:
btst #4, $DEFEATED_TEAMS
beq p1_skipKorea
bset #3, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p1_skipKorea:
btst #5, $DEFEATED_TEAMS
beq p1_skipItaly
bset #7, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p1_skipItaly:
btst #6, $DEFEATED_TEAMS
beq p1_skipMexico
bset #0, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p1_skipMexico:
btst #7, $DEFEATED_TEAMS
beq p1_skipEngland
bset #1, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p1_skipEngland:
bra setCpuAlreadyUsedIndex_done

setCpuAlreadyUsedIndex_player2:
btst #1, $PLAY_MODE
beq setCpuAlreadyUsedIndex_done ; player two is not playing, nothing to do

clr.b $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

btst #0, $DEFEATED_TEAMS
beq p2_skipBrazil
bset #5, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p2_skipBrazil:
btst #1, $DEFEATED_TEAMS
beq p2_skipChina
bset #1, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p2_skipChina:
btst #2, $DEFEATED_TEAMS
beq p2_skipJapan
bset #2, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p2_skipJapan:
btst #3, $DEFEATED_TEAMS
beq p2_skipUSA
bset #3, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p2_skipUSA:
btst #4, $DEFEATED_TEAMS
beq p2_skipKorea
bset #4, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p2_skipKorea:
btst #5, $DEFEATED_TEAMS
beq p2_skipItaly
bset #0, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p2_skipItaly:
btst #6, $DEFEATED_TEAMS
beq p2_skipMexico
bset #7, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p2_skipMexico:
btst #7, $DEFEATED_TEAMS
beq p2_skipEngland
bset #6, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES

p2_skipEngland:

setCpuAlreadyUsedIndex_done:
rts



;; renderChosenAvatars
;; for both players, will render in the chosen avatars
;; this will be either 0 or 3 chosen avatars at this point
renderChosenAvatars:

;; player 1
tst.b $P1_NUM_CHOSEN_CHARS
beq renderChosenAvatar_skipPlayer1 ; none chosen? nothing to do
;; if we get here, we know all three have been chosen
move.w #$P1C1_SI, D6
clr.w D7
move.b $P1_CHOSEN_CHAR0, D7
jsr $2RENDER_CHOSEN_AVATAR
move.w #$P1C1_SI + 2, D6
clr.w D7
move.b $P1_CHOSEN_CHAR1, D7
jsr $2RENDER_CHOSEN_AVATAR
move.w #$P1C1_SI + 4, D6
clr.w D7
move.b $P1_CHOSEN_CHAR2, D7
jsr $2RENDER_CHOSEN_AVATAR

renderChosenAvatar_skipPlayer1:
;; player 2
tst.b $P2_NUM_CHOSEN_CHARS
beq renderChosenAvatar_skipPlayer2 ; none chosen? nothing to do
;; if we get here, we know all three have been chosen
move.w #$P2C1_SI, D6
clr.w D7
move.b $P2_CHOSEN_CHAR0, D7
jsr $2RENDER_CHOSEN_AVATAR
move.w #$P2C1_SI + 2, D6
clr.w D7
move.b $P2_CHOSEN_CHAR1, D7
jsr $2RENDER_CHOSEN_AVATAR
move.w #$P2C1_SI + 4, D6
clr.w D7
move.b $P2_CHOSEN_CHAR2, D7
jsr $2RENDER_CHOSEN_AVATAR

renderChosenAvatar_skipPlayer2:
rts



