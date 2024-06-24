;; size the logo/countries back up to 16 so they display in order select
;; this enables order select to be just like in the original game,
;; while char select is clean
bsr restoreLogo
; move.w #129, D0
; move.w #32, D1
; move.w #496, D2 ; y = 0
; jsr $2MOVE_SPRITE

move.b #0, $IN_CHAR_SELECT_FLAG
move.b #0, $MAIN_HACK_PHASE

movem.l A4, $MOVEM_STORAGE

;; move player 1's choices where the game expects them
lea $P1_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING, A4

btst #0, $PLAY_MODE ; is p1 playing?
beq player1IsCpu ; oh p1 is cpu, jump ahead

; they are playing, move their choices where the game expects them 
move.b $P1_CHOSEN_CHAR0, D7
move.b D7, (A4)

move.b $P1_CHOSEN_CHAR1, D7
move.b D7, $1(A4)

move.b $P1_CHOSEN_CHAR2, D7
move.b D7, $2(A4)

lea $P1_CUR_INPUT, A0
;; if they chose an original team, we will
;; figure it out and store which team it was
jsr $2SET_ORIGINAL_TEAM_ID

cmpi.b #$18, $P1_CHOSEN_CHAR0
bne player1Done
;; they chose Rugal, make sure their team is Rugal too
move.b #8, $108231

bra player1Done

player1IsCpu:
;; saved into P1_CHOSEN_CHARX, move it to where the game expects it
move.b $P1_CHOSEN_CHAR0, (A4)
move.b $P1_CHOSEN_CHAR1, $1(A4)
move.b $P1_CHOSEN_CHAR2, $2(A4)

;; store the team id to enable continuing
move.b $108231, $1087e0


player1Done:

;; move player 2's choices where the game expects them
lea $P2_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING, A4

btst #1, $PLAY_MODE ; is p2 playing?
beq player2IsCpu ; oh p2 is cpu, jump ahed

; they are playing, move their choses where the game expects them 
move.b $P2_CHOSEN_CHAR2, D7
move.b D7, (A4)

move.b $P2_CHOSEN_CHAR1, D7
move.b D7, $1(A4)

move.b $P2_CHOSEN_CHAR0, D7
move.b D7, $2(A4)

lea $P2_CUR_INPUT, A0
;; if they chose an original team, we will
;; figure it out and store which team it was
jsr $2SET_ORIGINAL_TEAM_ID

cmpi.b #$18, $P2_CHOSEN_CHAR0
bne player2Done
;; they chose Rugal, make sure their team is Rugal too
move.b #8, $108431

bra player2Done

player2IsCpu:
;; saved into P2_CHOSEN_CHARX, move it to where the game expects it
move.b $P2_CHOSEN_CHAR2, (A4)
move.b $P2_CHOSEN_CHAR1, $1(A4)
move.b $P2_CHOSEN_CHAR0, $2(A4)

;; store the team id to enable continuing
move.b $108431, $1087e0


player2Done: 



done:
jsr $2CLEAR_FOCUSED_NAMES_FROM_FIX_ROUTINE

movem.l $MOVEM_STORAGE, A4
rts


;;;;; SUBROUTINES

;; restoreLogo
;; returns the logo sprite's height back to 16
;; so it shows up on order select
restoreLogo:
move.w #$8200 + 129, $3c0000
move.w #$f810, $3c0002
rts