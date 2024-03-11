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
