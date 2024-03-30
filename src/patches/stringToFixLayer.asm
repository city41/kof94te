;;; this routine is called with A6 set to a base address with the following data
;;; [w:fix layer location][l: string pointer][w:countdown]
;;; string needs to be null terminated

move.w (A6), D7    ; load string's fix layer write location into d7
movea.l $2(A6), A5 ; get this string's start address in ROM
move.w $6(A6), D6  ; get the countdown value

cmpi.w #0, D6 ; is the countdown at zero? then nothing to do
beq exit

move.w #32, $3c0004 ; set vrammod so that when writing to fix we write horizontally
move.w D7, $3c0000 ; set this string's fix layer write location

setAChar:
clr.w D7 ; get d7 ready to hold the tile index, which is bigger than a byte
move.b (A5)+, D7 ; grab a byte of the string into d7
beq stringDone ; hit the null byte? then we are done

cmpi.w #1, D6 ; is the counter at 1? that means erase the string, at zero we won't come in here at all
beq useEmptyTile
; addi.w #$300, D7 ; jump forward in S1 rom to start of font plus character offset
; ori.w #$2000, D7 ; apply the palett
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