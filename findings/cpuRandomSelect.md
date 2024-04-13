# CPU Random Select

Flag Tiles

| Team    | Left Tiles  | Right Tiles | Palette |
| ------- | ----------- | ----------- | ------- |
| Italy   | 1dcac,1dcad | 1dcae,1dcaf | c7      |
| China   | 1dcb0,1dcb1 | 1dcb2,1dcb3 | c6      |
| Japan   | 1dcb4,1dcb5 | 1dcb6,1dcb7 | c3      |
| USA     | 1dcb8,1dcb9 | 1dcba,1dcbb | de      |
| Korea   | 1dcbc,1dcbd | 1dcbe,1dcbf | c4      |
| Brazil  | 1dcc0,1dcc1 | 1dcc2,1dcc3 | c5      |
| England | 1dcc4,1dcc5 | 1dcc6,1dcc7 | df      |
| Mexico  | 1dcc8,1dcc9 | 1dcca,1dccb | e0      |

When a team has been defeated, their flag is greyed out using palette

| Team    | Palette | written to |
| ------- | ------- | ---------- |
| Mexico  | ea      |            |
| England | e9      | 101980     |
| China   | e6      |            |
| USA     | e8      | 101f80     |
| Japan   | e3      |            |
| Brazil  | e5      | 101b80     |

The written to addresses don't look to be dynamic. Each team always writes to the same address

During team select that palette (e9) gets written when England has been defeated at 42ac

e9 appears to get written to 101980, which is pulled from 37e07

37dc4 btst D0, $7df(A5) (1087df)

I _think_ that byte stores the defeated teams

### The whole routine

037D7A: 022C 003F 007C andi.b #$3f, ($7c,A4)
037D80: 397C 001B 0070 move.w  #$1b, ($70,A4)
037D86: 197C 00FF 0068 move.b  #$ff, ($68,A4)
037D8C: 197C 00FF 0069 move.b  #$ff, ($69,A4)
037D92: 397C 0073 002C move.w  #$73, ($2c,A4)
037D98: 296D 104C 0018 move.l  ($104c,A5), ($18,A4)
037D9E: 296D 1058 001C move.l  ($1058,A5), ($1c,A4)
037DA4: 42AC 0020      clr.l   ($20,A4)
037DA8: 066C 0090 0018 addi.w  #$90, ($18,A4)
037DAE: 066C 00C8 001C addi.w  #$c8, ($1c,A4)
037DB4: 28BC 0003 7DBA move.l  #$37dba, (A4)
037DBA: 422C 0080      clr.b   ($80,A4)
037DBE: 7000           moveq   #$0, D0
037DC0: 102C 0131      move.b  ($131,A4), D0
037DC4: 012D 07DF      btst    D0, ($7df,A5)
037DC8: 6722           beq     $37dec
037DCA: 4A2D 0230      tst.b   ($230,A5)
037DCE: 6A06           bpl     $37dd6
037DD0: B02D 0231      cmp.b   ($231,A5), D0
037DD4: 6716           beq     $37dec
037DD6: 4A2D 0430      tst.b   ($430,A5)
037DDA: 6A06           bpl     $37de2
037DDC: B02D 0431      cmp.b   ($431,A5), D0
037DE0: 670A           beq     $37dec
037DE2: 41FA 001C      lea     ($1c,PC) ; ($37e00), A0
037DE6: 1970 0000 0080 move.b  (A0,D0.w), ($80,A4)
037DEC: 302C 00D0      move.w  ($d0,A4), D0
037DF0: 206C 0084 movea.l ($84,A4), A0
037DF4: 0128 00CF      btst    D0, ($cf,A0)
037DF8: 6700 F0B2 beq $36eac
037DFC: 4EF8 2682      jmp     $2682.w
037E00: E5E6           roxl.w  -(A6)
037E02: E3E8 E4E7      lsl.w   (-$1b19,A0)
037E06: EAE9           dc.w    $eae9; ILLEGAL
037E08: 397C 0004 0018 move.w  #$4, ($18,A4)
037E0E: 397C 0019 001C move.w  #$19, ($1c,A4)
037E14: 302C 0018      move.w  ($18,A4), D0
037E18: 322C 001C      move.w  ($1c,A4), D1
037E1C: 4EB9 0000 5FDE jsr     $5fde.l
037E22: 207C 0005 3516 movea.l #$53516, A0
037E28: 303C 2300      move.w  #$2300, D0
037E2C: 223C 0020 0000 move.l  #$200000, D1
037E32: 4EB9 0000 5F0C jsr     $5f0c.l
037E38: 28BC 0003 7E3E move.l  #$37e3e, (A4)
037E3E: 302C 00D0      move.w  ($d0,A4), D0
037E42: 206C 0084 movea.l ($84,A4), A0
037E46: 0128 00CF      btst    D0, ($cf,A0)
037E4A: 6700 F05E beq $36eaa
037E4E: 302C 0018      move.w  ($18,A4), D0
037E52: 322C 001C      move.w  ($1c,A4), D1
037E56: 343C 0023      move.w  #$23, D2
037E5A: 363C 0000      move.w  #$0, D3
037E5E: 4EB9 0000 5FEA jsr     $5fea.l
037E64: 4EF8 2682      jmp     $2682.w
037E68: 42AC 0018      clr.l   ($18,A4)
037E6C: 42AC 001C      clr.l   ($1c,A4)
037E70: 42AC 0078      clr.l   ($78,A4)
037E74: 42AC 007C      clr.l   ($7c,A4)
037E78: 42AC 0050      clr.l   ($50,A4)
037E7C: 42AC 0054      clr.l   ($54,A4)
037E80: 197C 00FF 0068 move.b  #$ff, ($68,A4)
037E86: 197C 00FF 0069 move.b  #$ff, ($69,A4)
037E8C: 426C 002E clr.w ($2e,A4)
037E90: 4E75 rts

