; originally 36e66 called these routines to set things up
; so far, just blindly calling them too
; jsr $3604
; jsr $15a0
; jsr $25aa
; jsr $5e72
; ; this is the bios routine for clearing all sprites
; jsr $c004c8

; load the palettes
; TODO: this should be done during vblank
jsr $2LOAD_P_A_L_E_T_T_E_S

; load the character grid image onto the screen
move.w #$GRID_IMAGE_SI, D6 ; set sprite index
move.w #0, D5              ; offset into tile data
lea $2CHARACTER_GRID_IMAGE, A6 ; load the image pointer
jsr $2RENDER_STATIC_IMAGE

;;;;;;;;;;;;;; INIT PLAYER 1 ;;;;;;;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD1, D6 ; are they even playing?
beq skipPlayer1 ; no? check player 2

; load the p1 cursor, onto the screen
; it loads into the correct spot, no need to move it
move.w #$P1_CURSOR_SI, D6
lea $2P1_CURSOR_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; initialize cursor's location
; this is a 2d index into the grid, not pixels
move.w #0, $P1_CURSOR_X ; start at Terry
move.w #0, $P1_CURSOR_Y
move.b #0, $P1_NUM_CHOSEN_CHARS

;;;;;;;;;;;;;;; INIT CPU AGAINST P1 ;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD2, D6 ; are they even playing?
bne skipPlayer1 ; player 2 is playing, this is versus mode, so don't do cpu
; load the cpu cursor, left side, onto the screen
; it loads itself off screen, no need to move it
move.w #$P2_CURSOR_SI, D6
lea $2CPU_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the cpu cursor, right side, onto the screen
; it loads itself off screen, no need to move it
move.w #$P2_CURSOR_SI + 1, D6
lea $2CPU_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE
;;;;;;;;;;;;;;;; END INIT PLAYER 1 ;;;;;;;;;;;;;;

skipPlayer1:

;;;;;;;;;;;;;; INIT PLAYER 2 ;;;;;;;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD2, D6
beq skipPlayer2 ; skip if p2 is not playing

; load the p2 cursor, onto the screen
; it loads into the correct spot, no need to move it
move.w #$P2_CURSOR_SI, D6
lea $2P2_CURSOR_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; initialize cursor's location
; this is a 2d index into the grid, not pixels
move.w #8, $P2_CURSOR_X ; start at Clark
move.w #0, $P2_CURSOR_Y
move.b #0, $P2_NUM_CHOSEN_CHARS

;;;;;;;;;;;;;;; INIT CPU AGAINST P2 ;;;;;;;;;;;;;;
move.b $BIOS_PLAYER_MOD1, D6 ; are they even playing?
bne skipPlayer2 ; player 1 is playing, this is versus mode, so don't do cpu
; load the cpu cursor, left side, onto the screen
; it loads itself off screen, no need to move it
move.w #$P1_CURSOR_SI, D6
lea $2CPU_CURSOR_LEFT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE

; load the cpu cursor, right side, onto the screen
; it loads itself off screen, no need to move it
move.w #$P1_CURSOR_SI + 1, D6
lea $2CPU_CURSOR_RIGHT_IMAGE, A6
move.w #0, D5              ; offset into tile data
jsr $2RENDER_STATIC_IMAGE
;;;;;;;;;;;;;;;; END INIT PLAYER 2 ;;;;;;;;;;;;;;

skipPlayer2:



;; GENERAL VALUE INITIALIZATION
move.b #1, $IN_CHAR_SELECT_FLAG

;; focused character names
move.w #$P1_FOCUSED_NAME_FIX_ADDRESS_VALUE, $P1_FOCUSED_CHAR_NAME_FIX_ADDRESS
move.l #$2P1_CHAR_NAME_TABLE, $P1_CHAR_NAME_TABLE_ADDRESS
move.w #$P2_FOCUSED_NAME_FIX_ADDRESS_VALUE, $P2_FOCUSED_CHAR_NAME_FIX_ADDRESS
move.l #$2P2_CHAR_NAME_TABLE, $P2_CHAR_NAME_TABLE_ADDRESS

;; chosen team avatars
move.w #32, $P1_CHOSEN_TEAM_SCREEN_X
move.w #32, $P1CTSX_MULTIPLIER
move.w #256, $P2_CHOSEN_TEAM_SCREEN_X
move.w #-32, $P2CTSX_MULTIPLIER


rts