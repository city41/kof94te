;;; cutscene 3: make Joe, Yuri and Heavy the three characters.

;; Assumes team USA is the set team ID, but it could also be Japan (2), Mexico (6) or England (7)
;; the assumption is in the cmpi.l's, they are checking for USA specific pointers
;;
;; the character Id needs to get written as a word to $70(A1)

movem.l D6, $MOVEM_STORAGE
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