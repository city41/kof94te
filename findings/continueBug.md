# Continue Bug

THe hack does not re-play the same team after continuing.

## hack cause

The cause is the hack writes zero to 108431 (p2 team id) and 5
to 1083c0 (p2 team select index) upon continuing.

108431 is zero'd at 34f80

034F80: 196D 07E0 0131 move.b ($7e0,A5), ($131,A4)
034F86: 196D 07E1 0132 move.b ($7e1,A5), ($132,A4)
034F8C: 196D 07E2 0133 move.b ($7e2,A5), ($133,A4)
034F92: 196D 07E3 0134 move.b ($7e3,A5), ($134,A4)
034F98: 4E75 rts

## vanilla

Vanilla does the same write at 34f80, but it is the correct team id

## ($7e0,A5) -- 1087e0

This is the byte that gets written to 108431

In vanilla, when the cpu team id is determined, it is written here before the match starts and not written to again. So upon continuing the correct byte is carried over

In the hack it is clr.b'd and not written to
324c2 clr.b ($7e0,A5)

In vanilla, it is also cleared at 324c2 but then written at
37672 move.b ($131,a4), ($7e0,a5)

## Tracing

from clr.b to 37f38 (match start)

bp 324c2,, { trace traces/continueBug/og.txt,,, { tracelog "D0=%x D1=%x D2=%x D3=%x D4=%x D5=%x D6=%x D7=%x A0=%x A1=%x A2=%x A3=%x A4=%x A5=%x A6=%x PC=%x -- ",d0,d1,d2,d3,d4,d6,d6,d7,a0,a1,a2,a3,a4,a5,a6,pc }; g }

bp 37f38,, { trace off; g }

37046 -- team select
...
37046
37672 -- write cpu team
370bc -- order select
...
370bc

is 37646 hit in the hack?
this is the routine that sets the chosen cpu team
nope

is 375ba hit in the hack?
it is what invokes 37646 via a dynamic jump
it is, but apparently never sets up the dynamic jump

how vanilla sets up the dynamic jump

it sets it up when 1083d0.w == 0002

037596: beq $375c2
037598: move.w  ($d0,A4), D0
03759C: add.w D0, D0
03759E: add.w D0, D0
0375A0: lea ($42,PC) ; ($375e4), A0
0375A4: nop
0375A6: btst #$2, ($785,A5)
0375AC: bne $375ba
0375AE: btst #$6, ($7e6,A5)
0375B4: beq $375ba
0375BA: movea.l (A0,D0.w), A0

maybe the hack always skips via the branch
it hits this, but D0 is 1 instead of 2, causing it to not hit the dynamic branch
it seems to skip when D0==2 though

so now need to see why 1087e6 is different

it needs to be $40 for the dynamic jump to occur

vanilla writes to 7e6

1087E6:0 at C05550
1087E6:0 at 26C8
1087E6:0 at 324C2
1087E6:0 at 26C8
1087E6:0 at 324C2
1087E6:0 at 3271E
1087E6:3 at 37010
1087E6:2 at 3783E
1087E6:6 at 37844
1087E6:46 at 3767E
1087E6:44 at 3783E
1087E6:4C at 37844
1087E6:4F at 37EBC

hack writes to 7e6

1087E6:0 at C05550
1087E6:0 at 26C8
1087E6:0 at 324C2
1087E6:0 at 26C8
1087E6:0 at 324C2
1087E6:0 at 3271E
1087E6:3 at 37010
1087E6:2 at 3783E
1087E6:6 at 37844
1087E6:4 at 3783E
1087E6:C at 37844
1087E6:F at 37EBC
1087E6:E at 385A0
1087E6:1E at 385A8
1087E6:1C at 385A0
1087E6:3C at 385A8

the routine at 37672 writes the $40

37672 move.b ($131,A4), ($7e0,A5)
37678 ori.b #$40, ($7e6,A5)
move.b #$10, ($1,A6)
rts

It is also writting the chosen team to 7e0, which is the root cause of the bug

seems the hack not calling this function is a culprit

it gets called via

037656: btst D0, ($7df,A5)
03765A: beq $37672
037672: move.b ($131,A4), ($7e0,A5)

the hack never goes to 37656
