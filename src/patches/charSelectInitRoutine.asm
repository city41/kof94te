;; reset the player mode, we'll figure it out through the course of init
;; 
;; NUM_PLAYER_MODE values:
;; 0 - undetermined
;; 1 - single player, p1 side (bit 0 is set)
;; 2 - single player, p2 side (bit 1 is set)
;; 3 - versus mode (bit 0 and 1 are set)
move.b #0, $NUM_PLAYER_MODE

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
ori.b #1, $NUM_PLAYER_MODE

; load the p1 cursor
; it loads into the correct spot, no need to move it
move.w #$P1_CURSOR_SI, D6
lea $2P1_CURSOR_IMAGE, A6
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
move.w #$P2_CURSOR_SI, D6
lea $2CPU_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the cpu cursor, right side
; it loads itself off screen, no need to move it
move.w #$P2_CURSOR_SI + 1, D6
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
ori.b #2, $NUM_PLAYER_MODE

; load the p2 cursor
; it loads into the correct spot, no need to move it
move.w #$P2_CURSOR_SI, D6
lea $2P2_CURSOR_IMAGE, A6
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
move.w #$P1_CURSOR_SI, D6
lea $2CPU_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the cpu cursor, right side
; it loads itself off screen, no need to move it
move.w #$P1_CURSOR_SI + 1, D6
lea $2CPU_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE
;;;;;;;;;;;;;;;; END INIT PLAYER 2 ;;;;;;;;;;;;;;

skipPlayer2:



;; GENERAL VALUE INITIALIZATION
cmpi.b #0, $DEFEATED_TEAMS ; if there are zero defeated teams
bne skipResetIndexes
move.b #0, $CPU_RANDOM_SELECT_ALREADY_USED_INDEXES ; then reset the rng tracker byte
skipResetIndexes:

move.b #1, $IN_CHAR_SELECT_FLAG
move.b #0, $SINGLE_PLAYER_PAST_FIRST_FIGHT


btst #0, $NUM_PLAYER_MODE
beq p1_pastReady ; p1 isn't playing? skip
btst #1, $NUM_PLAYER_MODE ; but p2 is playing too? versus mode, skip
; jumping here sets up char select well for versus mode
; but it does let p1 rechoose their team. The original game did not do this
; but it's a nice bonus, so letting it slide
bne p1_firstCharSelect

; single player mode, p1 side
cmpi.b #$80, $108238 ; player 1 is human, did they lose?
;; if it is $80, then they lost and they continued, this is the very first char select
beq p1_firstCharSelect
cmpi.b #$80, $108438
bne p1_firstCharSelect ; if player 2 hasn't lost, then this is the first char select
;; set flag to indicate to main this is not the first char select
move.b #1, $SINGLE_PLAYER_PAST_FIRST_FIGHT
;; have main move onto cpu select right away
move.b #1, $READY_TO_EXIT_CHAR_SELECT
;; by setting to 3 chars, cpu randomization happens
move.b #3, $P1_NUM_CHOSEN_CHARS
bra p1_pastReady
p1_firstCharSelect: 
;; first time in char select for single player, p1 side
move.b #0, $READY_TO_EXIT_CHAR_SELECT
move.b #0, $P1_NUM_CHOSEN_CHARS
p1_pastReady:

btst #1, $NUM_PLAYER_MODE
beq p2_pastReady ; p2 isn't playing? skip
btst #0, $NUM_PLAYER_MODE ; but p1 is playing too? versus mode, skip
; jumping here sets up char select well for versus mode
; but it does let p1 rechoose their team. The original game did not do this
; but it's a nice bonus, so letting it slide
bne p2_firstCharSelect

; single player mode, p2 side
cmpi.b #$80, $108438 ; player 2 is human, did they lose?
;; if it is $80, then they lost and they continued, this is the very first char select
beq p2_firstCharSelect
cmpi.b #$80, $108238
bne p2_firstCharSelect ; if player 1 hasn't lost, then this is the first char select
;; set flag to indicate to main this is not the first char select
move.b #1, $SINGLE_PLAYER_PAST_FIRST_FIGHT
;; have main move onto cpu select right away
move.b #1, $READY_TO_EXIT_CHAR_SELECT
;; by setting to 3 chars, cpu randomization happens
move.b #3, $P2_NUM_CHOSEN_CHARS
bra p2_pastReady
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

;; chosen team avatar related
move.w #32, $P1_CHOSEN_TEAM_SCREEN_X
move.w #32, $P1CTSX_MULTIPLIER
move.w #256, $P2_CHOSEN_TEAM_SCREEN_X
move.w #-32, $P2CTSX_MULTIPLIER

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