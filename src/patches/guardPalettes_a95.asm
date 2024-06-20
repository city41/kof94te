;; guardPalettes_a95
;; while in character select, makes sure the game doesn't clobber our palettes
;;
;; this is specific to the KOF95/98 avatars version. The only difference is the number of palettes
;; (78 versus 77)

cmpi.b #1, $IN_CHAR_SELECT_FLAG
bne skip ; not in char select? nothing to do
; cmpi.w #15, D0
; ble skip ; not touching one of our palettes? nothing to do
; cmpi.w #94, D0
; bge skip ; not touching one of our palettes? nothing to do
move.w #94, D0  ; have it write into a palette that isn't ours

skip:
lea $400000, A1

done:
rts