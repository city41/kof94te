move.b #0, $IN_CHAR_SELECT_FLAG

move.b $P1_CHOSEN_CHAR0, D7
move.b D7, $108235

move.b $P1_CHOSEN_CHAR1, D7
move.b D7, $108236

move.b $P1_CHOSEN_CHAR2, D7
move.b D7, $108237

rts