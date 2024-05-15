; first, did the player choose an original 8 team?
; if so, make sure that is the team id that is set then bail
; let the original cutscenes run

movem.l D6, $MOVEM_STORAGE

btst #0, $PLAY_MODE
beq checkOriginal8Player2
cmpi.b #$ff, $P1_ORIGINAL_TEAM_ID
beq notAnOriginalTeam
move.b $P1_ORIGINAL_TEAM_ID, $108231
bra doVanilla

checkOriginal8Player2:
cmpi.b #$ff, $P2_ORIGINAL_TEAM_ID
beq notAnOriginalTeam
move.b $P2_ORIGINAL_TEAM_ID, $108431
bra doVanilla

doVanilla:
;; do what the original game does
;; except dont increment, as done will do that
move.w (A6), $70(A1)
bra done


notAnOriginalTeam:
;; the character Id needs to get written as a word to $70(A1)

move.l A6, D6
cmpi.l #$3e7a2, D6 ; USA, character 1
beq doCharOne 
cmpi.l #$3e78a, D6 ; Japan, character 1
beq doCharOne 
cmpi.l #$3e7ea, D6 ; Mexico, character 1
beq doCharOne 
cmpi.l #$3e802, D6 ; England, character 1
beq doCharOne 

cmpi.l #$3e7aa, D6 ; USA, character 2
beq doCharTwo
cmpi.l #$3e792, D6 ; Japan, character 2
beq doCharTwo
cmpi.l #$3e7f2, D6 ; Mexico, character 2
beq doCharTwo
cmpi.l #$3e80a, D6 ; England, character 2
beq doCharTwo

;; at this point it must be character 3, regardless of team
bra doCharThree


doCharOne:
clr.w D6
btst #0, $PLAY_MODE
beq doCharOnePlayer2
move.b $P1_CHOSEN_CHAR0, D6
bra charDone
doCharOnePlayer2:
move.b $P2_CHOSEN_CHAR2, D6
bra charDone

doCharTwo:
clr.w D6
btst #0, $PLAY_MODE
beq doCharTwoPlayer2
move.b $P1_CHOSEN_CHAR1, D6
bra charDone
doCharTwoPlayer2:
move.b $P2_CHOSEN_CHAR1, D6
bra charDone

doCharThree:
clr.w D6
btst #0, $PLAY_MODE
beq doCharThreePlayer2
move.b $P1_CHOSEN_CHAR2, D6
bra charDone
doCharThreePlayer2:
move.b $P2_CHOSEN_CHAR0, D6

charDone:
move.w D6, $70(A1)

done:
;;;; restore what was clobbered
adda.w #2, A6
move.w (A6)+, $18(A1)
movem.l $MOVEM_STORAGE, D6
rts