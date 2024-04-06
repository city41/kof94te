move.b #0, $IN_CHAR_SELECT_FLAG

;; move player 1's choices where the game expects them
btst #0, $NUM_PLAYER_MODE ; is p1 playing?
beq skipPlayer1

move.b $P1_CHOSEN_CHAR0, D7
move.b D7, $108235

move.b $P1_CHOSEN_CHAR1, D7
move.b D7, $108236

move.b $P1_CHOSEN_CHAR2, D7
move.b D7, $108237


skipPlayer1:

;; move player 2's choices where the game expects them
btst #1, $NUM_PLAYER_MODE ; is p2 playing?
beq skipPlayer2

move.b $P2_CHOSEN_CHAR0, D7
move.b D7, $108435

move.b $P2_CHOSEN_CHAR1, D7
move.b D7, $108436

move.b $P2_CHOSEN_CHAR2, D7
move.b D7, $108437

skipPlayer2: 


jsr $2CLEAR_FOCUSED_NAMES_FROM_FIX_ROUTINE
;; and the last two sprites the game leaves, so need to truncate them
move.w #$P2C1_SI + 4, D6
move.w #2, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

rts