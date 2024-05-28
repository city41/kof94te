;; just in case we got here through HERE COMES CHALLENGER
;; clear out the flag
move.b #0, $IN_HERE_COMES_CHALLENGER

move.b #$MAIN_PHASE_INIT, $MAIN_HACK_PHASE
move.b #1, $IN_CHAR_SELECT_FLAG

;; reset the player mode, we'll figure it out through the course of init
;; 
;; PLAY_MODE values:
;; 0 - no players, demo mode
;; bit 0       | 1 | - single player, p1 side
;; bit 1       | 2 | - single player, p2 side
;; bit 0 and 1 | 3 | - versus mode
;; bit 5       |   | - single player randomize
;; bit 6       |   | - single player continued
;; bit 7       |   | - single player, char select should be read only
;;   --- this happens when the player has beaten their first team
;;   --- all subsequent char selects are read only
;;   --- but if they lose and continue, this bit will be uncleared
move.b #0, $PLAY_MODE

move.w #$P1_CURSOR_LEFT_SI, $P1_CURSOR_SPRITEINDEX
move.w #$P2_CURSOR_LEFT_SI, $P2_CURSOR_SPRITEINDEX
move.w #1, $P1_CHOSEN_TEAM_AVATARINDEX
move.w #4, $P2_CHOSEN_TEAM_AVATARINDEX


;; reset these back to zero, we'll set them to 3 down below if needed
move.b #0, $P1_NUM_CHOSEN_CHARS
move.b #0, $P2_NUM_CHOSEN_CHARS

jsr $2LOAD_P_A_L_E_T_T_E_S

; load the character grid image onto the screen
move.w #$GRID_IMAGE_SI, D6 ; set sprite index
move.w #0, D5              ; offset into tile data
lea $2CHARACTER_GRID_IMAGE, A6 ; load the image pointer
jsr $2RENDER_STATIC_IMAGE


;;;;;;;;;;;;;; INIT PLAYER 1 ;;;;;;;;;;;;;;;;;;;;
cmpi.b #1, $BIOS_PLAYER_MOD1 ; is player 1 playing?
bne skipPlayer1 ; no? check player 2

;; side p1 is playing, add it to the mode
ori.b #1, $PLAY_MODE

; initialize cursor's location
; this is a 2d index into the grid, not pixels
move.w #0, $P1_CURSOR_X ; start at Terry
move.w #0, $P1_CURSOR_Y
;;;;;;;;;;;;;;;; END INIT PLAYER 1 ;;;;;;;;;;;;;;

skipPlayer1:

;;;;;;;;;;;;;; INIT PLAYER 2 ;;;;;;;;;;;;;;;;;;;;
cmpi.b #1, $BIOS_PLAYER_MOD2 ;; is player 2 playing?
bne skipPlayer2 ; skip if p2 is not playing

;; side p2 is playing, add it to the mode
ori.b #2, $PLAY_MODE

; initialize cursor's location
; this is a 2d index into the grid, not pixels
move.w #8, $P2_CURSOR_X ; start at Clark
move.w #0, $P2_CURSOR_Y
;;;;;;;;;;;;;;;; END INIT PLAYER 2 ;;;;;;;;;;;;;;

skipPlayer2:

;;;;;;;;;;;;;;;;; DEMO MODE INIT ;;;;;;;;;;;;;;;;;

cmpi.b #0, $PLAY_MODE
bne skipDemoMode
;; this is demo mode, we need to do both cpu cursors
;; first pick the cpu team mode
jsr $2DETERMINE_CPU_TEAM_MODE
;; now we can load the cursors
jsr $2LOAD_CPU_CURSORS
;;;;;;;;;;;;;;;;; END DEMO MODE INIT ;;;;;;;;;;;;;;;;;

skipDemoMode:

cmpi.b #$ff, $DEFEATED_TEAMS
beq doRugal
bra skipRugal

doRugal:
jsr $2PUT_RUGAL_ON_GRID
skipRugal:



