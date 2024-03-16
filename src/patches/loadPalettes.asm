; loads the palettes for new char select into palette ram,
; starting at palette 192, to match what is in sromCromPreEmit.ts

move.l #$400000, D1
addi.w #192, D1 ; start at palette 192
; multiply by 32 to get to the starting palette index
; 32 because these are words but its in the 68k memory space,
; which is byte addressed
lsl.w #5, D1    
movea.l d1, A0 ;
lea $2PALETTES, A1 ; load the palette pointer
move.w (A1)+, D2   ; number of palettes;
subi.w #1, D2      ; sub one as dbra hinges on -1

;;; move an entire palette into palette ram
loadPalette:
move.w (A1)+, (A0)+ ; color 0
move.w (A1)+, (A0)+ ; color 1
move.w (A1)+, (A0)+ ; color 2
move.w (A1)+, (A0)+ ; color 3
move.w (A1)+, (A0)+ ; color 4
move.w (A1)+, (A0)+ ; color 5
move.w (A1)+, (A0)+ ; color 6
move.w (A1)+, (A0)+ ; color 7
move.w (A1)+, (A0)+ ; color 8
move.w (A1)+, (A0)+ ; color 9
move.w (A1)+, (A0)+ ; color 10
move.w (A1)+, (A0)+ ; color 11
move.w (A1)+, (A0)+ ; color 12
move.w (A1)+, (A0)+ ; color 13
move.w (A1)+, (A0)+ ; color 14
move.w (A1)+, (A0)+ ; color 15
dbra D2, loadPalette

rts
