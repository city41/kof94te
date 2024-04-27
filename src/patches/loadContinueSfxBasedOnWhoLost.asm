; loadContinueSfxBasedOnWhoLost
;
; In a single player game, when the player loses, then decides to continue,
; this routine has the game load the corect sound effect that corresponds
; to the character who lost the match

movem.l A0, $MOVEM_STORAGE
clr.w D0
lea $2CHARID_TO_CONTINUE_SFX_OFFSET_TABLE, A0

btst #0, $PLAY_MODE ; is p1 playing?
beq loadPlayer2
move.b $108171, D0 ; load the p1 character who lost
bra doneLoadingLosingCharId
loadPlayer2:
move.b $108371, D0 ; load the p2 character who lost

doneLoadingLosingCharId:
add.w D0, D0       ; double it, as the table is words
adda.w D0, A0      ; move the pointer forward in the table
move.w (A0), D0    ; D0 now contains the offset that is needed for this char's sfx

movem.l $MOVEM_STORAGE, A0
rts
