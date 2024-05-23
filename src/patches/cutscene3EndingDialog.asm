; cutscene3EndingDialog
; the game will call this looking to load a pointer to the next
; dialog run.
;
; A0: the pointer to the start of the dialog data pointer list, depending on
; which language the game is running in
; 54226 = Japanese
; 54306 = English
; 543e6 = Spanish
; 
;
; D0: a word offset into the dialog data  pointers
;
; normally the game indexes into the pointer list to get a pointer to the start
; of the dialog it wants to display
; add.w D0, D0
; add.w D0, D0
; movea.l (A0, D0.w), A0
;
; this routine is confusing because
; Rugal's first line "IMPOSSIBLE HOW COULD I LOSE..." is common to all teams and
; only in the ROM once. For english this is when A0=54306 and D0=0, the pointer
; it resolves to is 55956. D0=0 for all languages in this case
;
; The game sets itself to one of the ending teams: USA (3), England (7), Mexico (6) or Japan (2),
; this way that team's ending cinema can play. But then this routine will use Brazil's dialog for cutscene3,
; and brand new dialog for the endings.


movem.l D0/D1/A1, $MOVEM_STORAGE

; first, did the player choose an original 8 team?
; if so, make sure that is the team id that is set then bail
; let the original cutscenes run

btst #0, $PLAY_MODE
beq checkOriginal8Player2
cmpi.b #$ff, $P1_ORIGINAL_TEAM_ID
beq notAnOriginalTeam
move.b $P1_ORIGINAL_TEAM_ID, $108231
bra doVanilla

checkOriginal8Player2:
cmpi.b #$ff, $P2_ORIGINAL_TEAM_ID
beq notAnOriginalTeam
move.b $P2_ORIGINAL_TEAM_ID, $108431
bra doVanilla

notAnOriginalTeam:

;; cutscene3: first line
cmpi.b #$28, D0 ; USA
beq doFirstLine
cmpi.b #$62, D0 ; England
beq doFirstLine
cmpi.b #$52, D0 ; Mexico
beq doFirstLine
cmpi.b #$1a, D0 ; Japan
beq doFirstLine

;; cutscene3: second line
cmpi.b #$2A, D0 ; USA
beq doSecondLine
cmpi.b #$64, D0 ; England
beq doSecondLine
cmpi.b #$54, D0 ; Mexico
beq doSecondLine
cmpi.b #$1c, D0 ; Japan
beq doSecondLine

;; cutscene3: third line
cmpi.b #$2c, D0 ; USA
beq doThirdLine
cmpi.b #$66, D0 ; England
beq doThirdLine
cmpi.b #$56, D0 ; Mexico
beq doThirdLine
cmpi.b #$1e, D0 ; Japan
beq doThirdLine

;; cutscene3: fourth line
cmpi.b #$2e, D0 ; USA
beq doFourthLine
cmpi.b #$68, D0 ; England
beq doFourthLine
cmpi.b #$58, D0 ; Mexico
beq doFourthLine
cmpi.b #$20, D0 ; Japan
beq doFourthLine

;; ending: fifth line
cmpi.b #$30, D0 ; USA
beq doUSAFifthLine
cmpi.b #$6a, D0 ; England
beq doEnglandFifthLine
cmpi.b #$5a, D0 ; Mexico
beq doMexicoFifthLine
cmpi.b #$22, D0 ; Japan
beq doJapanFifthLine

;; ending: sixth line
cmpi.b #$32, D0 ; USA
beq doUSASixthLine
cmpi.b #$6c, D0 ; England
beq doEnglandSixthLine
cmpi.b #$5c, D0 ; Mexico
beq doMexicoSixthLine
cmpi.b #$24, D0 ; Japan
beq doJapanSixthLine

;; ending: seventh line
cmpi.b #$34, D0 ; USA
beq doUSASeventhLine
cmpi.b #$6e, D0 ; England
beq doEnglandSeventhLine
cmpi.b #$5e, D0 ; Mexico
beq doMexicoSeventhLine
cmpi.b #$26, D0 ; Japan
beq doJapanSeventhLine

