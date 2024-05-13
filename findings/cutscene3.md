#cutscene 3

Rugal's IMPOSSIBLE HOW COULD I LOSE A BATTLE part is its own scene that runs for all teams.

Here is team Mexico's cutscene 3 dialog

1572be: ROBERT
1572cc: .YOU.SEE
1572e0: .THIS.IS.KYOKU-
157300: .GENRYU.KARATE
157320: RUGAL
15732c: .TCH
157340: .KYOKUGENRYU
15735a: .KARATE
15736a: .SO
157372: .IT.DEPENDS.ON
157390: .THE.PRACTIONER
1573b2: .BUT
1573bc: .I.WON'T
1573ce: .LET.YOU.GET.OUT
1573f0: .OF.HERE.ALIVE
157410: RUGAL
15741c: .A.WATERY.GRAVE
15743c: .AWAITS.YOU
157456: .FAREWELL
15746c: RYO
157474: .WATCH.OUT
15748c: .LET'S.GET.OUT
1574aa: .OF.HERE

572be is accessed at 63c6
63C6: move.w (A1)+, D1
A1 is 572be

A1 loaded at 63ac
movea.l $c0(A4), A1

lot's of similaries to cutscene2, but the routine at 443ea is not called for these cutscenes

team Mexico is set for cutscene 3, the game doesn't seem to access the team list for this.

## Andy's Y

In cutscene 2 Andy's Y is 74, and that is read from 43d08, which is BB

In cutscene 3, his Y is 79.

So possibly a value of BB+5 BB-5 is read from ROM somewhere.

Sadly there is a ton of 00C0 and 00B6 words in the ROM.

## Andy's X

cutscene 2: 129
cutscene 3: 93

cutscene 2 reads X from 43d06, which is 93

## reading the team id

cutsceneInit is able to set a team id that cutscene 3 will use.

After setting the id, the game then reads it at 3bf7c,
3bf7C: move.b ($131,A3), ($c8,A4)

In a p1 game, it writes the team id to 10864c

It does this very soon after calling c004c8 (clear sprites bios routine)

it reads 10864c back out at 3bf9a

it quadruples it, then uses it as an offset into a table which is at 3e84a

#### This is loading the ending

hack `cutscene3_dontQuadrupleTeamId.json` nops out the two add.w D0,D0 calls.

If we were using team China (id 1), those adds would end up with 4.

So with the nops, and choosing team Korea, we see China's ending. So this routine is getting the ending loaded.

03BF98: 7000 moveq #$0, D0
03BF9A: 102C 00C8           move.b  ($c8,A4), D0
03BF9E: D040 add.w D0, D0
03BFA0: D040 add.w D0, D0
03BFA2: 41FA 28A6 lea ($28a6,PC) ; ($3e84a), A0
03BFA6: 2970 0000 00C0      move.l  (A0,D0.w), ($c0,A4)
03BFAC: 297C 0003 BFB4 0036 move.l #$3bfb4, ($36,A4)
03BFB4: 206C 00C0           movea.l ($c0,A4), A0
03BFB8: 2018 move.l (A0)+, D0
03BFBA: 6B0A bmi $3bfc6
03BFBC: 2880                move.l  D0, (A4)
03BFBE: 2948 00C0           move.l  A0, ($c0,A4)
03BFC2: C188 exg D0, A0
03BFC4: 4ED0 jmp (A0)
03BFC6: 022D 00FD 38B8 andi.b #$fd, ($38b8,A5)
03BFCC: 426D 38BA clr.w ($38ba,A5)
03BFD0: 2B7C 0004 43FC 0584 move.l #$443fc, ($584,A5)
03BFD8: 4E75 rts

table at 3e84a

03E84A: 0003 E86E 0003 E8A2 0003 E8DE 0003 E91E ...n............
03E85A: 0003 E95E 0003 E996 0003 E9E2 0003 EA26 ...^...........&
03E86A: 0003 E86E ...n

the first entry is 3e86e, then 3e8a2, which are 56 bytes apart, but entries two and three are 60 bytes apart. The tables are variable width, with an FFFFFFFF long to signify the end.

table at 3e86e

03E86E: 0003 BFDA 0000 0000 0003 C174 0000 0001 ...........t....
03E87E: 0003 C27C 0000 0002 0000 0003 0000 0004 ...|............
03E88E: 0003 C5CE 0003 C732 0000 0005 0003 C7A4 .......2........
03E89E: FFFF FFFF ....

This table has pointers and then longs that are 0,1,2,3,4 or 5

The pointers might be pointing to palette data?

