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
btst #0, $PLAY_MODE
beq loadPlayer2Char3
move.b $P1_CHOSEN_CHAR2, D0
bra doneLoadChar3
loadPlayer2Char3:
move.b $P2_CHOSEN_CHAR0, D0
doneLoadChar3:
lea $CUTSCENE2_STRING, A0
bsr writeName ; write the name of the character
move.w #$000d, (A0)+ ; NL (writeName does not write the NL)

;; and now take Takuma's dialog and load it in
lea $6734c, A1
bsr writeDialog
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE2_STRING, A0 ; rewind back to the correct address
movem.l $MOVEM_STORAGE, D0/D1/A1
rts

replaceRobertDialog:
;; since Robert was char2 in the original team, we'll
;; use char2 of the custom team too
;; TODO: support p2
clr.w D0
btst #0, $PLAY_MODE
beq loadPlayer2Char2
move.b $P1_CHOSEN_CHAR1, D0
bra doneLoadChar2
loadPlayer2Char2:
move.b $P2_CHOSEN_CHAR1, D0
doneLoadChar2:
lea $CUTSCENE2_STRING, A0
bsr writeName ; write the name of the character
move.w #$000d, (A0)+ ; NL (writeName does not write the NL)

;; and now take Robert's dialog and load it in
lea $675c2, A1
bsr writeDialog
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE2_STRING, A0 ; rewind back to the correct address
movem.l $MOVEM_STORAGE, D0/D1/A1
rts

replaceRyoDialog:
;; since Ryo was char1 in the original team, we'll
;; use char1 of the custom team too
;; TODO: support p2
clr.w D0
btst #0, $PLAY_MODE
beq loadPlayer2Char1
move.b $P1_CHOSEN_CHAR0, D0
bra doneLoadChar1
loadPlayer2Char1:
move.b $P2_CHOSEN_CHAR2, D0
doneLoadChar1:
lea $CUTSCENE2_STRING, A0
bsr writeName ; write the name of the character
move.w #$000d, (A0)+ ; NL (writeName does not write the NL)

;; and now take Ryo's dialog and load it in
lea $67718, A1
bsr writeDialog
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE2_STRING, A0 ; rewind back to the correct address
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


;;; SUBROUTINES

;; writeName
;; writes the name for the given char id to the given location
;; does not write the new line character
;; 
;; parameters
;; D0.w: char ID
;; A0: where to write the string
writeName:
lea $2CHARID_TO_NAME_STRING_ENES, A1
add.w D0, D0 ; double for offsetting
add.w D0, D0 ; quadruple for offsetting
movea.l (A1, D0.w), A1 ; offset into the table based on character id

writeName_copyChar:
move.w (A1)+, D0      ; load one crom character
cmpi.w #$d, D0        ; is this the new line char?
beq writeName_done    ; it is, we have written the entire name
move.w D0, (A0)+      ; it is not the new line, so copy the char over
bra writeName_copyChar; and keep going

writeName_done:
rts


;; writeDialog
;; writes the dialog at the given address into the given address
;; stops when it hits the end dialog word ($ffff), but does not write it
;;
;; parameters
;; A0: where to write the string
;; A1: where to write from
;; uses
;; D0
writeDialog:
move.w (A1)+, D0        ; load one crom character
cmpi.w #$ffff, D0       ; is this the end of dialog char?
beq writeDialog_done    ; it is, we have written the entire dialog
move.w D0, (A0)+        ; it is not the end of dialog, so copy the char over
bra writeDialog         ; and keep going

writeDialog_done:
rts