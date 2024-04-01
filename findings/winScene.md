# Win Scene

If you win the match with a character on a different team from the leader, the game locks up.

Upon entering win scene, 108110 becomes PLAYER 1. Actually it becomes that when the match starts and doesn't change for win scene.

108232 is the team's character IDs, repeated

chose Team Italy
108232: 0F10 110F 1011 ......

## Team leaders

Leaders are the characters with the same ID as the team: Terry, Athena, Heavy D, Kyo, etc.

Three Andys locks the game, but three Terrys don't --> no leader on team

Choosing Terry last or first doesn't make a difference --> doesn't matter where on the team the leader is.

# Locking the game

Unexpectedly, this did not lock the game

- team: Terry/Joe/Chang
- Chang plays first
- Chang wins
- Team Korea win scene

But this did

- team: Terry/Joe/Chang
- Terry plays first
- Terry wins
- Team Korea win scene

somehow choosing Chang caused Korea to be the "team"

It seems the last character you choose determines the team?

Lock the game repo

- choose Sie
- choose Andy
- choose Terry
- order: Sie, Andy, Terry
- win with Sie

Interestingly, a team of three Andys locks up, but a team of three Sies does not. But if I force three Sies with the lua script, it locks up.

This has to do with team select running in the background. For example when picking three Changs, team select ends up on Korea, so all is good.

# Team Select memory dumps

choose three Terrys (team Italy)

> find 100000,0f2ff,b.f
> Found at 100529
> Found at 100729
> Found at 100929
> Found at 100B29
> Found at 100D04
> Found at 100D29
> Found at 100F29
> Found at 101106
> Found at 101129
> Found at 101329
> Found at 101519
> Found at 101729
> Found at 101929
> Found at 101B29
> Found at 101D29
> Found at 101F29
> Found at 102129
> Found at 102329
> Found at 102971
> Found at 102978
> Found at 102B71
> Found at 102B78
> Found at 102D71
> Found at 102D78
> Found at 108129
> Found at 1081C0
> Found at 1081C1
> Found at 1081C2
> Found at 108235
> Found at 108236
> Found at 108237
> Found at 108329
> Found at 108570
> Found at 1087E6
> Found at 109692
> Found at 109694
> Found at 109696
> Found at 109698
> Found at 10969A
> Found at 10969C
> Found at 10969E
> Found at 1096A0
> Found at 1096A2
> Found at 1096A4
> Found at 1096A6
> Found at 1096A8
> Found at 1096AA
> Found at 1096AC
> Found at 1096AE
> Found at 1096B0
> Found at 1096B2
> Found at 1096B4
> Found at 1096B6
> Found at 1096B8
> Found at 1096BA
> Found at 1096BC
> Found at 1096BE
> Found at 1096C0
> Found at 1096C2
> Found at 1096C4
> Found at 1096C6
> Found at 1096C8
> Found at 1096CA
> Found at 1096CC
> Found at 1096CE
> Found at 1096D0
> Found at 1096D4
> Found at 1096D6
> Found at 1096D8
> Found at 1096DA
> Found at 1096DC
> Found at 1096DE
> Found at 1096E0
> Found at 1096E2
> Found at 1096E4
> Found at 1096E6
> Found at 1096E8
> Found at 1096EA
> Found at 1096EC
> Found at 1096EE
> Found at 1096F0
> Found at 1096F2
> Found at 1096F4
> Found at 1096F6
> Found at 1096F8
> Found at 1096FA
> Found at 1096FC
> Found at 1096FE
> Found at 109700
> Found at 109702
> Found at 109704
> Found at 109706
> Found at 109708
> Found at 10970A
> Found at 10970C
> Found at 10970E
> Found at 109710
> Found at 109712
> Found at 1099B5
> Found at 109B75
> Found at 109D35
> Found at 109E48
> Found at 109E4A
> Found at 109E4C
> Found at 109E4E
> Found at 109E50
> Found at 109E52
> Found at 109E54
> Found at 109E56
> Found at 109E58
> Found at 109E5A
> Found at 109E5C
> Found at 109E5E
> Found at 109E60
> Found at 109E62
> Found at 109E64
> Found at 109EED
> Found at 10A0B3
> Found at 10A172
> Found at 10A192
> Found at 10A1B6
> Found at 10A1C8
> Found at 10A1CA
> Found at 10A1CC
> Found at 10A1CE
> Found at 10A1D0
> Found at 10A1D2
> Found at 10A1D4
> Found at 10A1D6
> Found at 10A1D8
> Found at 10A1DA
> Found at 10A1DC
> Found at 10A1DE
> Found at 10A1E0
> Found at 10A1E2
> Found at 10A1E4
> Found at 10A1F2
> Found at 10A212
> Found at 10A272
> Found at 10A27F
> Found at 10A3A8
> Found at 10A3AA
> Found at 10A3AC
> Found at 10A3AE
> Found at 10A3B0
> Found at 10A3B2
> Found at 10A3B4
> Found at 10A3B6
> Found at 10A3B8
> Found at 10A3BA
> Found at 10A3BC
> Found at 10A3BE
> Found at 10A3C0
> Found at 10A3C2
> Found at 10A3C4
> Found at 10A3CA
> Found at 10A3F4
> Found at 10A412
> Found at 10A455
> Found at 10C1A8
> Found at 10C1AA
> Found at 10C1AC
> Found at 10C1AE
> Found at 10C1B0
> Found at 10C1B2
> Found at 10C1B4
> Found at 10C1B6
> Found at 10C1B8
> Found at 10C1BA
> Found at 10C1BC
> Found at 10C1BE
> Found at 10C1C0
> Found at 10C1C2
> Found at 10C1C4
> Found at 10C1C6
> Found at 10C1C8
> Found at 10C1CA
> Found at 10C1CC
> Found at 10C1CE
> Found at 10C1D0
> Found at 10C1D2
> Found at 10C1D4
> Found at 10C1D6
> Found at 10C1D8
> Found at 10C1DA
> Found at 10C1DC
> Found at 10C1DE
> Found at 10C1E0
> Found at 10C1E2
> Found at 10C1E4
> Found at 10C1E6
> Found at 10C1E8
> Found at 10C1EA
> Found at 10C1EC
> Found at 10C1EE
> Found at 10C1F0
> Found at 10C1F2
> Found at 10C1F4
> Found at 10C1F6
> Found at 10C1F8
> Found at 10C1FA
> Found at 10C1FC
> Found at 10C1FE
> Found at 10C200
> Found at 10C202
> Found at 10C204
> Found at 10C206
> Found at 10C208
> Found at 10C20A
> Found at 10C20C
> Found at 10C20E
> Found at 10C210
> Found at 10C212
> Found at 10C214
> Found at 10C216
> Found at 10C218
> Found at 10C21A
> Found at 10C21C
> Found at 10C21E
> Found at 10C220
> Found at 10C222
> Found at 10C224
> Found at 10C226
> Found at 10C228
> Found at 10C22A
> Found at 10C22C
> Found at 10C22E
> Found at 10C230
> Found at 10C232
> Found at 10C234
> Found at 10C236
> Found at 10C238
> Found at 10C23A
> Found at 10C23C
> Found at 10C23E
> Found at 10C240
> Found at 10C242
> Found at 10C244
> Found at 10C246
> Found at 10C248
> Found at 10C24A
> Found at 10C24C
> Found at 10C24E
> Found at 10C250
> Found at 10C252
> Found at 10C254
> Found at 10C256
> Found at 10C258
> Found at 10C25A
> Found at 10C25C
> Found at 10C25E
> Found at 10C260
> Found at 10C262
> Found at 10C264
> Found at 10C266

