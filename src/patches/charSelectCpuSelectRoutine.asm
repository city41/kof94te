; charSelectCpuSelectRoutine
; does everything related to the cpu choosing their team. 
; this can either be custom teams, or original 8 teams
; the hack handles both now

;; throttle back the speed of cpu random select
move.b $THROTTLE_COUNTER, D4
andi.b #$7, D4
;; if there are any lower bits, bail
;; this means only random select every 8 frames
bne done

subi.b #1, $CPU_CUSTOM_TEAMS_COUNTDOWN
beq done

;; did the player continue? If so, nothing to do here,
;; just leave the cpu cursors alone on the cpu team that  
;; the player will fight again
btst #6, $PLAY_MODE
bne done

;; is this the rugal fight?
cmpi.b #$ff, $DEFEATED_TEAMS
bne skipRugal
;; ok, this is Rugal. We just need to ensure he's set up
;; there's no cursor/random logic needed
bsr setCpuToRugal
bra done


skipRugal:

cmpi.b #0, $PLAY_MODE ; is this demo mode?
bne prepCustomCpuCursorForSinglePlayerMode
;; this is demo mode, there are two cpu cursors
;; p1 cpu
lea $P1_CUR_INPUT, A0
bsr pickCpuTeam
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0
jsr $2MOVE_CPU_CURSOR
;; p2 cpu
lea $P2_CUR_INPUT, A0
bsr pickCpuTeam
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
jsr $2MOVE_CPU_CURSOR
move.b #$60, $320000 ; play movement sfx
bra done

prepCustomCpuCursorForSinglePlayerMode:
btst #0, $PLAY_MODE ; is player one playing?
beq customCpu_loadPlayerDataSkipPlayer1
;; player 1 is human, load p2 for cpu
lea $P2_CUR_INPUT, A0
bra customCpu_doneLoadingPlayerData

customCpu_loadPlayerDataSkipPlayer1:
;; player 2 is human, load p1 for cpu
lea $P1_CUR_INPUT, A0
customCpu_doneLoadingPlayerData:

btst #6, $PLAY_MODE ; did the player just continue?
bne customCpu_skipPickCustomCpuTeam ; then don't pick a new team
bsr pickCpuTeam 
customCpu_skipPickCustomCpuTeam:

btst #0, $PLAY_MODE
beq customCpu_loadSiSkipPlayer1
move.w #$P2_CPU_CURSOR_CHAR1_LEFT_SI, D0
bra customCpu_doneLoadSi

customCpu_loadSiSkipPlayer1:
move.w #$P1_CPU_CURSOR_CHAR1_LEFT_SI, D0

customCpu_doneLoadSi:
jsr $2MOVE_CPU_CURSOR
move.b #$60, $320000 ; play movement sfx

done:
rts

;;;;; SUBROUTINES ;;;;;;

;; getRandomCharacterId
;; gets a random character Id and places it in D0
;; does not choose a character if it is already on the team,
;; or if that character has already been defeated
;; used for custom cpu teams
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

;; first, has this character been defeated before?
move.l $CPU_DEFEATED_CHARACTERS, D1
btst.l D0, D1
bne getRandomCharacterId_pickRandomChar ; this character has already been defeated, try again

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

;; pickCpuCustomTeam
;; chooses a custom cpu team
;;
;; parameters
;; A0: pointer to a player's base data
pickCpuCustomTeam:
;; make sure we have moved to an undefeated team
jsr $2DETERMINE_CPU_NEXT_STAGE
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

rts

;; pickCpuO8Team
;; choose an o8 cpu team
;;
;; parameters
;; A0: pointer to player's base data
pickCpuO8Team:
;; get an undefeated team and store it as the cpu's team id 
;; this leaves the team id in D0
jsr $2DETERMINE_CPU_NEXT_STAGE
;; now get a pointer to the team's character ids
lea $534DC, A3 ; load the starting team->character list address
mulu.w #4, D0  ; multiply team id by 4, as there are 4 bytes per team (three characters and a ff delimiter)
adda.w D0, A3  ; move into the list to the correct team
move.b (A3)+, $PX_CHOSEN_CHAR0_OFFSET(A0)
move.b (A3)+, $PX_CHOSEN_CHAR1_OFFSET(A0)
move.b (A3)+, $PX_CHOSEN_CHAR2_OFFSET(A0)
move.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)
rts




;; pickCpuTeam
;; loads up all three characters onto a cpu team,
;; accounting for custom vs o8 teams
;;
;; parameters
;; A0: pointer to a player's base data
pickCpuTeam:
cmpi.b #1, $CPU_CUSTOM_TEAMS_FLAG
beq pickCpuTeam_custom
bsr pickCpuO8Team
bra pickCpuTeam_done

pickCpuTeam_custom:
bsr pickCpuCustomTeam

pickCpuTeam_done:
rts


;; setCpuToRugal
;; when it's time to fight Rugal, this routine
;; makes sure everything about the fight is all set up
setCpuToRugal:
btst #0, $PLAY_MODE ; is player one playing?
beq setCpuToRugal_loadPlayerDataSkipPlayer1
;; player 1 is human, load p2 for cpu
lea $P2_CUR_INPUT, A0
move.b #8, $108431 ; make sure team 2 is Rugal
bra setCpuToRugal_doneLoadingPlayerData

setCpuToRugal_loadPlayerDataSkipPlayer1:
;; player 2 is human, load p1 for cpu
lea $P1_CUR_INPUT, A0
move.b #8, $108231 ; make sure team 1 is Rugal

setCpuToRugal_doneLoadingPlayerData:

move.b #$18, $PX_CHOSEN_CHAR0_OFFSET(A0)
move.b #$19, $PX_CHOSEN_CHAR1_OFFSET(A0)
move.b #$19, $PX_CHOSEN_CHAR2_OFFSET(A0)
move.b #3, $PX_NUM_CHOSEN_CHARS_OFFSET(A0)

; and let's drain the countdown so you don't sit on char select too long
move.b #0, $CPU_CUSTOM_TEAMS_COUNTDOWN

rts