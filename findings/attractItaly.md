# Attract Mode, Italy

Goal is to try and replace some of the team Italy characters with characters from Mexico or Japan

108584 seems to trigger at 38b20

Andy's leftmost sprite

| tile | palette |
| ---- | ------- |
| 0    | 0       |
| 0    | 0       |
| 0    | 0       |
| 0    | 0       |
| 3cb8 | cc      |
| 3cbb | cc      |
| 3cbe | cc      |
| 3cc0 | cc      |
| 0    | 0       |
| 0    | 0       |
| 0    | 0       |
| 0    | 0       |
| 0    | 0       |
| 0    | 0       |
| 0    | 0       |
| 0    | 0       |

Andy's tilemap is at 2dcc00.

It pulls that out at $80(a4), 2c0000 and manipulates D0 a lot

0024AE: movea.l ($80,A4), A0
0024B2: lsl.l #8, D0
0024B4: add.l D0, D0
0024B6: add.l D0, D0
0024B8: adda.l D0, A0
0024BA: rts

This happens when D0=73

how does D0=73?

2542: move.l (A7)+, D0 ; D0 = 73010101
then lots of crazy shifting, rolling, etc to arrive at D0=73, the very topy byte

002542: move.l (A7)+, D0
002544: bsr $244c
00244C: move.l  D0, D1
00244E: lea     $3c0000.l, A1
002454: move.w  ($6a,A4), D4
002458: lsl.w   #6, D4
00245A: addi.w  #$0, D4
00245E: move.l  D1, D0
002460: rol.l   #8, D0
002462: andi.l  #$ff, D0
002468: bsr $24ae
0024AE: movea.l ($80,A4), A0
0024B2: lsl.l #8, D0

A7 = 10f2f0

it gets written into from 10923c
39aac: move.l $c0(A4), D0

and there is a crazy hardcoding that kicks this all off

39922: move.l #$73010101, $c0(A1)

there are similar hardcodings

3994e: move.l #$75010101, $c0(A1)
3998a: move.l #$74010101, $c0(A1)

going to try a patch that swaps two of these
success! the patch swapped Andy and Joe around

73 = Andy 39922
74 = Joe 3998a
75 = Robert 3994e
76 = Takuma 399b6
77 = Benimaru 39f92
78 = Goro 39fd2
