;; writeName
;; writes the name for the given char id to the given location
;; does not write the new line character
;; 
;; parameters
;; D0.w: char ID
;; A0: where to write the string
cmpi.b #1, $LANGUAGE_ID
beq loadEnglishNames
cmpi.b #2, $LANGUAGE_ID
beq loadEnglishNames
cmpi.b #3, $LANGUAGE_ID
beq loadSpanishNames
bra loadJapaneseNames

loadEnglishNames:
loadSpanishNames:
lea $2CHARID_TO_NAME_STRING_ENES, A1
bra loadNamesDone

loadJapaneseNames:
lea $2CHARID_TO_NAME_STRING_JA, A1

loadNamesDone:
add.w D0, D0 ; double for offsetting
add.w D0, D0 ; quadruple for offsetting
movea.l (A1, D0.w), A1 ; offset into the table based on character id

copyChar:
move.w (A1)+, D0      ; load one crom character
cmpi.w #$d, D0        ; is this the new line char?
beq done    ; it is, we have written the entire name
move.w D0, (A0)+      ; it is not the new line, so copy the char over
bra copyChar; and keep going

done:
rts