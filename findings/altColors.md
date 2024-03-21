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

but this does not carry into the game

This was additionally confirmed by having newCharSelect_runBoth set 1 at that address too.