;; ending: eigth line
;; only Mexico has four lines in the ending
cmpi.b #$60, D0 ; Mexico
beq doMexicoEighthLine

;; if we got here, it's not a line we need to make dynamic
;; that should just be Rugal's first line
;; or if this is an original 8 team

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
lea $57c5c, A1
bra loadFirstLineDialog

loadFirstLineJapanese:
lea $5450e, A1
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
lea $57c98, A0 
bra done

loadSecondLineJapanese:
lea $5453e, A0
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
lea $57cf0, A0
bra done

loadThirdLineJapanese:
lea $5459c, A0
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
lea $57d46, A1 
bra loadFourthLineDialog

loadFourthLineJapanese:
lea $545d4, A1
bra loadFourthLineDialog

loadFourthLineDialog:
jsr $2WRITE_DIALOG_ROUTINE
move.w #$ffff, (A0)+ ; end of dialog char

lea $CUTSCENE23_STRING, A0 ; rewind back to the correct address
bra done


doUSAFifthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadUSAFifthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadUSAFifthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadUSAFifthLineSpanish
bra loadUSAFifthLineJapanese

loadUSAFifthLineEnglish:
lea $2USA_ENDING_PART1_EN, A0
bra done

loadUSAFifthLineSpanish:
lea $2USA_ENDING_PART1_ES, A0
bra done

loadUSAFifthLineJapanese:
lea $2USA_ENDING_PART1_EN, A0 ; TODO, English is a placeholder
bra done

doEnglandFifthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadEnglandFifthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadEnglandFifthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadEnglandFifthLineSpanish
bra loadEnglandFifthLineJapanese

loadEnglandFifthLineEnglish:
lea $2ENG_ENDING_PART1_EN, A0
bra done

loadEnglandFifthLineSpanish:
lea $2ENG_ENDING_PART1_ES, A0
bra done

loadEnglandFifthLineJapanese:
lea $2ENG_ENDING_PART1_JA, A0
bra done

doMexicoFifthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadMexicoFifthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadMexicoFifthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadMexicoFifthLineSpanish
bra loadMexicoFifthLineJapanese

loadMexicoFifthLineEnglish:
lea $2MEX_ENDING_PART1_EN, A0
bra done

loadMexicoFifthLineSpanish:
lea $2MEX_ENDING_PART1_ES, A0
bra done

loadMexicoFifthLineJapanese:
lea $2MEX_ENDING_PART1_EN, A0 ; TODO, English is a placeholder
bra done

doJapanFifthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadJapanFifthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadJapanFifthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadJapanFifthLineSpanish
bra loadJapanFifthLineJapanese

loadJapanFifthLineEnglish:
lea $2JPN_ENDING_PART1_EN, A0
bra done

loadJapanFifthLineSpanish:
lea $2JPN_ENDING_PART1_ES, A0
bra done

loadJapanFifthLineJapanese:
lea $2JPN_ENDING_PART1_EN, A0 ; TODO, English is a placeholder
bra done

doUSASixthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadUSASixthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadUSASixthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadUSASixthLineSpanish
bra loadUSASixthLineJapanese

loadUSASixthLineEnglish:
lea $2USA_ENDING_PART2_EN, A0
bra done

loadUSASixthLineSpanish:
lea $2USA_ENDING_PART2_ES, A0
bra done

loadUSASixthLineJapanese:
lea $2USA_ENDING_PART2_EN, A0 ; TODO, English is a placeholder
bra done

doEnglandSixthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadEnglandSixthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadEnglandSixthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadEnglandSixthLineSpanish
bra loadEnglandSixthLineJapanese

loadEnglandSixthLineEnglish:
lea $2ENG_ENDING_PART2_EN, A0
bra done

loadEnglandSixthLineSpanish:
lea $2ENG_ENDING_PART2_ES, A0
bra done

loadEnglandSixthLineJapanese:
lea $2ENG_ENDING_PART2_EN, A0 ; TODO, English is a placeholder
bra done

doMexicoSixthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadMexicoSixthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadMexicoSixthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadMexicoSixthLineSpanish
bra loadMexicoSixthLineJapanese

