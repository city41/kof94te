;; sets a 0 (regular colors) or 1 (alternate colors) into D1
;; this is called just before the game loads palettes for characters
;;
;; needs to set color based on
;; - players choice (ie pressed A/B or C/D in char select for the given character)
;; - mirror matches, but only at the character level
;;    - if the cpu team also has the same character, give the cpu character the opposite color
;; 
;; see altColors.md for info on how to know what character is being loaded when this routine is called


;; store lots of stuff the game is using
movem.l A0-A6/D0/D2-D7, $MOVEM_STORAGE

;; figure out which character is loading
move.l A4, D6
cmpi.l #$100900, D6
beq fallingFighter
cmpi.l #$108100, D6 ; the team1 character that is about to fight
beq team1Character
cmpi.l #$108300, D6  ; the team2 character that is about to fight
beq team2Character
cmpi.l #$100500, D6  ; continue screen or cutscene2, char 1
beq continueScreenOrCutscene2
cmpi.l #$100700, D6  ; continue screen or cutscene2, char 2
beq continueScreenOrCutscene2
cmpi.l #$100900, D6  ; continue screen or cutscene2, char 3
beq continueScreenOrCutscene2
cmpi.l #$100B00, D6  ; continue screen or cutscene2, char 3
beq continueScreenOrCutscene2
cmpi.l #$10907c, D6  ; win screen, char 1
beq winScreen
cmpi.l #$10917c, D6  ; win screen, char 2
beq winScreen
cmpi.l #$10927c, D6  ; win screen, char 3, or Rugal's transformation cutscene
beq winScreenOrRugalBetweenRounds
move.l $84(A4), D6
cmpi.l #$108100, D6 ; a team1 character on the sidelines, or a character in order select
beq team1Character
cmpi.l #$108300, D6 ; a team2 character on the sidelines, or a character in order select
beq team2Character
bra defaultChoice ; something else like demo mode, how to play, etc. For now punting

winScreenOrRugalBetweenRounds:
cmpi.b #3, $PLAY_MODE
beq winScreen ; versus mode? def not Rugal then
cmpi.b #$ff, $DEFEATED_TEAMS
bne winScreen ; haven't beaten 8 teams? Must be a win screen
;; this is the between round cutscene for Rugal, it should be zero
move.b #0, D1
bra done

;; this is the fighter that just lost and is falling
;; btw the falling fighter char id is at 100971
fallingFighter:
;; the same conditions for falling fighter work for continue screen too
continueScreenOrCutscene2:
bsr checkIfJustLostToRugal ; a special case, losing to Rugal
cmpi.b #1, D1              ; will set D1=1 if a human player just lost to Rugal
beq playerIsContinuing
cmpi.b #$ff, $DEFEATED_TEAMS
beq winScreen ; if all teams are defeated, and they haven't lost to Rugal, then this is cutscene2, it's the same logic as winScreen

;; not the cutscene, must be continuing
playerIsContinuing:
cmpi.b #$80, $108238 ; did p1 lose?
beq team1Character   ; yup, p1 lost, team1Character can handle it from here
bra team2Character   ; p2 lost, team2Character can handle it from here

winScreen:
cmpi.b #$80, $108238 ; did p1 lose?
beq team2Character   ; yup, p1 lost, team2Character can handle it from here
bra team1Character   ; p2 lost, team1Character can handle it from here


team1Character:

;;; special case, demo mode. in demo mode, give p1 reg and p2 alt
cmpi.b #0, $PLAY_MODE
bne team1SkipDemoMode
move.b #0, D1
bra done

team1SkipDemoMode:

;; D0 is the character ID, but quadrupled
;; figure out which character it is in P1_CHOSEN_CHARX then do the subroutine
clr.w D6
move.b D0, D6 ; copy the quadrupled charid into d7
lsr.b #2, D6 ; un-quadruple it
cmp.b $P1_CHOSEN_CHAR0, D6
beq team1ChosenChar0
cmp.b $P1_CHOSEN_CHAR1, D6
beq team1ChosenChar1
bra team1ChosenChar2

team1ChosenChar0:
move.b #0, D5
move.b #0, D6
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR0, A6
bsr figureOutCharPalette
bra done

team1ChosenChar1:
move.b #0, D5
move.b #1, D6
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR0, A6
bsr figureOutCharPalette
bra done

team1ChosenChar2:
move.b #0, D5
move.b #2, D6
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR0, A6
bsr figureOutCharPalette
bra done

team2Character:
;;; special case, demo mode. in demo mode, give p1 reg and p2 alt
cmpi.b #0, $PLAY_MODE
bne team2SkipDemoMode
move.b #1, D1
bra done

team2SkipDemoMode:

;; D0 is the character ID, but quadrupled
;; figure out which character it is in P1_CHOSEN_CHARX then do the subroutine
clr.w D6
move.b D0, D6 ; copy the quadrupled charid into d7
lsr.b #2, D6 ; un-quadruple it
cmp.b $P2_CHOSEN_CHAR0, D6
beq team2ChosenChar0
cmp.b $P2_CHOSEN_CHAR1, D6
beq team2ChosenChar1
bra team2ChosenChar2

team2ChosenChar0:
move.b #1, D5
move.b #0, D6
lea $P2_CHOSEN_CHAR0, A5
lea $P1_CHOSEN_CHAR0, A6
bsr figureOutCharPalette
bra done

