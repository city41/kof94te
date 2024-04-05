# Alt Colors

Alternate team colors can be chosen by pressing C or D at team select instead of A or B.

## P1MEMBER memory diff

only a few

| address | normal | alt  | note                                                      |
| ------- | ------ | ---- | --------------------------------------------------------- |
| 10812a  | 6f3e   | 6f32 | This value changes rapidly per frame, not likely relevant |
| 108174  | 0006   | 0000 | "                                                         |
| 10817e  | 0002   | 0001 | Possibly the current frame of animation                   |
| 1081d8  | 0000   | 0100 | Doesn't seem read                                         |

## MEMBDISP diff

a lot more

| address | normal | alt  |
| ------- | ------ | ---- |
| 10292a  | 22e6   | 19e8 |
| 10296a  | ffe8   | ffe0 |
| 10296c  | ff80   | ff90 |
| 102972  | 005e   | 0000 |
| 102974  | 0012   | 0000 |
| 102976  | 0f5e   | 0f00 |
| 102978  | 1300   | 0300 |
| 102990  | 03fc   | 0300 |
| 1029d8  | 0000   | 0100 |
| 102b02  | 7ac0   | 7ae6 |

1029d8 is a byte that controls alt color

0: normal color
1: alt color

This was additionally confirmed by having newCharSelect_runBoth set 1 at that address too.

but this does not carry into the game

## Game reading chosen team

The p1 side player's chosen team id is stored at 108231 as a byte. p2 side is at 108431

At 374de it goes into a subroutine if it is a mirror match

0374DA: move.b ($131,A2), D1
0374DE: cmp.b   ($131,A4), D1
0374E2: bne     $374f8
;; if they are the same, go here
0374E4: bsr     $374fa
;; ...
0374FA: movea.l ($b6,A4), A2
0374FE: moveq #$2, D0
037500: tst.b ($130,A4)
037504: bpl $37512
037512: tst.b ($130,A2)
037516: bmi $3751a

;; load p1's team into D1
0374DA: move.b ($131,A2), D1
;; compare p1's team to p2's team
0374DE: cmp.b   ($131,A4), D1
;; if they are different, bail
0374E2: bne     $374f8
;; otherwise head into this small routine
;; which will set D0 to 0, 1, 2 or 3
0374E4: bsr     $374fa
0374FA: movea.l ($b6,A4), A2
0374FE: moveq #$2, D0
037500: tst.b ($130,A4)
037504: bpl $37512
037512: tst.b ($130,A2)
037516: bmi $3751a
03751A: rts
;; from there D0 is used to grab a routine pointer out of a table
0374E8: add.w D0, D0
0374EA: add.w D0, D0
;; load the start of the table into A2
0374EC: lea ($2e,PC) ; ($3751c), A2
0374F0: nop
;; jump to the chosen offset
0374F2: movea.l (A2,D0.w), A2
;; invoke that function
0374F6: jsr (A2)

the table of routine pointers
3752c
37534
3753c
37544

### 3753c routine

in this case we jumped to 3753c which is a tiny routine

03753C moveq #$1, D0
03753E sub.b (A1), D0
037540 move.b D0, (A0)
037542 rts

ultimately this stored a 1 at 10d01d

### 374fa routine

ultimately set D0 to be 0, 1, 2 or 3

;; a pointer to a pointer, 1083b6 contains 108100
;; A2 = 108100
0374FA: 246C 00B6 movea.l ($b6,A4), A2
;; D0 = 2
0374FE: 7002 moveq #$2, D0
;; is 108430 zero?
037500: 4A2C 0130 tst.b ($130,A4)
;; if it's positive, jump down
037504: 6A0C bpl $37512
;; D0 = 0
037506: 7000 moveq #$0, D0
;; is 108230 zero?
037508: 4A2A 0130 tst.b ($130,A2)
;; if negative, go to exit
03750C: 6B0C bmi $3751a
;; D0 += 1
03750E: 5240 addq.w #1, D0
;; exit
037510: 6008 bra $3751a
;; is 108230 zero?
037512: 4A2A 0130 tst.b ($130,A2)
;; if negative, go to exit
037516: 6B02 bmi $3751a
;; D0 += 1
037518: 5240 addq.w #1, D0
03751A: 4E75 rts

moving on, we eventually arrive at
6590 move.w (A0, D0.w), ($38c0, A5)

this changes 10b8c0 from 0060 to 0061

65a0 move.w ($38c0,a5), (a0,d0.w)

this changes 10b8fa from 0000 to 0061

possibly a palette? nope, nobody seems to have that as a palette

## Choosing an alt color team

When choosing an alt color team with C or D

The game writes 1 at 1029d8 for char0, but it also writes ff to 102978 at 379d8

## Byte that controls the entire team

1081d8 for p1 side and 1083d8 for p2 side is a byte that determines if the entire team gets alt colors in team and order select.

The coloring does not carry into the game