03BFDA: 41FA 26AC 7000 4EB8 1568 337C 007D 006A A.&.p.N..h3|.}.j
03BFEA: 6100 265E 237C 9E01 0101 00C0 337C FFB0 a.&^#|......3|..

03C174: 4DFA 25E4 4E71 7000 102C 00C8 D040 D02C M.%.Nqp..,...@.,
03C184: 00C8 E748 DCC0 266C 0084 7C02 7A00 303C ...H..&l..|.z.0<

03C27C: 41FA 240A 7000 4EB8 1568 337C 007D 006A A.$.p.N..h3|.}.j
03C28C: 6100 23BC 237C 9E01 0101 00C0 337C FFB0 a.#.#|......3|..

03C5CE: 303C E000 41FA FF7A 4EB8 260E 136C 00C8 0<..A..zN.&..l..
03C5DE: 00C8 41FA 20A6 7000 4EB8 1568 337C 007D ..A. .p.N..h3|.}

03C732: 303C 0022 4EB8 6588 41FA 1F4C 7000 4EB8 0<."N.e.A..Lp.N.
03C742: 1568 337C 007D 006A 6100 1EFE 237C 9101 .h3|.}.ja...#|..

03C7A4: 41FA 1EE2 7000 4EB8 1568 337C 007D 006A A...p.N..h3|.}.j
03C7B4: 6100 1E94 237C 9001 0101 00C0 337C FFB0 a...#|......3|..

## reading 10864c again

Right before cutscene 3 starts, 10864c is read again at 3c17c

this happens in subroutine 3bfb4

tracing through a lot ...

at 3c1a2 it does

03C1A2 move.w (A6)+, ($70,A1) 335E 0070
03C1A6 move.w (A6)+, ($18,A1) 335E 0018
03C1AA move.w (A6)+, ($1c,A1) 335E 001C
03C1AE move.w (A6)+, ($2c,A1) 335E 002C

and A6 is 3e78a

03E78A: 0006 00B2 00C0 0100 0007 0098 00C0 00E0 ................
03E79A: 0008 0076 00C0 00F0 000B 00BE 00C0 0100 ...v............
03E7AA: 0009 0094 00C0 00E0 000A 0078 00C0 00F0 ...........x....
03E7BA: 000C 00B2 00C0 0100 000D 0096 00C0 00E0 ................

which might be x/y pair?

## the dialog

cutscene 3's first line is 56444 for team USA

note that the hack overwrites this text due to the Japan ending being too long.

156444: BRIAN
15644e: <nl>
156450: SEE?
15645a: <nl>
15645c: WE ARE THE
156472: <nl>
156474: STRONGEST
156488: <nl>
15648a: IN THE WORLD!
1564a6: e
1564a8: RUGAL
1564b2: <nl>
1564b4: Y··YES
1564c2: c
1564c4: <nl>
1564c6: YOU ARE···
1564dc: <nl>
1564de: BUT
1564e6: c
1564e8: I STILL
1564f8: <nl>
1564fa: CAN'T DIE
15650e: <nl>
156510: THIS WAY!!
156526: e
156528: RUGAL
156532: <nl>
156534: A WATERY GRAVE
156552: <nl>
156554: AWAITS YOU!
15656c: <nl>
15656e: FAREWELL!!
156584: e
156586: LUCKY
156590: <nl>
156592: LOOK OUT!
1565a6: <nl>
1565a8: LET'S GET OUT
1565c4: <nl>
1565c6: OF HERE!
1565d8: e

this is read at 63c6, which is the general cutscene text routine

63c6: move.w (A1)+, D1

A1 is loaded at

63AC: movea.l ($c0,A4), A1, 10943c

10943c is written at

3E72E: move.l A0, ($c0,A4)

and A0 loads just shortly before

108836 is the language ID

```
03EA76: 7000 moveq #$0, D0                ; D0 = 0
03EA78: 102D 0836 move.b ($836,A5), D0    ; D0 = language ID
03EA7C: D040 add.w D0, D0                 ; quadruple for indexing
03EA7E: D040 add.w D0, D0                 ; quadruple for indexing
03EA80: 41F9 0005 4216 lea $54216.l, A0   ; A0 = 54216, a pointer table
03EA86: 2070 0000 movea.l (A0,D0.w), A0   ; A0 += D0, jump forward based on language ID
03EA8A: 3001 move.w D1, D0                ; D1 = D0
03EA8C: D040 add.w D0, D0                 ; D0 *= 2
03EA8E: D040 add.w D0, D0                 ; D0 *= 2 - language ID has now been mulitplied by 16
03EA90: 2070 0000 movea.l (A0,D0.w), A0   ; A0 += (16 * language ID)
03EA94: 4E75 rts
```

