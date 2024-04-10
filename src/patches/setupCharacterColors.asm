;; sets a 0 (regular colors) or 1 (alternate colors) into D1
;; this is called just before the game loads palettes for characters
;;
;; needs to set color based on
;; - players choice (ie pressed A/B or C/D in char select for the given character)
;; - mirror matches, but only at the character level
;;    - if the cpu team also has the same character, give the cpu character the opposite color
;; TODO: versus mode where both players press C/D on the same character?

;; first, what character are we dealing with?
;; 101500 -- Terry in How to Play
;; 101700 -- Ryo in How to Play
;;
;; Order Select ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 102900 -- team 1, char 0 in team/order select
;; 102b00 -- team 1, char 1 in team/order select
;; 102d00 -- team 1, char 2 in team/order select
;; NOTE: team 2 characters are likely flipped in order
;; 102f00 -- team 2, char 0 in team/order select
;; 103100 -- team 2, char 1 in team/order select
;; 103300 -- team 2, char 2 in team/order select
;;
;; The Match ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NOTE: the character order is based on their fight order, not selection order
;; So if the player chooses their first character with D, but has that character fight
;; second, then the second character here should get the alt palette
;; 108100 -- team 1, char 0 in the match and demo
;; 108300 -- team 1, char 1 in the match and demo
;; 102300 -- team 1, char 2 in the match and demo
;; NOTE: team 2 characters are likely flipped in order
;; 102500 -- team 2, char 0 in the match and demo
;; 102900 -- team 2, char 1 in the match and demo
;; 102B00 -- team 2, char 2 in the match and demo

;; store lots of stuff the game is using
movem.l A4-A6/D5/D6, $MOVEM_STORAGE

; move.b $AFTER_CHAR_SELECT_FLAG, D7
; beq defaultChoice
; addi.b #1, $SET_CHAR_COLORS_COUNTER
; move.b $SET_CHAR_COLORS_COUNTER, D7
move.b #1, D1
bra done

;; order select
;; it calls in this order
;; team 1, first fighter
;; team 1, second fighter
;; team 1, third fighter
;; team 2, first fighter
;; team 2, second fighter
;; team 2, third fighter
cmpi.b #1, D7
beq doTeam1Char0ForOrderSelect
cmpi.b #2, D7
beq doTeam1Char1ForOrderSelect
cmpi.b #3, D7
beq doTeam1Char2ForOrderSelect
cmpi.b #4, D7
beq doTeam2Char0ForOrderSelect
cmpi.b #5, D7
beq doTeam2Char1ForOrderSelect
cmpi.b #6, D7
beq doTeam2Char2ForOrderSelect

;; the match
;; it calls in this order
;; team 1, first fighter
;; team 2, first fighter
;; team 1, second fighter
;; team 1, third fighter
;; team 2, second fighter
;; team 2, third fighter

cmpi.b #7, D7
beq doTeam1Char0ForFight
cmpi.b #8, D7
beq doTeam2Char0ForFight
cmpi.b #9, D7
beq doTeam1Char1ForFight
cmpi.b #10, D7
beq doTeam1Char2ForFight
cmpi.b #11, D7
beq doTeam2Char1ForFight
cmpi.b #12, D7
beq doTeam2Char2ForFight

;; default, use regular colors
defaultChoice:
move.b #0, D1
bra done

doTeam1Char0ForOrderSelect:
move.b #0, D5
move.b #0, D6
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR2, A6
bsr charForOrderSelect
bra done


doTeam1Char1ForOrderSelect:
move.b #0, D5
move.b #1, D6
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR2, A6
bsr charForOrderSelect
bra done

doTeam1Char2ForOrderSelect:
move.b #0, D5
move.b #2, D6
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR2, A6
bsr charForOrderSelect
bra done

doTeam1Char0ForFight:
move.b #0, D5
move.w #0, D6
lea $P1_CHOSEN_CHARS_IN_ORDER_OF_FIGHTING, A4
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR2, A6
bsr charForFight
bra done

doTeam1Char1ForFight:
move.b #0, D5
move.w #1, D6
lea $P1_CHOSEN_CHARS_IN_ORDER_OF_FIGHTING, A4
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR2, A6
bsr charForFight
bra done

doTeam1Char2ForFight:
move.b #0, D5
move.w #2, D6
lea $P1_CHOSEN_CHARS_IN_ORDER_OF_FIGHTING, A4
lea $P1_CHOSEN_CHAR0, A5
lea $P2_CHOSEN_CHAR2, A6
bsr charForFight
bra done

doTeam2Char0ForOrderSelect:
move.b #1, D5
move.b #0, D6
lea $P2_CHOSEN_CHAR2, A5
lea $P1_CHOSEN_CHAR0, A6
bsr charForOrderSelect
bra done


doTeam2Char1ForOrderSelect:
move.b #1, D5
move.b #1, D6
lea $P2_CHOSEN_CHAR2, A5
lea $P1_CHOSEN_CHAR0, A6
bsr charForOrderSelect
bra done

doTeam2Char2ForOrderSelect:
move.b #1, D5
move.b #2, D6
lea $P2_CHOSEN_CHAR2, A5
lea $P1_CHOSEN_CHAR0, A6
bsr charForOrderSelect
bra done

