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
