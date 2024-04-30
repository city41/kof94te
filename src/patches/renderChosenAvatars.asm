; renderChosenAvatars
; renders the chosen avatars for the player in A0
; handles rugal and clearing avatars as needed
renderChosenAvatars:
cmpi.b #$18, $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0) ; did they choose rugal?
bne renderChosenAvatars_skipRugal

;; this is rugal, a special case
;; now render him as the first chosen char
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6
move.w #$18, D7
move.b #0, D4 ; palette flag, this is correct as Rugal doesn't have an alternate avatar
jsr $2RENDER_CHOSEN_AVATAR
;; now clear out the second chosen char
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6
addi.w #2, D6
jsr $2CLEAR_CHOSEN_AVATAR
;; now clear out the third chosen char
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6
addi.w #4, D6
jsr $2CLEAR_CHOSEN_AVATAR
;; and done, Rugal is all set
bra renderChosenAvatars_done

renderChosenAvatars_skipRugal:
;; ok need to render up to 3 avatars, but also clear out
;; any avatars for non chosen characters
cmpi.b #$RANDOM_SELECT_TYPE_CHAR, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
beq renderChosenAvatars_charRandomSelect
cmpi.b #$RANDOM_SELECT_TYPE_TEAM, $PX_RANDOM_SELECT_TYPE_OFFSET(A0)
beq renderChosenAvatars_teamRandomSelect
bra renderChosenAvatars_noRandomSelect

renderChosenAvatars_charRandomSelect:
move.b #3, D3 ; this is random, so always render 3 avatars
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2 ; draw from real chosen chars
bra renderChosenAvatars_renderAvatars

renderChosenAvatars_teamRandomSelect:
move.b #3, D3 ; this is random, so always render 3 avatars
lea $PX_TEAM_RANDOM_TEMP_CHOSEN_CHARS_OFFSET(A0), A2 ; draw from the temp chosen chars
bra renderChosenAvatars_renderAvatars

renderChosenAvatars_noRandomSelect:
move.b $PX_NUM_CHOSEN_CHARS_OFFSET(A0), D3 ; this is not random, render the actual number chosen
movea.l $PX_STARTING_CHOSE_CHAR_ADDRESS_OFFSET(A0), A2 ; draw from real chosen chars
bra renderChosenAvatars_renderAvatars

renderChosenAvatars_renderAvatars:
clr.b D5 ; loop counter
move.w $PX_CHOSEN_TEAM_SPRITEINDEX_OFFSET(A0), D6

renderChosenAvatars_renderOneAvatar:
cmp.b D3, D5 ; see if we need to render or clear based on how many avatars to render
bge renderChosenAvatar_clearOneAvatar

clr.w D7
move.b (A2), D7 ; load the char id
move.b $1(A2), D4 ; palette flag
jsr $2RENDER_CHOSEN_AVATAR
bra renderChosenAvatar_doneRenderingOneAvatar

renderChosenAvatar_clearOneAvatar:
movem.w D6, $MOVEM_STORAGE
jsr $2CLEAR_CHOSEN_AVATAR
movem.w $MOVEM_STORAGE, D6

renderChosenAvatar_doneRenderingOneAvatar:

adda.w #2, A2 ; move to next character
addi.w #2, D6 ; move to next sprite index
addi.b #1, D5 ; increment the counter
cmpi.b #3, D5 ; and loop if we've done less than 3 characters
bne renderChosenAvatars_renderOneAvatar

renderChosenAvatars_done:
rts