doTeam2Char0ForFight:
move.b #1, D5
move.w #0, D6
lea $P2_CHOSEN_CHARS_IN_ORDER_OF_FIGHTING, A4
lea $P2_CHOSEN_CHAR2, A5
lea $P1_CHOSEN_CHAR0, A6
bsr charForFight
bra done

doTeam2Char1ForFight:
move.b #1, D5
move.w #1, D6
lea $P2_CHOSEN_CHARS_IN_ORDER_OF_FIGHTING, A4
lea $P2_CHOSEN_CHAR2, A5
lea $P1_CHOSEN_CHAR0, A6
bsr charForFight
bra done

doTeam2Char2ForFight:
move.b #1, D5
move.w #2, D6
lea $P2_CHOSEN_CHARS_IN_ORDER_OF_FIGHTING, A4
lea $P2_CHOSEN_CHAR2, A5
lea $P1_CHOSEN_CHAR0, A6
bsr charForFight
bra done

done:
;;; restore stuff game was using
movem.l $MOVEM_STORAGE, A4-A6/D5/D6
;;; restore what was clobbered
add.w D1, D1
rts


;; charForOrderSelect
;; ------------------
;; subroutine that handles any order select character for either team
;;
;; parameters
;; ----------
;; D5.b: player: 0 or 1
;; D6.b: char index, 0, 1 or 2
;; A5: PTHIS_CHOSEN_CHAR0
;; A6: POTHER_CHOSEN_CHAR0
;;
;; return
;; ------
;; palette flag in D1

charForOrderSelect:
btst D5, $NUM_PLAYER_MODE
beq charForOrderSelect_cpu ; jump ahead, this is a cpu player
movea.l A5, A4 ; copy the base address into A4, as we need to manipulate it
adda.w D6, A4 ;; add char index to offset into chosen characters list
adda.w D6, A4 ;; add it twice since each character is a word
adda.w #1, A4 ;; add one more to get to the palette flag for that character
move.b (A4), D1 ; load the palette flag from when the player chose it
bra charForOrderSelect_done

charForOrderSelect_cpu:
;; this is cpu, see if the cpu character is also on the other team
;; if it is, the cpu character gets the opposite palette flag

;; first, get the character on cpu team we are comparing
movea.l A5, A4 ; copy this team's base address into A4, as we need to manipulate it
adda.w D6, A4 ;; add char index to offset into chosen characters list
adda.w D6, A4 ;; add it twice since each character is a word
move.b (A4), D1 ;; load the character id

move.b (A6), D2 ; load the other team's first character
cmp.b D1, D2 ; does the other team's first character match the cpu character we are focused on?
bne charForOrderSelect_cpu_checkChar1
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $1(A6), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D2, D3 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D3, D1 ; move the final answer into D1, where ultimately the game wants it
bra charForOrderSelect_done

charForOrderSelect_cpu_checkChar1:
move.b $2(A6), D2 ; load the other team's second character
cmp.b D1, D2
bne charForOrderSelect_cpu_checkChar2
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $3(A6), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D2, D3 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D3, D1 ; move the final answer into D1, where ultimately the game wants it
bra charForOrderSelect_done

charForOrderSelect_cpu_checkChar2:
move.b $4(A6), D2 ; load the other team's third character
cmp.b D1, D2
bne charForOrderSelect_defaultChoice ; chose a character the human didn't choose? just go with reg palette
;; the cpu chose a character that the human chose, take the human's palette
;; flag and flip it
move.b $5(A6), D3 ; get the other team's character's palette flag
move.b #1, D2
sub.b D2, D3 ; do flippedFlag = 1 - flag, go from 0->1 or 1->0
move.b D3, D1 ; move the final answer into D1, where ultimately the game wants it
bra charForOrderSelect_done

charForOrderSelect_defaultChoice:
move.b #0, D1

charForOrderSelect_done:
rts


;; charForFight
;; ------------
;; subroutine that handles any fight character for either team
;; a "fight character" is the version of the character that is used for the match itself
;;
;; NOTE: this routine doesn't care about player vs cpu because it will jump into charForOrderSelect
;;
;; parameters
;; ----------
;; D5.b: player: 0 or 1
;; D6.w: char index, 0, 1 or 2
;; A4: PTHIS_CHOSEN_CHARS_IN_ORDER_OF_FIGHTING
;; A5: PTHIS_CHOSEN_CHAR0
;; A6: POTHER_CHOSEN_CHAR0
;;
;; return
;; ------
;; palette flag in D1
charForFight:
move.b (A5), D1 ; load this team's first chosen character
cmp.b (A4, D6.w), D1 ; is the first chosen character the one we are setting up to fight?
beq charForFight_doTeamXChar0ForOrderSelect ; yes? then go off and get the palette flag
move.b $2(A5), D1 ; no? load this team's second chosen character
cmp.b (A4, D6.w), D1 ; is this second chosen character the one we are setting up to fight?
beq charForFight_doTeamXChar1ForOrderSelect ; yes ? then go off and get the palette flag
bra charForFight_doTeamXChar2ForOrderSelect ; no? must be the third character then

charForFight_doTeamXChar0ForOrderSelect:
move.b #0, D6
bsr charForOrderSelect
bra charForFight_done

charForFight_doTeamXChar1ForOrderSelect:
move.b #1, D6
bsr charForOrderSelect
bra charForFight_done

charForFight_doTeamXChar2ForOrderSelect:
move.b #2, D6
bsr charForOrderSelect
bra charForFight_done

charForFight_done:
rts