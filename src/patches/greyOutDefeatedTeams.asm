;; looks at the defeated teams byte and swaps in grey tiles for any teams
;; that have been defeated on the character grid

move.w #7, D0

greyOutTeamIfDefeated:
btst D0, $DEFEATED_TEAMS
beq skipGreyOut
lea $2TEAM_TO_GREY_OUT_TABLE, A0 ; get the base address of map loaded
move.w D0, D1 ; copy the team id over as we need to multiply it
mulu.w #96, D1 ; each team is 24 word pairs -> 48 words -> 96 bytes
adda.w D1, A0 ; then use that to offset into the map

;; each team needs to replace 12 tiles
;; each double word is a [VRAMADDR]|[VRAMRW] pair
;; each tile writes two longs, as SCB1 has pairs of words per tile
;; so that totals 24 longs to write
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR
move.l (A0)+, $VRAMADDR

skipGreyOut:
dbra D0, greyOutTeamIfDefeated

rts