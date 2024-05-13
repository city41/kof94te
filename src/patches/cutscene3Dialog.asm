; cutscene3Dialog
; the game will call this looking to load a pointer to the next
; dialog run.
;
; A0: the pointer to the start of the dialog data, depending on
; which language the game is running in
; 54306 = English
;
; D0: a word offset into the dialog data 

movem.l D0/D1/A1, $MOVEM_STORAGE

;; check for first line
cmpi.b #$28, D0 ; USA
beq doFirstLine
cmpi.b #$62, D0 ; England
beq doFirstLine
cmpi.b #$52, D0 ; Mexico
beq doFirstLine
cmpi.b #$1a, D0 ; Japan
beq doFirstLine

;; second line
cmpi.b #$2A, D0 ; USA
beq doSecondLine
cmpi.b #$64, D0 ; England
beq doSecondLine
cmpi.b #$54, D0 ; Mexico
beq doSecondLine
cmpi.b #$1c, D0 ; Japan
beq doSecondLine

;; third line
cmpi.b #$2c, D0 ; USA
beq doThirdLine
cmpi.b #$66, D0 ; England
beq doThirdLine
cmpi.b #$56, D0 ; Mexico
beq doThirdLine
cmpi.b #$1e, D0 ; Japan
beq doThirdLine

;; fourth line
cmpi.b #$2e, D0 ; USA
beq doFourthLine
cmpi.b #68, D0 ; England
beq doFourthLine
cmpi.b #$58, D0 ; Mexico
beq doFourthLine
cmpi.b #$20, D0 ; Japan
beq doFourthLine

;; if we got here, it's not a line we need to make dynamic
;; it's either Rugal's first line or lines from the ending

doVanilla:
add.w D0, D0
movea.l (A0,D0.w), A0
bra done

doFirstLine:
;; team member line
clr.w D0
btst #0, $PLAY_MODE ; is player 1 playing?
beq loadPlayer2Char1; no? go do player 2
move.b $P1_CHOSEN_CHAR0, D0 ; load p1 char id
bra doneLoadChar1
loadPlayer2Char1:
move.b $P2_CHOSEN_CHAR2, D0 ; load p2 char id
doneLoadChar1:
lea $CUTSCENE23_STRING, A0
jsr $2WRITE_NAME_ROUTINE ; write the name of the character
move.w #$000d, (A0)+ ; NL (writeName does not write the NL)

;; and now take the first line's dialog and load it in
cmpi.b #1, $LANGUAGE_ID
beq loadFirstLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadFirstLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadFirstLineSpanish
bra loadFirstLineJapanese

loadFirstLineEnglish:
lea $559da, A1
bra loadFirstLineDialog

loadFirstLineSpanish:
lea $559da, A1 ; TODO, English is a placeholder
bra loadFirstLineDialog

loadFirstLineJapanese:
lea $559da, A1 ; TODO, English is a placeholder
bra loadFirstLineDialog

loadFirstLineDialog:
jsr $2WRITE_DIALOG_ROUTINE
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE23_STRING, A0 ; rewind back to the correct address
bra done



doSecondLine:
;; Rugal line
cmpi.b #1, $LANGUAGE_ID
beq loadSecondLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadSecondLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadSecondLineSpanish
bra loadSecondLineJapanese

loadSecondLineEnglish:
lea $55a2e, A0
bra done

loadSecondLineSpanish:
lea $55a2e, A0 ; TODO, English is a placeholder
bra done

loadSecondLineJapanese:
lea $55a2e, A0 ; TODO, English is a placeholder
bra done




doThirdLine:
;; Rugal line
cmpi.b #1, $LANGUAGE_ID
beq loadThirdLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadThirdLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadThirdLineSpanish
bra loadThirdLineJapanese

loadThirdLineEnglish:
lea $55a9a, A0
bra done

loadThirdLineSpanish:
lea $55a9a, A0 ; TODO, English is a placeholder
bra done

loadThirdLineJapanese:
lea $55a9a, A0 ; TODO, English is a placeholder
bra done



doFourthLine:
;; team member line
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

;; and now take the first line's dialog and load it in
cmpi.b #1, $LANGUAGE_ID
beq loadFourthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadFourthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadFourthLineSpanish
bra loadFourthLineJapanese

loadFourthLineEnglish:
lea $55b34, A1
bra loadFourthLineDialog

loadFourthLineSpanish:
lea $55b34, A1 ; TODO, English is a placeholder
bra loadFourthLineDialog

loadFourthLineJapanese:
lea $55b34, A1 ; TODO, English is a placeholder
bra loadFourthLineDialog

loadFourthLineDialog:
jsr $2WRITE_DIALOG_ROUTINE
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE23_STRING, A0 ; rewind back to the correct address

done:
movem.l $MOVEM_STORAGE, D0/D1/A1
rts