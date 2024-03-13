; truncateSprites: sets a run of sprites height to zero
; starting sprite index is in d2, ending is in d3
move.w #$8200, d4 ; load SCB3 into d4
add.w d2, d4 ; move into correct starting spot within SCB3
move.w d4, $3C0000 ; load SCB3 into REG_VRAMADDR
move.w #1, $3C0004 ; load 1 into REG_VRAMMOD
truncateSprite:
move.w #0, $3C0002 ; set y, sticky and height to zero in REG_VRAMRW
addq.w #1, d2      ; increment d2
cmp.w d2, d3       ; compare d2 and d3
beq done           ; did d2 reach d3? we are done
bra truncateSprite ; do it again, MOD will move us to the right spot
done:
rts