choose three Changs (team Korea)

> find 100000,0f2ff,b.c
> Found at 102929
> Found at 102993
> Found at 102994
> Found at 102B29
> Found at 102B75
> Found at 102B93
> Found at 102B94
> Found at 102D29
> Found at 102D75
> Found at 102D93
> Found at 102D94
> Found at 102F75
> Found at 103175
> Found at 10A0E0
> Found at 10A4DA

choose three Heavy Ds (team USA)

> find 100000,0f2ff,b.9
> Found at 100704
> Found at 100B06
> Found at 102971
> Found at 102978
> Found at 102B71
> Found at 102B78
> Found at 102D71
> Found at 102D78
> Found at 1081C0
> Found at 1081C1
> Found at 1081C2
> Found at 108235
> Found at 108236
> Found at 108237
> Found at 108576
> Found at 1098B0
> Found at 1098B9
> Found at 1098F0
> Found at 1098F7
> Found at 109930
> Found at 1099B0
> Found at 109A70
> Found at 109A79
> Found at 109AB0
> Found at 109AB7
> Found at 109AF0
> Found at 109B70
> Found at 109C30
> Found at 109C39
> Found at 109C70
> Found at 109C77
> Found at 109CB0
> Found at 109D30
> Found at 109F0A
> Found at 109FBE
> Found at 109FFC
> Found at 10A0BE
> Found at 10A292
> Found at 10A478
> Found at 10A498

common addresses

# Lockup vs no lockup traces

At 3eb48 it does a btst 0 on 108653

It does this btst as the character falls. The moment the winning portraits should come on screen, that byte is 1 in the no lockup case and stays 0 in the lockup case

in the non lockup case, the 1 gets set at 3f69e with the ori

