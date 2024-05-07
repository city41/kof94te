;;; this routine is called with A6 set to a base address with the following data
;;; [w:fix layer location][l: string pointer][b:show or clear]
;;; string needs to be null terminated
;;; the show or clear byte should be 1 to show, and 0 to clear

move.w (A6), D7    ; load string's fix layer write location into d7
movea.l $2(A6), A5 ; get this string's start address in ROM
move.b $6(A6), D6  ; get the show/clear flag

move.w #32, $3c0004 ; set vrammod so that when writing to fix we write horizontally
move.w D7, $3c0000 ; set this string's fix layer write location

setAChar:
clr.w D7 ; get d7 ready to hold the tile index, which is bigger than a byte
move.b (A5)+, D7 ; grab a byte of the string into d7
beq stringDone ; hit the null byte? then we are done

cmpi.b #0, D6 ; is the flag zero? that means erase the string
beq useEmptyTile
bra setTile
useEmptyTile:
move.w #$f20, D7
setTile:

move.w D7, $3c0002 ; load the tile into the fix layer
bra setAChar ; circle back up and do it again for the next letter
stringDone:
subi.w #1, D6 ; decrement the counter
move.w D6, $6(A6) ; stick the counter back in memory

exit:
rts