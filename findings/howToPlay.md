# How To Play

032B3A: jsr (A0)
03B9D2: btst #$4, ($3a02,A5)
03B9D8: beq $3b9e4
03B9DC: move.l #$36e66, ($584,A5)
03B9E4: rts

the btst #$4 seems to be looking if A is pressed

032AEA: jsr $45e3e.l
045E3E: btst #$3, ($80c,A5)
045E44: beq $45e54
045E54: btst #$4, ($80c,A5)
045E5A: beq $45e6a
045E6A: rts

on the other hand, 45e54's btst is happening at all game phases

032AFC: jsr $673e.l
00673E: btst #$4, (-$7fff,A5)
006744: bne $6752
006748: tst.b ($4704,A5)
00674C: bmi $68fc
006750: rts

673e is also happening in all game phases

## Upon detecting A

03B9D2: 082D 0004 3A02 btst #$4, ($3a02,A5)
03B9D8: 6700 000A beq $3b9e4
03B9DC: 2B7C 0003 6E66 0584 move.l #$36e66, ($584,A5)
03B9E4: 4E75 rts

If A is pressed, it moves a constant into memory and exits

That address is 108584

36e66 feels like an address, and it likely is

036E50: 3434 4EB9 move.w INVALID 34, D2
036E54: 0000 35AA ori.b #$aa, D0
036E58: 4EB9 0000 2336 jsr $2336.l
036E5E: 022C 007F 006E andi.b #$7f, ($6e,A4)
036E64: 4E75 rts

036E66: 3B7C 0000 38B0 move.w #$0, ($38b0,A5)
036E6C: 41FA 0036 lea ($36,PC) ; ($36ea4), A0
036E70: 4E71 nop

### other addresses the game writes there

pressing coin to go to title screen
325c4 (move.l #$325c4 $584(a5) (108584))
39264 looks like start of subroutine
325c4 looks like start of subroutine
39264  
3934e arbitary code

press start to enter how to play
3b06e
1558
3b6b8
1558
3b6f8
1558

press A to enter team select
3b72c
1558
36e66 (this is what it first writes upon A pressed)
36fea
37046 -- runs team select

press A to enter member select
(after CPU finishes their team selection)
370bc
37100
37eb2
37edc

finish order selection, go into match
37f38
37f40
1558
37f86
37fa8
33cfa
3515a
351d8
351ee

after stage intro is done
33fec

after a character dies
34286
342ac
3523a
35276
3529a
3530e
3532c
33fec

# 370bc

370bc is written to 108584 at 370b4, just the line above. This feels like continuation passing. Like the game knows it's out of time and needs to do frame maintenance, so by setting the next line's address it will pick up where it left off.

# wildJumps.json

This patch swaps out setting 370bc as the fp and instead writes 3b72c.

result: In the team select screen, press A to pick a team. Once the cpu picks its team, it starts running how to play on top of team select sprites
