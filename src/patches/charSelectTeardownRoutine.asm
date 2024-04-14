movem.l A4, $MOVEM_STORAGE
move.b #0, $IN_CHAR_SELECT_FLAG

;; move player 1's choices where the game expects them
lea $P1_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING, A4

btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq player1IsCpu ; oh p1 is cpu, jump ahead

; they are playing, move their choses where the game expects them 
move.b $P1_CHOSEN_CHAR0, D7
move.b D7, (A4)

move.b $P1_CHOSEN_CHAR1, D7
move.b D7, $1(A4)

move.b $P1_CHOSEN_CHAR2, D7
move.b D7, $2(A4)
bra player1Done

player1IsCpu:
;; we still want to get the character ids into P1_CHOSEN_CHARX, as it
;; makes setupCharacterColors much easier
move.b (A4), $P1_CHOSEN_CHAR0
move.b $1(A4), $P1_CHOSEN_CHAR1
move.b $2(A4), $P1_CHOSEN_CHAR2


player1Done:

;; move player 2's choices where the game expects them
lea $P2_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING, A4

btst #1, $NUM_PLAYER_MODE ; is p2 playing?
beq player2IsCpu ; oh p2 is cpu, jump ahed

; they are playing, move their choses where the game expects them 
move.b $P2_CHOSEN_CHAR0, D7
move.b D7, (A4)

move.b $P2_CHOSEN_CHAR1, D7
move.b D7, $1(A4)

move.b $P2_CHOSEN_CHAR2, D7
move.b D7, $2(A4)
bra player2Done

player2IsCpu:
;; we still want to get the character ids into P2_CHOSEN_CHARX, as it
;; makes setupCharacterColors much easier
move.b (A4), $P2_CHOSEN_CHAR2
move.b $1(A4), $P2_CHOSEN_CHAR1
move.b $2(A4), $P2_CHOSEN_CHAR0


player2Done: 



done:
jsr $2CLEAR_FOCUSED_NAMES_FROM_FIX_ROUTINE
;; and the last two sprites the game leaves, so need to truncate them
move.w #$P2_CURSOR_SI, D6
move.w #2, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

movem.l $MOVEM_STORAGE, A4
rts