loadMexicoSixthLineEnglish:
lea $2MEX_ENDING_PART2_EN, A0
bra done

loadMexicoSixthLineSpanish:
lea $2MEX_ENDING_PART2_ES, A0
bra done

loadMexicoSixthLineJapanese:
lea $2MEX_ENDING_PART2_EN, A0 ; TODO, English is a placeholder
bra done

doJapanSixthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadJapanSixthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadJapanSixthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadJapanSixthLineSpanish
bra loadJapanSixthLineJapanese

loadJapanSixthLineEnglish:
lea $2JPN_ENDING_PART2_EN, A0
bra done

loadJapanSixthLineSpanish:
lea $2JPN_ENDING_PART2_ES, A0
bra done

loadJapanSixthLineJapanese:
lea $2JPN_ENDING_PART2_EN, A0 ; TODO, English is a placeholder
bra done

doUSASeventhLine:
cmpi.b #1, $LANGUAGE_ID
beq loadUSASeventhLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadUSASeventhLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadUSASeventhLineSpanish
bra loadUSASeventhLineJapanese

loadUSASeventhLineEnglish:
lea $2USA_ENDING_PART3_EN, A0
bra done

loadUSASeventhLineSpanish:
lea $2USA_ENDING_PART3_ES, A0
bra done

loadUSASeventhLineJapanese:
lea $2USA_ENDING_PART3_EN, A0 ; TODO, English is a placeholder
bra done

doEnglandSeventhLine:
cmpi.b #1, $LANGUAGE_ID
beq loadEnglandSeventhLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadEnglandSeventhLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadEnglandSeventhLineSpanish
bra loadEnglandSeventhLineJapanese

loadEnglandSeventhLineEnglish:
lea $2ENG_ENDING_PART3_EN, A0
bra done

loadEnglandSeventhLineSpanish:
lea $2ENG_ENDING_PART3_ES, A0
bra done

loadEnglandSeventhLineJapanese:
lea $2ENG_ENDING_PART3_EN, A0 ; TODO, English is a placeholder
bra done

doMexicoSeventhLine:
cmpi.b #1, $LANGUAGE_ID
beq loadMexicoSeventhLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadMexicoSeventhLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadMexicoSeventhLineSpanish
bra loadMexicoSeventhLineJapanese

loadMexicoSeventhLineEnglish:
lea $2MEX_ENDING_PART3_EN, A0
bra done

loadMexicoSeventhLineSpanish:
lea $2MEX_ENDING_PART3_ES, A0
bra done

loadMexicoSeventhLineJapanese:
lea $2MEX_ENDING_PART3_EN, A0 ; TODO, English is a placeholder
bra done

doJapanSeventhLine:
cmpi.b #1, $LANGUAGE_ID
beq loadJapanSeventhLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadJapanSeventhLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadJapanSeventhLineSpanish
bra loadJapanSeventhLineJapanese

loadJapanSeventhLineEnglish:
lea $2JPN_ENDING_PART3_EN, A0
bra done

loadJapanSeventhLineSpanish:
lea $2JPN_ENDING_PART3_ES, A0
bra done

loadJapanSeventhLineJapanese:
lea $2JPN_ENDING_PART3_EN, A0 ; TODO, English is a placeholder
bra done

doMexicoEighthLine:
cmpi.b #1, $LANGUAGE_ID
beq loadMexicoEigthLineEnglish
cmpi.b #2, $LANGUAGE_ID
beq loadMexicoEigthLineEnglish
cmpi.b #3, $LANGUAGE_ID
beq loadMexicoEigthLineSpanish
bra loadMexicoEigthLineJapanese

loadMexicoEigthLineEnglish:
lea $2MEX_ENDING_PART4_EN, A0
bra done

loadMexicoEigthLineSpanish:
lea $2MEX_ENDING_PART4_ES, A0
bra done

loadMexicoEigthLineJapanese:
lea $2MEX_ENDING_PART4_EN, A0 ; TODO, English is a placeholder

done:
movem.l $MOVEM_STORAGE, D0/D1/A1
rts