a0 is 108584

002E94: beq $2e98
002E96: bpl     $2ea6
002EA6: moveq   #-$1, D0
002EA8: rts
03F68A: tst.w   D1
03F68C: bpl     $3ea98
03F690: cmpi.w  #$6, ($20,A4)
03F696: bhi     $3ea98
03F69A: movea.l ($84,A4), A0
03F69E: ori.b   #$1, ($cf,A0)
03F6A4: move.l #$3f6ae, (A4)

it is or'ing at 108653

lock up case before or, byte is 0

non lockup case

    9 @ 108653-108653 write if wpdata == 1 do printf "setting: %
    A @ 108653-108653 read  if wpdata == 1 do printf "reading: %

setting: 1 at 3F6A4
reading: 1 at 3EB4E
reading: 1 at 3EB96
setting: 1 at 3F712
reading: 1 at 3F724
reading: 1 at 3FB94
reading: 1 at 3EBBA
reading: 1 at 3EBF0
setting: 1 at 3F9DA
reading: 1 at 3FB94
reading: 1 at 3EBFE
reading: 1 at 3EC4A
setting: 1 at 3FC82
reading: 1 at 3FB94
reading: 1 at 3EC58
reading: 1 at 3F724
reading: 1 at 3F724
reading: 1 at 3F724
reading: 1 at 3FB94

lockup case

setting: 1 at 3F6A4
reading: 1 at 3EB4E

in the non lockup case, the second read happens at
3eb90, which is arrived at by 3fd54, jsr (a0). The lock up case also runs 3fd54, but a0 is completely bogus: 41f90006 versus 3fd76 that it should be

03FD54: jsr (A0)
03FD76: lea $6266c.l, A0
03FD7C: moveq   #$0, D0
03FD7E: move.b  (A2), D0
03FD80: move.b  D0, ($5065,A5)
03FD84: move.b  (A0,D0.w), ($5062,A5)
03FD8A: move.b  ($1,A2), D0
03FD8E: move.b  D0, ($5066,A5)
03FD92: move.b  (A0,D0.w), ($5063,A5)
03FD98: move.b  ($2,A2), D0
03FD9C: move.b  D0, ($5067,A5)
03FDA0: move.b  (A0,D0.w), ($5064,A5)
03FDA6: move.l  #$626ee, ($506a,A5)
03FDAE: rts
03FD56: rts
03EB56: nop
03EB58: cmpi.b  #$18, ($5065,A5)
03EB5E: beq     $3eb80
03EB62: cmpi.b  #$19, ($5065,A5)
03EB68: beq     $3eb80
03EB6C: movem.l D0-D1/A0, -(A7)
03EB70: move.w  #$19, D0
03EB74: jsr     $6588.w
006588: lea     $51924.l, A0
00658E: add.w   D0, D0
006590: move.w  (A0,D0.w), ($38c0,A5)
006596: lea     ($38c4,A5), A0
00659A: moveq   #$0, D0
00659C: move.b  ($38bc,A5), D0
0065A0: move.w  ($38c0,A5), (A0,D0.w)
0065A6: addq.b  #2, ($38bc,A5)
0065AA: rts
03EB78: movem.l (A7)+, D0-D1/A0
03EB7C: bra     $3eb90
03EB90: andi.b  #$fe, ($653,A5)
03EB96: moveq #$0, D0

There are three functions the win scene can jump to in order to put the characters on screen

3fd76
3fdb0
3fdea

each function corresponds to which member of the team won the round, and that member is either the zero'th (leader), 1st or 2nd.

It uses the table at at 534dc to figure out which member the character is based on their ID.

0534DC: 0001 02FF 0304 05FF 0607 08FF 090A 0BFF ................
0534EC: 0C0D 0EFF 0F10 11FF 1213 14FF 1516 17FF ............

Each team leader likely points into their section of the table, for example Italy starts at 534f0

0534f0 0F1011FF

and if the winning character was Andy (10), the loop would exit with D2 set to 1, because it would find 10 was at offset 1 in this little table. Then it takes 1, quadruples it (add D2, D2 twice), and uses that to load 3fdb0 into A0, and the winning scene goes from there

This is done at routine 3fd58 When it returns, D2 should be 0, 1 or 2. Anything greater will lock the game up

## Prevent the lock up

This patch prevents the lock up by just always picking the team leader

    {
      "type": "prom",
      "description": "prevent win screens from locking up by always choosing team leader",
      "address": "13fd40",
      "subroutine": true,
      "patchAsm": [
        ";;; nothing to restore from the clobber",
        ";;;just always pick the team leader",
        "move.w #0, D2",
        "rts"
      ]
    }

But this often shows a widly different team from what the player is expecting. But good enough for now.