bsr setCpuAlreadyUsedIndex


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
;; by setting to 3 chars, cpu randomization happens
move.b #3, $P1_NUM_CHOSEN_CHARS
lea $P2_CHOSEN_CHAR0, A0 ; take the CPU's last team
bsr setDefeatedCharBytes ; and mark all of its characters as defeated
bra p1_pastReady
p1_continued:
;; set the continue flag so char select knows to show the cpu team
bset #6, $PLAY_MODE
move.b $P2_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING, $P2_CHOSEN_CHAR0
move.b $P2_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING + 1, $P2_CHOSEN_CHAR1
move.b $P2_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING + 2, $P2_CHOSEN_CHAR2
move.b #3, $P2_NUM_CHOSEN_CHARS
bra p1_skipClearP2NumChosen

p1_firstCharSelect: 
move.b #0, $P2_NUM_CHOSEN_CHARS
bsr clearDefeatedCharBytes

p1_skipClearP2NumChosen:
move.b #0, $P1_NUM_CHOSEN_CHARS
move.b #0, $P1_RANDOM_SELECT_TYPE
move.b #0, $P1_SLOT_MACHINE_COUNTDOWN ; make sure slot machne does not run
move.b #0, $P1_RANDOM_SELECT_PALETTE_FLAG_CHOICE

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
;; by setting to 3 chars, cpu randomization happens
move.b #3, $P2_NUM_CHOSEN_CHARS
lea $P1_CHOSEN_CHAR0, A0 ; take the CPU's last team
bsr setDefeatedCharBytes ; and mark all of its characters as defeated
bra p2_pastReady
p2_continued:
;; set the continue flag so char select knows to show the cpu team
bset #6, $PLAY_MODE
move.b $P1_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING, $P1_CHOSEN_CHAR0
move.b $P1_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING + 1, $P1_CHOSEN_CHAR1
move.b $P1_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING + 2, $P1_CHOSEN_CHAR2
move.b #3, $P1_NUM_CHOSEN_CHARS
bra p2_skipClearP2NumChosen

p2_firstCharSelect: 
move.b #0, $P1_NUM_CHOSEN_CHARS
bsr clearDefeatedCharBytes

p2_skipClearP2NumChosen:
move.b #0, $P2_NUM_CHOSEN_CHARS
move.b #0, $P2_RANDOM_SELECT_TYPE
move.b #0, $P2_SLOT_MACHINE_COUNTDOWN ; make sure slot machne does not run
move.b #0, $P2_RANDOM_SELECT_PALETTE_FLAG_CHOICE

p2_pastReady:


;; focused character names
move.w #$P1_FOCUSED_NAME_FIX_ADDRESS_VALUE, $P1_FOCUSED_CHAR_NAME_FIX_ADDRESS
move.l #$2P1_CHAR_NAME_TABLE, $P1_CHAR_NAME_TABLE_ADDRESS
move.w #$P2_FOCUSED_NAME_FIX_ADDRESS_VALUE, $P2_FOCUSED_CHAR_NAME_FIX_ADDRESS
move.l #$2P2_CHAR_NAME_TABLE, $P2_CHAR_NAME_TABLE_ADDRESS

;; is this a single player game, past the first round, and they 
;; chose random select? If so, have char select re randomize
btst #7, $PLAY_MODE ; is this single player, past the first stage?
beq clearRandomSelectFlags
btst #0, $PLAY_MODE ; is player 1 one playing?
beq randomSelectBit_checkPlayer2
tst.b $P1_RANDOM_SELECT_TYPE
beq clearRandomSelectFlags
;; set up char select to randomize for p1
;; TODO: technically this should be 36, 24, or 12, depending on the number
;; of characters to randomly select, but going with 36 for now
move.b #36, $P1_SLOT_MACHINE_COUNTDOWN ; get the slot machine going
;; maintain the non random characters
move.b $P1_NUM_NON_RANDOM_CHARS, $P1_NUM_CHOSEN_CHARS 
move.b #0, $P2_RANDOM_SELECT_TYPE ; clear player 2 just in case
bset #5, $PLAY_MODE
bra doneRandomSelectFlags
randomSelectBit_checkPlayer2:
tst.b $P2_RANDOM_SELECT_TYPE
beq clearRandomSelectFlags
;; set up char select to randomize for p2 here
;; TODO: technically this should be 36, 24, or 12, depending on the number
;; of characters to randomly select, but going with 36 for now
move.b #36, $P2_SLOT_MACHINE_COUNTDOWN ; get the slot machine going
;; maintain the non random characters
move.b $P2_NUM_NON_RANDOM_CHARS, $P2_NUM_CHOSEN_CHARS 
move.b #0, $P1_RANDOM_SELECT_TYPE ; clear player 1 just in case
bset #5, $PLAY_MODE
bra doneRandomSelectFlags

