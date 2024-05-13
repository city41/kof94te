; first, are we in cutscene2?
movem.l D0/D1/A1, $MOVEM_STORAGE
jsr $350f8 ; the built in "count defeated teams" subroutine

cmpi.w #8, D0 ; 8 defeated teams?
bne doVanilla ; no? must be first cutscene then
movem.l $MOVEM_STORAGE, D0/D1/A1 ; we need the original D0 back to see what dialog this is
cmpi.w #$3a, D0 ; is this Takuma's dialog?
beq replaceTakumaDialog
cmpi.w #$3c, D0 ; is this Robert's dialog?
beq replaceRobertDialog
cmpi.w #$3e, D0 ; is this Ryo's dialog?
beq replaceRyoDialog
bra doVanilla ; no? just do the regular routine then


replaceTakumaDialog:
;; since Takuma was char3 in the original team, we'll
;; use char3 of the custom team too
clr.w D0
btst #0, $PLAY_MODE ; is player 1 playing?
beq loadPlayer2Char3; no? go do player 2
move.b $P1_CHOSEN_CHAR2, D0 ; load p1 char id
bra doneLoadChar3
loadPlayer2Char3:
move.b $P2_CHOSEN_CHAR0, D0 ; load p2 char id
doneLoadChar3:
lea $CUTSCENE23_STRING, A0
jsr $2WRITE_NAME_ROUTINE ; write the name of the character
move.w #$000d, (A0)+ ; NL (writeName does not write the NL)

;; and now take Takuma's dialog and load it in
cmpi.b #1, $LANGUAGE_ID
beq loadTakumaEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadTakumaEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadTakumaSpanish
bra loadTakumaJapanese

loadTakumaEnglish:
lea $6734c, A1
bra loadTakumaDialog

loadTakumaSpanish:
lea $6aac8, A1
bra loadTakumaDialog

loadTakumaJapanese:
lea $64414, A1
bra loadTakumaDialog

loadTakumaDialog:
jsr $2WRITE_DIALOG_ROUTINE
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE23_STRING, A0 ; rewind back to the correct address
movem.l $MOVEM_STORAGE, D0/D1/A1
rts

replaceRobertDialog:
;; since Robert was char2 in the original team, we'll
;; use char2 of the custom team too
;; TODO: support p2
clr.w D0
btst #0, $PLAY_MODE ; is player 1 playing?
beq loadPlayer2Char2; no? go do player 2
move.b $P1_CHOSEN_CHAR1, D0
bra doneLoadChar2
loadPlayer2Char2:
move.b $P2_CHOSEN_CHAR1, D0
doneLoadChar2:
lea $CUTSCENE23_STRING, A0
jsr $2WRITE_NAME_ROUTINE ; write the name of the character
move.w #$000d, (A0)+ ; NL (writeName does not write the NL)

;; and now take Robert's dialog and load it in
cmpi.b #1, $LANGUAGE_ID
beq loadRobertEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadRobertEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadRobertSpanish
bra loadRobertJapanese

loadRobertEnglish:
lea $675c2, A1
bra loadRobertDialog

loadRobertSpanish:
lea $6acfe, A1
bra loadRobertDialog

loadRobertJapanese:
lea $6455c, A1
bra loadRobertDialog

loadRobertDialog:
jsr $2WRITE_DIALOG_ROUTINE
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE23_STRING, A0 ; rewind back to the correct address
movem.l $MOVEM_STORAGE, D0/D1/A1
rts

replaceRyoDialog:
;; since Ryo was char1 in the original team, we'll
;; use char1 of the custom team too
;; TODO: support p2
clr.w D0
btst #0, $PLAY_MODE ; is player 1 playing?
beq loadPlayer2Char1; no? go do player 2
move.b $P1_CHOSEN_CHAR0, D0
bra doneLoadChar1
loadPlayer2Char1:
move.b $P2_CHOSEN_CHAR2, D0
doneLoadChar1:
lea $CUTSCENE23_STRING, A0
jsr $2WRITE_NAME_ROUTINE ; write the name of the character
move.w #$000d, (A0)+ ; NL (writeName does not write the NL)

;; and now take Ryo's dialog and load it in
cmpi.b #1, $LANGUAGE_ID
beq loadRyoEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadRyoEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadRyoSpanish
bra loadRyoJapanese

loadRyoEnglish:
lea $67718, A1
bra loadRyoDialog

loadRyoSpanish:
lea $6ae0e, A1
bra loadRyoDialog

loadRyoJapanese:
lea $64606, A1
bra loadRyoDialog

loadRyoDialog:
jsr $2WRITE_DIALOG_ROUTINE
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE23_STRING, A0 ; rewind back to the correct address
movem.l $MOVEM_STORAGE, D0/D1/A1
rts

; just do what was originally happening in this routine
; for all other dialogs, such as rugal's
doVanilla:
movem.l $MOVEM_STORAGE, D0/D1/A1
add.w D0, D0
add.w D0, D0
movea.l (A0,D0.w), A0
rts