3ea76 is the routine that drives cutscene 3's and the ending's dialog.

It gets called numerous times looking to load the next line of text into A0.

### reading the team id at 3c17c

here it is tripling the ID, which is bizarre.

03C17A moveq #$0, D0                                     7000
 03C17C  move.b  ($c8,A4), D0 102C 00C8
03C180 add.w D0, D0 D040
03C182 add.b ($c8,A4), D0 D02C 00C8
03C186 lsl.w #3, D0 E748
03C188 adda.w D0, A6 DCC0

So Japan becomes 6. So if we nop out the tripling, pick Mexico, we should see team Japan
subbed in somewhere...

We see team Japan's character sprites in cutscene 3. woohoo!

The subroutine starts at 3bfb4, but it does a jmp (A0) at 3bfc4

That dynamic jump depends on whether it's rendering rugal or the team

the team: jmp to 3c174
rugal: jmp to 3c27c

### denying the 4 word writes

A1=100500
03C1A2: move.w (A6)+, ($70,A1)
03C1A6: move.w (A6)+, ($18,A1)
03C1AA: move.w (A6)+, ($1c,A1)
03C1AE: move.w (A6)+, ($2c,A1)

Starting at 3c1a2, the game takes A6 and writes four words out of it to memory.

A6's final address for this is derived from the team ID

Choose Japan and deny all words: no characters show up
Choose Japan and deny first word: cutscene shows Heidern standing alone
Choose Japan and deny second word: address error
Choose Japan and deny third word: address error
Choose Japan and deny fourth word: address error

Whan Japan, the first word is 0006, which is Kyo's ID. Denying the first word caused Heidern to show up,
so this byte feels like "team leader", although it is strange that only heidern showed up instead of the entire team Brazil.

It is next read at 32e6 and appears to be used for indexing into a list.

032B3A: jsr (A0)
0025A8: rts
032B3C: move.l A4, D7
032B3E: move.w ($4,A4), D7
032B42: bpl     $32b36
032B36: movea.l D7, A4
032B38: movea.l (A4), A0
032B3A: jsr     (A0)
03C238: moveq   #$1, D3
03C23A: jsr     $32e6.w
0032E6: move.w  ($70,A4), D0
 0032EA  add.w   D0, D0                                      D040
 0032EC  add.w   D0, D0                                      D040
 0032EE  moveq   #$0, D1                                     7200
 0032F0  move.b  ($d8,A4), D1 122C 00D8
0032F4 add.w D1, D1 D241
0032F6 add.w D1, D0 D041
0032F8 lea ($d8,PC) ; ($33d2), A0                      41FA 00D8
 0032FC  move.w  (A0,D0.w), D1                               3230 0000
 003300  moveq   #$0, D2                                     7400
 003302  move.b  ($30,A4), D2                                142C 0030
 003306  addi.w  #$10, D2                                    0642 0010
 00330A  bra     $3512                                       6000 0206
 00330E  move.w  ($70,A4), D0                                302C 0070
 003312  add.w   D0, D0                                      D040
 003314  add.w   D0, D0                                      D040
 003316  moveq   #$0, D1                                     7200
 003318  move.b  ($d8,A4), D1 122C 00D8
00331C add.w D1, D1 D241
00331E add.w D1, D0 D041
003320 lea ($b0,PC) ; ($33d2), A0                      41FA 00B0
 003324  move.w  (A0,D0.w), D1                               3230 0000
 003328  add.w   D4, D1                                      D244
 00332A  moveq   #$0, D2                                     7400
 00332C  move.b  ($30,A4), D2                                142C 0030
 003330  addi.w  #$10, D2                                    0642 0010
 003334  subq.w  #1, D3                                      5343
 003336  moveq   #$0, D0                                     7000
 003338  move.w  D1, D0                                      3001
 00333A  addq.w  #1, D1                                      5241
 00333C  andi.w  #$ff, D2 0242 00FF
003340 move.w D2, (A2)+ 34C2
003342 addq.w #1, D2 5242
003344 lea $6f000.l, A3                                47F9 0006 F000
 00334A  lsl.l   #5, D0                                      EB88
 00334C  adda.l  D0, A3                                      D7C0
 00334E  addq.l  #2, A3                                      548B
 003350  move.w  (A3)+, (A2)+                                34DB
 003352  move.l  (A3)+, (A2)+                                24DB
 003354  move.l  (A3)+, (A2)+                                24DB
 003356  move.l  (A3)+, (A2)+                                24DB
 003358  move.l  (A3)+, (A2)+                                24DB
 00335A  move.l  (A3)+, (A2)+                                24DB
 00335C  move.l  (A3)+, (A2)+                                24DB
 00335E  move.l  (A3)+, (A2)+                                24DB
 003360  dbra    D3, $3336                                   51CB FFD4
 003364  move.w  #$ffff, (A2) 34BC FFFF