clearRandomSelectFlags:
move.b #0, $P1_RANDOM_SELECT_TYPE ; clear player 1 flag
move.b #0, $P2_RANDOM_SELECT_TYPE ; clear player 2 flag
move.b #0, $P1_SLOT_MACHINE_COUNTDOWN ; make sure slot machne does not run
move.b #0, $P2_SLOT_MACHINE_COUNTDOWN ; make sure slot machne does not run
bclr #5, $PLAY_MODE

doneRandomSelectFlags:

;;;;;;;;;;; DETERMINE THE PHASE FOR MAIN ;;;;;;;;;;;;;;;
cmpi.b #0, $PLAY_MODE
;; demo mode
beq setCpuSelect
cmpi.b #3, $PLAY_MODE
;; versus mode
beq setPlayerSelect
btst #5, $PLAY_MODE
;; single player random select
bra setPlayerSelect
btst #7, $PLAY_MODE
;; subsequent match in a single player game
bne setCpuSelect
bra setPlayerSelect

setCpuSelect:
move.b #$MAIN_PHASE_CPU_SELECT, $MAIN_HACK_PHASE
move.b #0, $READY_TO_EXIT_CHAR_SELECT
move.b #0, $READY_TO_EMPTY_TEAM_SELECT_TIMER
bra doneSettingPhase

setPlayerSelect:
move.b #$MAIN_PHASE_PLAYER_SELECT, $MAIN_HACK_PHASE
move.b #0, $READY_TO_EMPTY_TEAM_SELECT_TIMER
move.b #0, $READY_TO_EXIT_CHAR_SELECT
bra doneSettingPhase

doneSettingPhase:
;;;;;;;;;;; END DETERMINE THE PHASE FOR MAIN ;;;;;;;;;;;;;;;

;;;;;;;;;;; LOAD CURSORS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; load the p1 cursor, left
; it loads into the correct spot, no need to move it
btst #0, $PLAY_MODE ; is player 1 playing?
beq skipPlayer1Cursor ; no? no need for their cursor
btst #7, $PLAY_MODE ; is this a subsequent single player match? this covers re-randomize case too
bne skipPlayer1Cursor ; yes ? no need for their cursor

move.w #$P1_CURSOR_LEFT_SI, D6
lea $2P1_CURSOR_LEFT_WHITE_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the p1 cursor, right
; it loads into the correct spot, no need to move it
move.w #$P1_CURSOR_RIGHT_SI, D6
lea $2P1_CURSOR_RIGHT_WHITE_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

skipPlayer1Cursor:

btst #1, $PLAY_MODE ; is player 2 playing?
beq skipPlayer2Cursor ; no? no need for their cursor
btst #7, $PLAY_MODE ; is this a subsequent single player match? this covers re-randomize case too
bne skipPlayer2Cursor ; yes ? no need for their cursor

; load the p2 cursor, left
; it loads into the correct spot, no need to move it
move.w #$P2_CURSOR_LEFT_SI, D6
lea $2P2_CURSOR_LEFT_WHITE_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the p2 cursor, right
; it loads into the correct spot, no need to move it
move.w #$P2_CURSOR_RIGHT_SI, D6
lea $2P2_CURSOR_RIGHT_WHITE_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

skipPlayer2Cursor:

;;;;;;;;;;; END LOAD CURSORS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; get read to either show or hide the version string, based on if start is pressed during main
move.w #$7077, $VSTRING_DATA ; load where in the fix layer it should go
move.l #$2VERSION, $VSTRING_DATA + 2


bsr renderChosenAvatars