team2ChosenChar1:
move.b #1, D5
move.b #1, D6
lea $P2_CHOSEN_CHAR0, A5
lea $P1_CHOSEN_CHAR0, A6
bsr figureOutCharPalette
bra done

team2ChosenChar2:
move.b #1, D5
move.b #2, D6
lea $P2_CHOSEN_CHAR0, A5
lea $P1_CHOSEN_CHAR0, A6
bsr figureOutCharPalette
bra done




;; default, use regular colors
defaultChoice:
move.b #0, D1

done:
;;; restore stuff game was using
movem.l $MOVEM_STORAGE, A0-A6/D0/D2-D7
;;; restore what was clobbered
add.w D1, D1
rts


;; figureOutCharPalette
;; ------------------
;; subroutine that handles any character once the team and chosen index is known
;;
;; parameters
;; ----------
;; D5.b: player: 0 or 1
;; D6.b: char chosen index, 0, 1 or 2
;; A5: PTHIS_CHOSEN_CHAR0
;; A6: POTHER_CHOSEN_CHAR0
;;
;; return
;; ------
;; palette flag in D1
figureOutCharPalette:
btst D5, $PLAY_MODE
beq figureOutCharPalette_cpu ; jump ahead, this is a cpu player
movea.l A5, A4 ; copy the base address into A4, as we need to manipulate it
adda.w D6, A4 ;; add char index to offset into chosen characters list
adda.w #3, A4 ;; now jump to the palette flag list
move.b (A4), D1 ; load the palette flag from when the player chose it
bra figureOutCharPalette_done

figureOutCharPalette_cpu:
;; this is cpu, see if the cpu character is also on the other team
;; if it is, the cpu character gets the opposite palette flag

;; first, get the character on cpu team we are comparing
movea.l A5, A4 ; copy this team's base address into A4, as we need to manipulate it
adda.w D6, A4 ;; add char index to offset into chosen characters list
move.b (A4), D1 ;; load the character id

move.b (A6), D2 ; load the other team's first character
cmp.b D1, D2 ; does the other team's first character match the cpu character we are focused on?
bne figureOutCharPalette_cpu_checkChar1
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $3(A6), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D3, D2 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D2, D1 ; move the final answer into D1, where ultimately the game wants it
bra figureOutCharPalette_done

figureOutCharPalette_cpu_checkChar1:
move.b $1(A6), D2 ; load the other team's second character
cmp.b D1, D2
bne figureOutCharPalette_cpu_checkChar2
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $4(A6), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D3, D2 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D2, D1 ; move the final answer into D1, where ultimately the game wants it
bra figureOutCharPalette_done

figureOutCharPalette_cpu_checkChar2:
move.b $2(A6), D2 ; load the other team's third character
cmp.b D1, D2
bne figureOutCharPalette_defaultChoice ; chose a character the human didn't choose? just go with reg palette
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $5(A6), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D3, D2 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D2, D1 ; move the final answer into D1, where ultimately the game wants it
bra figureOutCharPalette_done

figureOutCharPalette_defaultChoice:
move.b #0, D1

figureOutCharPalette_done:
rts



;;;;;; SUBROUTINES ;;;;;;;;;;;;;;

;; checkIfJustLostToRugal
;; figures out if this is a single player game, and the human just lost to Rugal
;; 
;; returns
;; D1=1 if the player just lost to Rugal
;; D1=0 if the player did not just lose to Rugal
checkIfJustLostToRugal:
cmpi.b #3, $PLAY_MODE ; is this versus mode?
; if this is versus mode, then for sure they did not lose to Rugal
beq checkIfJustLostToRugal_didNotLose
cmpi.b #$ff, $DEFEATED_TEAMS
; if they haven't defeated all teams, then they haven't fought Rugal yet, so they can't have lost to him
bne checkIfJustLostToRugal_didNotLose

; ok all teams are defeated. See if p1 lost and p2 is Rugal
btst #0, $PLAY_MODE ; is player one playing?
beq checkIfJustLostToRugal_player2IsHuman

; player 1 is human
cmpi.b #$80, $108238 ; did p1 lose?
bne checkIfJustLostToRugal_didNotLose   ; p1 didn't lose, so they did not lose to Rugal
cmpi.b #8, $108431 ; ok, p1 lost, now is p2 Rugal?
bne checkIfJustLostToRugal_didNotLose   ; p2 isnt Rugal, so they did not lose to Rugal
bra checkIfJustLostToRugal_didLose ; by process of elimination, they must have just lost to Rugal

checkIfJustLostToRugal_player2IsHuman:
cmpi.b #$80, $108438 ; did p2 lose?
bne checkIfJustLostToRugal_didNotLose   ; p2 didn't lose, so they did not lose to Rugal
cmpi.b #8, $108231 ; ok, p2 lost, now is p1 Rugal?
bne checkIfJustLostToRugal_didNotLose   ; p1 isnt Rugal, so they did not lose to Rugal
bra checkIfJustLostToRugal_didLose ; by process of elimination, they must have just lost to Rugal

checkIfJustLostToRugal_didNotLose:
move.b #0, D1
bra checkIfJustLostToRugal_done

checkIfJustLostToRugal_didLose:
move.b #1, D1

checkIfJustLostToRugal_done:
rts
