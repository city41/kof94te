;; guardPalettes
;; while in character select, makes sure the game doesn't clobber our palettes
;;
;; but the game needs it palettes too, so instead of clobber they are written
;; to the side, and restored later during teardown

cmpi.b #1, $IN_CHAR_SELECT_FLAG
bne skip ; not in char select? nothing to do
cmpi.w #15, D0
ble skip ; not touching one of our palettes? nothing to do
cmpi.w #102, D0
bge skip ; not touching one of our palettes? nothing to do
move.w #102, D0  ; have it write into a palette that isn't ours

skip:
lea $400000, A1

done:
rts