this is what really causes the game to set a grey palette

037DD6: 4A2D 0430 tst.b ($430,A5)
037DDA: 6A06 bpl $37de2
037DDC: B02D 0431 cmp.b ($431,A5), D0
037DE0: 670A beq $37dec
037DE2: 41FA 001C lea ($1c,PC) ; ($37e00), A0
037DE6: 1970 0000 0080 move.b (A0,D0.w), ($80,A4)

if the byte at 108430 is positive, set a grey palette. But seems that byte is pretty much always 2, the previous condition is

037DD0: B02D 0231 cmp.b ($231,A5), D0

### Brazil

When writing a grey'd Brazillian Flag tile, it gets the grey palette (E5) from 101b80

It normally gets it from f6d44 where the c5 palette is set

A2 = F6D42
A1 = 101B00

; pull the palette word from ROM into D0
004178: 102A 0002 move.b ($2,A2), D0
; check to see if an override palette has been set
00417C: 4A29 0080 tst.b ($80,A1)
; if not, skip setting override palette
004180: 6706 beq $4188
; otherwise, swap in override palette
004182: 1029 0080 move.b ($80,A1), D0

108231 holds the team ID of the currently playing team for p1 side. When Italy is chosen, it's 5.

;; compare the team we are graying out to the currently chosen team
037DD0: B02D 0231 cmp.b ($231,A5), D0
;; are they the same? then skip ahead and don't grey the team out
037DD4: 6716 beq $37dec

### btst'ing

| bit | value | team    |
| --- | ----- | ------- |
| 6   | 40    | Mexico  |
| 7   | 80    | England |
| 0   | 1     | Brazil  |
| 4   | 10    | Korea   |
| 3   | 8     | USA     |
| 2   | 4     | Japan   |
| 1   | 2     | China   |
| 5   | 20    | Italy   |

- tests all 8 bits
- assuming one bit per team
- bits are not tested in order, do teams have non sorted IDs?
- it tests the repeatedly.

When the bit is set, it doesn't branch, and immediately tst's the byte at 108230

## The Team Defeat Byte

Now quite confident that 1087df stores which teams have been defeated. That byte alone does not tell the whole story though, as just setting it via lua seems to do nothing

## Potential team defeated bytes

These bytes have 1 bit set after beating one team, 2 after beating two, and 3 after beating three

108371,108378,108432,108433,108481,108483,108485,1087de,1087df,1087e0,1087e1,1087e2

bp at 37046

### After beating China

1087df: 2, which tracks

maybe another byte is how many teams have been defeated?

1087de: 1
1087e0: 1

### After beating China and Japan

1087df: 6
1087de: 2
1087e0: 2

6 is unexpected, but might track
2: 10
6: 110

### After beating China, Japan, Italy

1087df: 26 ???
1087de: 5
1087e0: 5

### After beating Mexico

1087df: 4

### Where the defeat byte is read

| address | times       | theory                                                             |
| ------- | ----------- | ------------------------------------------------------------------ |
| 35100   | 8           | at start of fight, calculating how hard the cpu opponent should be |
| 35100   | 8           | determing if 4 or 8 teams have been defeated for cutscene or boss  |
| 35044   | 1           | noting a team has been defeated with bset                          |
| 37dc8   | every frame | ???                                                                |
| 37596   | every frame | ???                                                                |
| 3765a   | every frame | ???                                                                |

## calling the rng

When the user presses A on team select, routine 375f8 is called

This is only called once, just before cpu random select.

;; call the RNG (I think), leaving a random byte in D0
0375F8: 4EB8 2582 jsr $2582.w
;; knock that random byte down to four bits
0375FC: 0200 000F      andi.b  #$f, D0
;; knock it down to 3 bits
037600: E208 lsr.b #1, D0
;; add 8 to it
037602: 5040 addq.w #8, D0
;; move it to 1081d2 (if p2 is playing) or 1083d2 (if p1 is playing)
;; since the whole word is moved, the byte ends up in 108(1/3)d3, known
;; to be CPU_RANDOM_SELECT_COUNTER_FOR_PX
037604: 3940 00D2 move.w D0, ($d2,A4)
037608: 397C 0004 00D4 move.w  #$4, ($d4,A4)
03760E: 396C 00D4 00D6 move.w ($d4,A4), ($d6,A4)
037614: 526C 00D0 addq.w #1, ($d0,A4)
037618: 4E75 rts
