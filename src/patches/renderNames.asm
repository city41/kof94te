movem.l A0-A3/A6/D0-D7, $MOVEM_STORAGE

bsr renderBackdrop

lea $2CHARID_TO_NAME_STRING_JA, A0
lea $2CHARID_TO_NAME_STRING_ENES, A2

adda.w #52, A0
adda.w #52, A2

move.w #1, $VRAMMOD

move.w #0, D6 ; count how many names we have done

renderName:

movea.l (A0), A1 ; grab a name out of the Japanese list
movea.l (A2), A3 ; grab the corresponding name out of the English list

move.w #$NAMES_SI, D0 ; reset the si
move.w #0, D7   ; tile counter

renderChar:
;;; Japanese char
move.w D0, D1 ; move si into D1
lsl.w #6, D1  ; multiply by 64 to get the address
add.w D6, D1  ; go down to the current tile
add.w D6, D1  ; twice since scb1 is double words
move.w (A1), D3
cmpi.w #$d, D3 ; is this the new line char?
beq skipJapaneseChar
move.w D1, $VRAMADDR
move.w D3, $VRAMRW ; even word, tile LSB
move.w #$93, D1      ; load palette
lsl.w #8, D1         ; shift it into place
move.w D1, $VRAMRW   ; odd word, palette, etc

;; Japanese Y
move.w #$8200, D1 ; set base address for SCB3
add.w D0, D1      ; offset to our si
move.w D1, $VRAMADDR
move.w #488, D1   ; load Y
lsl.w #7, D1      ; shift it into place
ori.w #14, D1     ; set sprite size
cmpi.w #0, D7     ; is this the first character?
beq skipJapaneseSticky ; if it is, don't make it sticky
bset #6, D1 ; set the sticky bit
skipJapaneseSticky:
move.w D1, $VRAMRW

;; Japanese X
cmpi.w #0, D7     ; is this the first character?
bne skipJapaneseChar ; if it's not, no need to set X since it will be sticky
move.w #$8400, D1 ; set base address for SCB4
add.w D0, D1      ; offset to our si
move.w D1, $VRAMADDR
move.w #8, D1    ; load X
lsl.w #7, D1      ; shift it into place
move.w D1, $VRAMRW

skipJapaneseChar:

;; english char

move.w (A3), D3
cmpi.w #$d, D3 ; is this the new line char?
beq skipEnglishChar
move.w D0, D1 ; move si into D1
addi.w #8, D1 ; jump ahead 8 sprites to leave room for the rest of the Japanese chars
lsl.w #6, D1  ; multiply by 64 to get the address
add.w D6, D1  ; go down to the current tile
add.w D6, D1  ; twice since scb1 is double words
move.w D1, $VRAMADDR
move.w D3, $VRAMRW ; even word, tile LSB
move.w #$93, D1      ; load palette
lsl.w #8, D1         ; shift it into place
move.w D1, $VRAMRW   ; odd word, palette etc

;; English Y
move.w #$8200, D1 ; set base address for SCB3
add.w D0, D1      ; offset to our si
addi.w #8, D1      ; jump ahead 8 sprites to leave room for the rest of the Japanese chars
move.w D1, $VRAMADDR
move.w #488, D1   ; load Y
lsl.w #7, D1      ; shift it into place
ori.w #14, D1      ; set sprite size
cmpi.w #0, D7     ; is this the first character?
beq skipEnglishSticky ; if it is, don't make it sticky
bset #6, D1 ; set the sticky bit
skipEnglishSticky:
move.w D1, $VRAMRW

;; English X
cmpi.w #0, D7     ; is this the first character?
bne skipEnglishChar ; if it's not, no need to set X since it will be sticky
move.w #$8400, D1 ; set base address for SCB4
add.w D0, D1      ; offset to our si
addi.w #8, D1      ; jump ahead 8 sprites to leave room for the rest of the Japanese chars
move.w D1, $VRAMADDR
move.w #168, D1    ; load X
lsl.w #7, D1      ; shift it into place
move.w D1, $VRAMRW


skipEnglishChar:

;; at most we can render 8 tiles per character
cmpi.w #7, D7
beq doneWithName

;; now to loop back up
;; first if both names have hit the new line char, we are done
cmpi.w #$d, (A1)
bne moreToRender
cmpi.w #$d, (A3)
bne moreToRender
bra doneWithName

moreToRender:
;; move foward to the next sprite and tile
addi.w #1, D0 ; move forward one sprite
addi.w #1, D7 ; move forward one tile
cmpi.w #$d, (A1) ; if Japanese is done
beq skipJapaneseIncrement ; don't move it ahead
adda.w #2, A1 ; move to the next Japanese tile
skipJapaneseIncrement:
cmpi.w #$d, (A3) ; if English is done
beq skipEnglishIncrement ; don't move it ahead
adda.w #2, A3 ; move to the next English tile
skipEnglishIncrement:
bra renderChar

doneWithName:
addi.w #1, D6  ; increase our name counter
cmpi.w #11, D6
beq done ; we have rendered everyone
adda.w #4, A0 ; move Japanese to next name
adda.w #4, A2 ; move English to next name


bra renderName ; and do it again for the next character

done:
movem.l $MOVEM_STORAGE, A0-A3/A6/D0-D7
rts


;;;;; SUBROUTINES


renderBackdrop:

move.w #0, D5
move.w #$BLACK_BG_SI, D6
lea $2BLACK_BG_IMG, A6
jsr $2RENDER_STATIC_IMAGE
rts