;; guardPalettes
;; while in character select, makes sure the game doesn't clobber our palettes

;; we only need to guard the palettes in two situations
;; - the end of char select, where we have handed control back to the game briefly
;; - a HERE COMES CHALLENGER happens during character select.

cmpi.b #$MAIN_PHASE_DONE, $MAIN_HACK_PHASE
beq guard
cmpi.b #1, $IN_HERE_COMES_CHALLENGER
beq guard
bra skip

guard:
move.w #94, D0  ; have it write into a palette that isn't ours

skip:
lea $400000, A1

done:
rts