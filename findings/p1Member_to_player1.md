# P1MEMBER -> PLAYER 1

These are the reads the first frame `PLAYER 1` is the tag

PLAYER 1 (895:read) 108170 : f
PLAYER 1 (895:read) 10811c : 2f0
PLAYER 1 (895:read) 108168 : ffff
PLAYER 1 (895:read) 108230 : 8105
PLAYER 1 (895:read) 1081e4 : 0
PLAYER 1 (895:read) 108118 : 240
PLAYER 1 (895:read) 10811a : 0

## 108170

on the first frame, `PLAYER 1` reads 0x108170 to find out who player one's current character is. "Current" meaning "the one that is now fighting"

When `player1108170.lua` returns 6, Kyo fights, but everything else shows Terry. For example if you lose, it will show Terry sulking in the background, and Terry's portrait crossed out.

If you play the match all the way to victory, the game crashes right when the winning team would be coming on screen (at least with Kyo)

## 10811c

returning zero has makes p1's character be invisible

# 108168

returning zero has makes p1's character be invisible

# 108230

returning zero puts both players into cpu mode

# 1081e4

Normally returns zero (at least at start of match)
Returning the mask instead (0xff00) causes Terry to have no hitboxes. Except cpu could throw him.

# 108118

player 1's x location within the context of the entire stage

- 0x240: default starting position at start of fight
- 0x220: over left by 32 pixels
- 0x180: over left by 192 pixels (way off screen at start of match)

# 10811a

Is zero before match and between rounds

During rounds returns different values when p1 is hit. But forcing return zero has no obvious effect