cmpi.b #0, $PLAY_MODE
beq skipGreyOut ; don't grey out in demo mode
cmpi.b #3, $PLAY_MODE
beq skipGreyOut ; don't grey out in versus mode
jsr $2GREY_OUT_CHARACTERS
skipGreyOut:

rts


;;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;

;; clearDefeatedCharBytes
;; sets the defeated char bits all to zero for a fresh start
clearDefeatedCharBytes:
move.l #0, $CPU_DEFEATED_CHARACTERS
rts


;; setDefeatedCharBytes
;; flips bits based on the cpu team that just lost
;; so the player doesn't fight these characters again in one playthrough
;;
;; parameters
;; A0: The cpu team list
setDefeatedCharBytes:
move.l $CPU_DEFEATED_CHARACTERS, D2
move.b (A0), D1
bset.l D1, D2
move.b $1(A0), D1
bset.l D1, D2
move.b $2(A0), D1
bset.l D1, D2
move.l D2, $CPU_DEFEATED_CHARACTERS
rts


;; consults the team defeat byte and sets
;; the already used indexes byte accordingly
setCpuAlreadyUsedIndex:

cmpi.b #0, $PLAY_MODE
bne setCpuAlreadyUsedIndex_skipDemoModeClear
;; this is demo mode. Clear out the byte altogether
;; to ensure demo mode can always select two random teams
;; this means in demo mode it can pick the same team multiple
;; times if you let demo mode run numerous times, but the original
;; game did that too
clr.b $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES
bra setCpuAlreadyUsedIndex_done

setCpuAlreadyUsedIndex_skipDemoModeClear:

cmpi.b #3, $PLAY_MODE
bne setCpuAlreadyUsedIndex_skipVersusModeClear
;; this is versus mode. Same idea, just clear the byte out.
clr.b $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES
bra setCpuAlreadyUsedIndex_done

setCpuAlreadyUsedIndex_skipVersusModeClear:

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
move.w #1, D6 ; first avatar of p1 team
clr.w D7
move.b $P1_CHOSEN_CHAR0, D7
move.b $P1_CHOSEN_CHAR0 + 3, D4 ; palette flag
jsr $2RENDER_CHOSEN_AVATAR

; if they chose Rugal, we are done
cmpi.b #$18, $P1_CHOSEN_CHAR0
beq renderChosenAvatar_skipPlayer1

move.w #2, D6 ; second avatar of p1 team
clr.w D7
move.b $P1_CHOSEN_CHAR1, D7
move.b $P1_CHOSEN_CHAR1 + 3, D4 ; palette flag
jsr $2RENDER_CHOSEN_AVATAR
move.w #3, D6 ; third avatar of p1 team
clr.w D7
move.b $P1_CHOSEN_CHAR2, D7
move.b $P1_CHOSEN_CHAR2 + 3, D4 ; palette flag
jsr $2RENDER_CHOSEN_AVATAR

renderChosenAvatar_skipPlayer1:
;; player 2
tst.b $P2_NUM_CHOSEN_CHARS
beq renderChosenAvatar_skipPlayer2 ; none chosen? nothing to do
;; if we get here, we know all three have been chosen
move.w #4, D6 ; first avatar of p2 team 
clr.w D7
move.b $P2_CHOSEN_CHAR0, D7
move.b $P2_CHOSEN_CHAR0 + 3, D4 ; palette flag
jsr $2RENDER_CHOSEN_AVATAR

; if they chose Rugal, we are done
cmpi.b #$18, $P2_CHOSEN_CHAR0
beq renderChosenAvatar_skipPlayer2

move.w #5, D6 ; second avatar of p2 team
clr.w D7
move.b $P2_CHOSEN_CHAR1, D7
move.b $P2_CHOSEN_CHAR1 + 3, D4 ; palette flag
jsr $2RENDER_CHOSEN_AVATAR
move.w #6, D6 ; third avatar of p2 team
clr.w D7
move.b $P2_CHOSEN_CHAR2, D7
move.b $P2_CHOSEN_CHAR2 + 3, D4 ; palette flag
jsr $2RENDER_CHOSEN_AVATAR

renderChosenAvatar_skipPlayer2:
rts



