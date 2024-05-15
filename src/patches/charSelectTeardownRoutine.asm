movem.l A4, $MOVEM_STORAGE
move.b #0, $IN_CHAR_SELECT_FLAG

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

bra player1Done

player1IsCpu:
;; we still want to get the character ids into P1_CHOSEN_CHARX, as it
;; makes setupCharacterColors much easier
move.b (A4), $P1_CHOSEN_CHAR0
move.b $1(A4), $P1_CHOSEN_CHAR1
move.b $2(A4), $P1_CHOSEN_CHAR2
;; store the team id to enable continuing
move.b $108231, $1087e0


player1Done:

;; move player 2's choices where the game expects them
lea $P2_CHOSEN_CHARS_IN_ORDER_OF_CHOOSING, A4

btst #1, $PLAY_MODE ; is p2 playing?
beq player2IsCpu ; oh p2 is cpu, jump ahed

; they are playing, move their choses where the game expects them 
move.b $P2_CHOSEN_CHAR0, D7
move.b D7, (A4)

move.b $P2_CHOSEN_CHAR1, D7
move.b D7, $1(A4)

move.b $P2_CHOSEN_CHAR2, D7
move.b D7, $2(A4)

lea $P2_CUR_INPUT, A0
;; if they chose an original team, we will
;; figure it out and store which team it was
jsr $2SET_ORIGINAL_TEAM_ID

bra player2Done

player2IsCpu:
;; we still want to get the character ids into P2_CHOSEN_CHARX, as it
;; makes setupCharacterColors much easier
move.b (A4), $P2_CHOSEN_CHAR2
move.b $1(A4), $P2_CHOSEN_CHAR1
move.b $2(A4), $P2_CHOSEN_CHAR0
;; store the team id to enable continuing
move.b $108431, $1087e0


player2Done: 



done:
jsr $2CLEAR_FOCUSED_NAMES_FROM_FIX_ROUTINE

;; clear out the version string in case the user had start held down when teardown triggered
move.b #0, $VSTRING_DATA + 6
lea $VSTRING_DATA, A6
movem.l A5, $MOVEM_STORAGE
jsr $2STRING_TO_FIX_LAYER_ROUTINE
movem.l $MOVEM_STORAGE, A5

;; and clear out the qr code, just in case
move.w #$QR_SI, D6
move.w #2, D7
jsr $2TRUNCATE_SPRITES_ROUTINE

movem.l $MOVEM_STORAGE, A4
rts