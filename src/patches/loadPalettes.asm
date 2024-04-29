; loads the palettes for new char select into palette ram,

move.l #$400000, D1
addi.w #16, D1 ; the starting palette index which needs to match preemit
; multiply by 32 to get to the starting palette index
; 32 because these are words but its in the 68k memory space,
; which is byte addressed
lsl.w #5, D1    
movea.l d1, A0 ;
lea $2PALETTES, A1 ; load the palette pointer
move.w (A1)+, D2   ; number of palettes;
subi.w #1, D2      ; sub one as dbra hinges on -1

;;; move 1 entire palettes into palette ram
loadPalette:
; make all palettes pure red, for debugging
; move.l #$cf00cf00, (a0)+
; move.l #$cf00cf00, (a0)+
; move.l #$cf00cf00, (a0)+
; move.l #$cf00cf00, (a0)+
; move.l #$cf00cf00, (a0)+
; move.l #$cf00cf00, (a0)+
; move.l #$cf00cf00, (a0)+
; move.l #$cf00cf00, (a0)+
move.l (A1)+, (A0)+ ; color 0-1
move.l (A1)+, (A0)+ ; color 2-3
move.l (A1)+, (A0)+ ; color 4-5
move.l (A1)+, (A0)+ ; color 6-7
move.l (A1)+, (A0)+ ; color 8-9
move.l (A1)+, (A0)+ ; color 10-11
move.l (A1)+, (A0)+ ; color 12-13
move.l (A1)+, (A0)+ ; color 14-15
dbra D2, loadPalette

rts
