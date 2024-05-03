movem.l A5/D6, $MOVEM_STORAGE

addi.b #1, $CHAR_SELECT_COUNTER
cmpi.b #100, $CHAR_SELECT_COUNTER

ble skipReloadCounter

move.b #0, $CHAR_SELECT_COUNTER
move.w #91, $THANK_YOU_PRESS_A_COUNT

skipReloadCounter:
movea.l #$2PRESS_A_TO_CONTINUE, A5
bsr stringToFixLayer

movem.l $MOVEM_STORAGE, A5/D6
rts


stringToFixLayer:
cmpi.w #0, $THANK_YOU_PRESS_A_COUNT ; is the countdown at zero? then nothing to do
beq done

move.w #32, $3c0004 ; set vrammod so that when writing to fix we write horizontally
move.w #$7156, $3c0000 ; set this string's fix layer write location

setAChar:
clr.w D6 ; get D6 ready to hold the tile index, which is bigger than a byte
move.b (A5)+, D6 ; grab a byte of the string into D6
beq stringDone ; hit the null byte? then we are done

cmpi.w #1, $THANK_YOU_PRESS_A_COUNT ; is the counter at 1? that means erase the string, at zero we won't come in here at all
beq useEmptyTile

;; not using the empty tile
move.w D6, $3c0002 ; load the tile into the fix layer
bra doneSetTile

useEmptyTile:
move.w #$20, $3c0002 ; load the tile into the fix layer

doneSetTile:
bra setAChar ; circle back up and do it again for the next letter

stringDone:
subi.w #1, $THANK_YOU_PRESS_A_COUNT ; decrement the counter

done:
rts