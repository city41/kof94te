;; guardPalettes
;; while in character select, makes sure the game doesn't clobber our palettes

;; we only need to guard the palettes in one situation
;; - a HERE COMES CHALLENGER happens during character select.
;;
;; caution: guarding the palettes when not needed almost always causes slowdown on the mister/real hardware

cmpi.b #1, $IN_HERE_COMES_CHALLENGER
beq guard
bra skip

guard:
move.w #94, D0  ; have it write into a palette that isn't ours

skip:
lea $400000, A1

done:
rts