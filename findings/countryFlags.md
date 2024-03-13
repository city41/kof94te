# Country Flags

The country flags on the team select screen use different sprites depending on how you get to the screen. Seems the game is using a sprite pool

# Italian flag

Going straight into the p1 team select screen

left side is sprites 203 and 317

| tile  | palette |
| ----- | ------- |
| 1dcac | c7      |
| 1dcad | c7      |

The entity info is stored at f6d10 in ROM
That address is pointed to in ROM at 953d0

That address is written into RAM at 102528

it is pulled out of RAM at 3F40: movea.l ($28,a1), a2

## Entity Data

0F6D10: 0202 C701 DCAC C000 C000 0202 C601 DCB0 ................
0F6D20: C000 C000 0202 C301 DCB4 C000 C000 0202 ................

| address | value  | description         |
| ------- | ------ | ------------------- |
| f6d10   | 02     | width in tiles      |
| f6d11   | 02     | height in tiles     |
| f6d12   | C7     | palette index       |
| f6d13-5 | 01DCAC | starting tile index |
| f6d16-7 | C000   | [1]                 |
| f6d18-9 | C000   | [2]                 |

[1] This value causes tiles to get rearranged, but so far can't figure out what the intent is

| value      | result                                             |
| ---------- | -------------------------------------------------- |
| 0-3000     | tiles shifted right by 8px                         |
| 4000- 7000 | tiles shifted right and wrap to lower left         |
| 8000-b000  | tiles wrap around square strangely                 |
| c000-f000  | tiles are as expected (c000 is the original value) |
| c100-cf00  | no change, tiles as expected                       |
| c010-c0f0  | no change, tiles as expected                       |

[2]

| value      | result                                             |
| ---------- | -------------------------------------------------- |
| 0-3000     | tiles shifted left by 8px                          |
| 4000- 7000 | tiles shifted left and wrap to lower right         |
| 8000-b000  | tiles wrap around square strangely                 |
| c000-f000  | tiles are as expected (c000 is the original value) |
| c100-cf00  | no change, tiles as expected                       |
| c010-c0f0  | no change, tiles as expected                       |

The entities march along as expected

f6d10 - Italy
f6d1a - China
f6d24 - Japan
f6d2e - USA
...

but then there is what looks like an entity but it doesn't quite add up, and I can't get Terry to replace the Japanese flag

# tracing back the italian flag

- At 3f40, 102528 is loaded into A2: `movea.l #28(a1), a2` - 102528 contains `000f6d10`, the address of the italian flag entity

- A1 gets loaded from D1 at 3f3e: `movea.l d1, a1`, d1 = 102500

- D1 gets loaded via two steps

  - 3f3a: move.l a5, d1
  - 3f3c: move.w d0, d1
    -remember move.w will only replace the bottom two bytes, so both moves are useful
    - so at this point, a5 is where this all comes from
  - based on trying to trace and figure out when A5 gets loaded, it seems to be set very early in the game and possibly never unset
    - it occasionally changes during HTP, but vast majority of time, A5 is 108000 from game start on

- D1 being 102500 only happens once in team select

  - this is done by first (3f3a) move.l a5, d1, setting 108000
  - then (3f3c) move.w d0, d1, setting 102500
  - figuring out how d0 got to be 2500 seems next
    - happens just above at 3f32: move.ws (a0)+, d0
    - a0 was 10892c when that happened, and it is 2500
    - the game then clears the value out immediately: (3f36) clr.w -$2(a0)

- who is setting 10892c to 2500? wp 10829c,2,w,wpdata == 2500

  - 485a: move.w a4, -$2(a1)
    -a4: 102500, a1: 10892e
  - possibly a1 being 10892e is the key here

- A1 is involved in a loop around 4836, where move.w (a1)+, d1 is happening a lot
- A1 is originally set at 481e: lea $838(a5), a1
  - this happens due to a hardcoded branch: 3e7c: bra $481a
  - but this branch happens as soon as the game starts too
    - at start, a4 is 100500
    - htp, a4 is 100700
    - team select, a4 is 108100

A4 is loaded at 3720e: lea $100(a5), a4

37870 is cmpa.l #$108100, a4

seems 37046 kicks all this off, and that is one of the FPs discovered earlier

# 37046

;; jump to subroutine 371fe
037046: 6100 01B6 bsr $371fe
;; jump to subroutine 3721c
03704A: 6100 01D0 bsr $3721c

d0: 000f0078
d1: 00000000
d2: 00108100
d3: 00000000
d4: 08402e40
d5: 80210138
d6: 0000ffff
d7: 00000000
a0: 00108100
a1: 0010892c
a2: 000534f4
a3: 0010880a
a4: 00108300
a5: 00108000
a6: 0010ba1e

; move a byte from 1087e6 to D0
03704E: 102D 07E6 move.b ($7e6,A5), D0

; and that byte with 3 (bottom two bits)
037052: 0200 0003 andi.b #$3, D0

; if no bits from 3 up were set, go to 370a6, which jumps clear out of this routine
037056: 6700 004E beq $370a6

; subtract 1 from the byte at 108655
03705A: 532D 0655 subq.b #1, ($655,A5)

; if that byte is not zero, go to 36ea8
03705E: 6600 FE48 bne $36ea8

; D0 = 1
037062: 7001 moveq #$1, D0

; D1 = 0
037064: 7200 moveq #$0, D1

move the byte at 108654 into D1
037066: 122D 0654 move.b ($654,A5), D1

; does a BCD subtract: D0 = D0 - D1
03706A: 8300 sbcd D0, D1

; branch to 3707c if carry was set
; in other words, skip the next two instructions
03706C: 6500 000E bcs $3707c

; move a byte of D1 into 108654
037070: 1B41 0654 move.b D1, ($654,A5)

; set 108655 to 3c
037074: 1B7C 003C 0655 move.b #$3c, ($655,A5)
03707A: 4E75 rts

; move 37086 into 108584 (set the next function pointer)
03707C: 2B7C 0003 7086 0584 move.l #$37086, ($584,A5)
037084: 4E75 rts
