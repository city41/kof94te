# Continue Scene

The subroutine at 45d7e looks to set it up.

It's similar to the win scene, but simpler.

045D7E: 206D 4FD0 movea.l ($4fd0,A5), A0
045D82: 1B68 00D8 5556 move.b  ($d8,A0), ($5556,A5)
045D88: 7000 moveq #$0, D0
045D8A: 1028 0131 move.b ($131,A0), D0
045D8E: 1B40 5555 move.b D0, ($5555,A5)
045D92: D040 add.w D0, D0
045D94: D040 add.w D0, D0
045D96: 41F9 0005 34DC lea $534dc.l, A0
045D9C: D1C0 adda.l D0, A0
045D9E: 1B50 5552 move.b (A0), ($5552,A5)
045DA2: 1B68 0001 5553 move.b ($1,A0), ($5553,A5)
045DA8: 1B68 0002 5554 move.b ($2,A0), ($5554,A5)
045DAE: 4E75 rts

It looks to be moving the character Ids for the losing team into $5552(A5) (10d552) through $5554(A5) (10d554)

It is, except this routine does not set up the x values. The characters get that elsewhere. Team leaders are always in the center, but second and third could be on right or left, just depends on the team.

I think the table for x values is at 45448.

It gets loaded into A0 in the 45406 subroutine.

The table at 45448 looks like it might be 48 words, x/y for each character?

045448: 009D 0098 006D 009A 00D9 0097 0092 0098 .....m..........
045458: 00DA 0098 0067 0098 009E 009A 0069 009A .....g.......i..
045468: 00E2 0095 006C 0090 008E 008D 00D4 0097 .....l..........
045478: 0061 0098 009B 009C 00E9 0097 00A1 0095 .a..............
045488: 0069 0098 00C8 0095 00AD 009C 00E8 0098 .i..............
045498: 006F 0093 00DE 0099 00A2 009A 0073 009A .o...........s..

If that is true, then Heidern will be at (9d,61) or (157,97)

continueX.lua confirms that is the table indeed!

At 45428, it does move.l, so this implies the table is xy pairs
