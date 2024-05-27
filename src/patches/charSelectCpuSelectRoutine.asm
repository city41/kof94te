; charSelectCpuSelectRoutine
; does everything related to the cpu choosing their team. 
; this is either the place where cpu custom teal select happens
; or if not using cpu custom teams, just uses the original game's
; routine and visualizes it

cmpi.b #1, $CPU_CUSTOM_TEAMS_FLAG
bne doOriginal8
cmpi.b #$ff, $DEFEATED_TEAMS ; have all the teams been defeated?
beq doOriginal8 ; if so, doOriginal8 can handle Rugal

;; throttle back the speed of cpu random select
move.b $CHAR_SELECT_COUNTER, D4
andi.b #$7, D4
;; if there are any lower bits, bail
;; this means only random select every 8 frames
bne done
;; TODO: this only works with human on p1 (ie cpu is p2)

;; reset back to zero characters
btst #0, $PLAY_MODE ; is player one playing?
beq customCpu_loadPlayerDataSkipPlayer1
;; player 1 is human, load p2 for cpu
lea $P2_CUR_INPUT, A0
bra customCpu_doneLoadingPlayerData
customCpu_loadPlayerDataSkipPlayer1:
;; player 2 is human, load p1 for cpu
lea $P1_CUR_INPUT, A0

customCpu_doneLoadingPlayerData:

move.b #0, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)

bsr getRandomCharacterId
move.b D0, $PX_CHOSEN_CHAR0_OFFSET(A0)
addi.b #1, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)

bsr getRandomCharacterId
move.b D0, $PX_CHOSEN_CHAR1_OFFSET(A0)
addi.b #1, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)

bsr getRandomCharacterId
move.b D0, $PX_CHOSEN_CHAR2_OFFSET(A0)
addi.b #1, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)

btst #0, $PLAY_MODE
beq customCpu_loadSiSkipPlayer1
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
bra customCpu_doneLoadSi

customCpu_loadSiSkipPlayer1:
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0

customCpu_doneLoadSi:
jsr $2MOVE_CPU_CUSTOM_CURSOR
bra done

doOriginal8:

cmpi.b #0, $PLAY_MODE ; is this demo mode?
bne prepCpuCursorForSinglePlayerMode
;; this is demo mode, there are two cpu cursors
;; first, cpu 1
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D7 
lea $1081c0, A0           ; point to where the cpu index is for p1
jsr $2MOVE_CPU_CURSOR
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D7 ; use player two's cursor sprites
lea $1083c0, A0           ; point to where the cpu index is for p2
jsr $2MOVE_CPU_CURSOR
bra done

prepCpuCursorForSinglePlayerMode:
btst #0, $PLAY_MODE ; is p1 playing?
beq cpuCursor_skipPlayer1
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D7 ; use player two's cursor sprites
lea $1083c0, A0           ; point to where the cpu index is for p1
bra doCpuCursor

cpuCursor_skipPlayer1:
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D7 ; use player one's cursor sprites
lea $1081c0, A0           ; point to where the cpu index is for p2

doCpuCursor:
jsr $2MOVE_CPU_CURSOR

done:
rts

;;;;; SUBROUTINES ;;;;;;

;; getRandomCharacterId
;; gets a random character Id and places it in D0
;; does not choose a character if it is already on the team
;;
;; parameters
;; A0: pointer to player's base data

getRandomCharacterId:
getRandomCharacterId_pickRandomChar:
movem.l A0, $MOVEM_STORAGE ; game's rng uses A0
jsr $2582 ; call the game's rng, it leaves a random byte in D0
movem.l $MOVEM_STORAGE, A0
andi.b #$1f, D0 ; chop the random byte down to 5 bits -> 0 through 31
cmpi.b #24, D0
bge getRandomCharacterId_pickRandomChar ;; it was too big, try again

;; ok we got a character, but are they already on the team?
cmpi.b #0, $PX_NUM_CHOSEN_CHARS_OFFSET(A0) ; have they not chosen any characters yet?
beq getRandomCharacterId_done              ; then we are good

;; ok now let's check their first character
lea $PX_CHOSEN_CHAR0_OFFSET(A0), A2
cmp.b (A2), D0 ; did we just pick the first character again?
beq getRandomCharacterId_pickRandomChar ; yes? choose again

cmpi.b #1, $PX_NUM_CHOSEN_CHARS_OFFSET(A0) ; have they only chosen one character?
ble getRandomCharacterId_done              ; then we are good

;; check their second character
adda.w #1, A2 ; move to next character
cmp.b (A2), D0 ; did we just pick the second character again?
beq getRandomCharacterId_pickRandomChar ; yes? choose again

cmpi.b #2, $PX_NUM_CHOSEN_CHARS_OFFSET(A0) ; have they only chosen two characters?
ble getRandomCharacterId_done              ; then we are good

;; check their second character
adda.w #1, A2 ; move to next character
cmp.b (A2), D0 ; did we just pick the third character again?
beq getRandomCharacterId_pickRandomChar ; yes? choose again

;; the chosen character is not on the team, we are good
getRandomCharacterId_done:
rts