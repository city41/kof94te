# Wait Cycles and the MiSTer

## The Problem

Neo Geo games can optionally slow down the 68k's usage of the data bus ([wiki](https://wiki.neogeodev.org/index.php?title=Wait_cycle)). This is primarily to slow down VRAM writes.

KOF94 does this, and so MiSTer also does this when playing KOF94. It knows its playing KOF94 if NGH is 55.

Originally, KOF94TE also set its NGH number to 55. This used to work fine in MiSTer, before they added the wait cycle changes. Now in current version of MiSTer, KOF94TE's character select screen is horribly laggy. This is because the hack was written not knowing about wait cycles. With them turned off, there is enough cpu bandwidth to run the original title screen in the background and KOF94TE's char select screen. With them on, the 68k runs too slow to accomodate both, causing the massive lag.

## Short Term fix

As a short term fix, KOF94TE's NGH number was changed to 729. This makes the MiSTer no longer think it is vanilla KOF94, therefore it leaves wait cycles to full speed, and the 68k is then fast enough to run the hack.

But this causes some graphical glitches when playing KOF94TE on the MISTer, as KOF94 needs the wait cycles to avoid those glitches.

## Long term fix

Have KOF94TE only run char select and stop running team select. An initial exploration of this was done by skipping some function calls in 37046 (the routine that runs team select). This causes KOF94TE to run fast enough on the MiSTer with the wait cycles turned on. But more work is needed...

- The CPU randomization is still laggy and slow on the MiSTer. Likely need to also turn off the game doing this and have the hack do it entirely.

- After beating the first team, you have to wait a very long time at char select for the game to move on. It eventually will, but it feels like 30 seconds or so? It's way too long.

## Notes

CPU random select seems to be at 37092. It calls this function repeatedly while selecting a CPU team.

## ready to exit char select

tha main hack forces a non-zero test so that it doesn't do a `beq` at 3744e

if it doesn't take the branch, it does

```
 037450  move.w  D1, D0                                      3001
 037452  bsr     $374a4                                      6100 0050
 037456  bra     $3745e                                      6000 0006
 03745A  bsr     $3754c                                      6100 00F0
 03745E  bsr     $37806                                      6100 03A6
 037462  rts                                                 4E75
```