003368 rts 4E75
00336A move.w ($70,A4), D0                                302C 0070
 00336E  add.w   D0, D0                                      D040
 003370  add.w   D0, D0                                      D040
 003372  moveq   #$0, D1                                     7200
 003374  move.b  ($d8,A4), D1 122C 00D8
003378 add.w D1, D1 D241
00337A add.w D1, D0 D041
00337C lea ($54,PC) ; ($33d2), A0                      41FA 0054
 003380  move.w  (A0,D0.w), D1                               3230 0000
 003384  moveq   #$0, D2                                     7400
 003386  move.b  ($30,A4), D2                                142C 0030
 00338A  addi.w  #$10, D2                                    0642 0010
 00338E  moveq   #$d, D3 760D
003390 lea ($42ce,A5), A2                              45ED 42CE
 003394  cmpi.w  #$10, D2                                    0C42 0010
 003398  beq     $339e                                       6704
 00339A  lea     ($44ce,A5), A2                              45ED 44CE
 00339E  moveq   #$0, D0                                     7000
 0033A0  move.w  D1, D0                                      3001
 0033A2  addq.w  #1, D1                                      5241
 0033A4  andi.w  #$ff, D2 0242 00FF
0033A8 move.w D2, (A2)+ 34C2
0033AA addq.w #1, D2 5242
0033AC lea $6f000.l, A3 47F9 0006 F000
0033B2 lsl.l #5, D0 EB88
0033B4 adda.l D0, A3 D7C0
0033B6 addq.l #2, A3 548B
0033B8 move.w (A3)+, (A2)+ 34DB
0033BA move.l (A3)+, (A2)+ 24DB
0033BC move.l (A3)+, (A2)+ 24DB

#### Different team writes

Japan

writing 6 to 100570 ; writing Kyo
writing B2 to 100518
writing C0 to 10051C
writing 100 to 10052C
writing 7 to 100770 ; writing Benimaru
writing 98 to 100718
writing C0 to 10071C
writing E0 to 10072C
writing 8 to 100970 ; writing Daimon
writing 76 to 100918
writing C0 to 10091C
writing F0 to 10092C

there it is! it writes to these four bytes three times!

### dialog, A0 and D0.

The game hits the routine at 3ea8e to load the next chunk of dialog.

bp 3ea8e,, { printf "a0: %x, d0: %x",a0,d0; g }

d0 is offset by words, so to get the pointer it's A0 + (D0 \* 2)
the game does this with add.w D0, D0 before offsetting

USA
a0: 54306, d0: 0 -> points to 55956 = RUGAL I..IMPOSSIBLE!...
a0: 54306, d0: 28 -> 56444 = BRIAN SEE? WE ARE THE STRONGEST
a0: 54306, d0: 2A -> 564a8 = RUGAL Y...YES YOU ARE...
a0: 54306, d0: 2C -> 56528 = RUGAL A WATERY GRAVE AWAITS...
a0: 54306, d0: 2E -> 56586 = LUCKY LOOK OUT!...

England
a0: 54306, d0: 0 -> 55956 = RUGAL I...IMPOSSIBLE!...
a0: 54306, d0: 62 -> 5777e = MAI LOOK! THIS IS THE DOOM...
a0: 54306, d0: 64 -> 57854 = RUGAL HA HA HA HA!...
a0: 54306, d0: 66 -> 57960 = RUGAL DIE WITH ME!...
a0: 54306, d0: 68 -> 5799e = KING OH NO! LET'S GET AWAY

Mexico
a0: 54306, d0: 0 -> 55956 = RUGAL I...IMPOSSIBLE!...
a0: 54306, d0: 52 -> 572be = ROBERT YOU SEE? THIS IS...
a0: 54306, d0: 54 -> 57320 = RUGAL TCH.... KYOKU...
a0: 54306, d0: 56 -> 57410 = RUGAL A WATER GRAVE AWAITS YOU...
a0: 54306, d0: 58 -> 5746c = RYO WATCH OUT!...

Japan
a0: 54306, d0: 0 -> 55956 = RUGAL I...IMPOSSIBLE!...
a0: 54306, d0: 1A -> 560ea = BENIMARU WE ARE NO. 1!...
a0: 54306, d0: 1C -> 56130 = RUGAL Y...YES
a0: 54306, d0: 1E -> 561ae = RUGAL A WATER GRAVE AWAITS YOU
a0: 54306, d0: 20 -> 561f4 = BENIMARU JESUS! LET'S GET AWAY!
