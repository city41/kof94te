# Team Select

When on the team select screen, the current cursor index is stored at 1081C0

## When team changes

Whenever the team index changes it

- checks for cursor wrapping at sets it to zero/max if needed
- bsr's to 373a0
  - it writes a byte to 108231
    - these seem to never change
    - italy: 5
    - china: 1
    - jpn: 2
    - usa: 3
    - kor: 4
    - brz: 0
    - eng: 7
    - mex: 6
  - this byte is read at 379ac, every frame, regardless of index change
    - in subroutine 379a2, which was a dynamic jump

379a2

Once the player selects a team, it overwrites the index value with a new value

move.b $135(a4), $c0(a4) where $c0(a4) is 1081c0.

Here are the bytes that get moved depending on team chosen

| team | index | value |
| ---- | ----- | ----- |
| Itl  | 0     | 0f    |
| Chn  | 1     | 03    |
| Jpn  | 2     | 06    |
| USA  | 3     | 09    |
| Kor  | 4     | 0c    |
| Brz  | 5     | 00    |
| Eng  | 6     | 15    |
| Mex  | 7     | 12    |

These values don't change depending on what team the CPU picks.

The lua script, `forceTeamItalyToBeUSA.lua` successfully forces a selection of Team Italy to be USA once the game starts. The order select screen still shows Italy, but I am guessing they just reused the sprites and don't bother to update them as normally they would not change.

## The Timer

Team Select runs on a timer and once elapsed chooses the currently focused team for you.

The timer looks to be a word at 108654, confirmed with `teamSelectTimerNeverElapses.lua`

At 37440 it compares the timer to 141e. when it goes under that it starts running some additional stuff.

It is checking for zero at 3706a
sbcd d0, d1
bcs 3707c

## Player Memory Blocks

From 108110 to 10830f is a memory block for player 1, and 108310 to 10850f is player 2's block. They are 512 bytes each.

These blocks contain a starting "tag" in ascii, that indicates what the block is currently being used for, where X is either '1' or '2' depending on the player

| tag      | use                                                   |
| -------- | ----------------------------------------------------- |
| PLAYERXI | set before a player has pressed start to start a game |
| PXSELECT | set after pressing start and during how to play       |
| PX TEAM  | set when the player is choosing their team            |
| PXMEMBER | set when the player is choosing the player order      |
| PLAYER X | set while the match is playing                        |

"PLAYER X" is set throughout the entire match and win screen. It goes back to "PX TEAM" when choosing the next team to fight.

### When picking character order

terryOrderDumps contain the p1 memory block with team italy chosen and Terry as the 1st, 2nd and 3rd character.

108232 through 108234 seem to be the order

terry1.txt
108230: 8105 0F10 11

terry2.txt
108230: 8105 100F 11

terry3.txt
108230: 8105 1011 0F

It seems to be

| value | character |
| ----- | --------- |
| 0F    | Terry     |
| 10    | Andy      |
| 11    | Joe       |

So far, `src/lua/forceTeamItalyOrder.lua` creates a team of two Heiderns and a Joe :O

When first coming into character order select, it writes from 1081c0 to 108232.

I think 1081c0 through 1081c2 is the currently selected team. For Italy it is `0f1011`, which should be Terry(0f)|Andy(10)|Joe(11)

## Sprites

### Background

The background sprites are
97, 98, 129-144
115-116

sprite 97

| tile | palette |
| ---- | ------- |
| 0    | 0       |
| 4293 | b0      |
| 4100 | b0      |
| 4108 | b0      |
| 4110 | b0      |
| 4118 | b0      |
| 4120 | b0      |
| 4128 | b0      |
| 4130 | b0      |
| 4138 | b0      |
| 4180 | b0      |
| 4188 | b0      |
| 4190 | b2      |
| 4198 | b2      |
| 41a0 | b2      |
| 41a8 | b2      |

### Flag interface

Also see countryFlags.md

The flag sprite indexes vary depending on how you get to the team select screen. Suggesting the engine has a sprite pool of some sort.

## Routines

- 36e66: first function that runs to start team select

  - it calls numerous subroutines, but I doubt most are relevant because it calls c004c8, clear sprites bios routine. After that, it calls 371c4 then 36ec0
    - 371c4: loads the background
    - 36ec0: loads the flags and background
      - seems 371c4 is dependent on 36ec0, it doesn't seem like it can load the background independently

- 37046: Runs player choosing their team.

  - it runs two subroutines: 371fe and 3721c
    - 371fe: sets up player one's character sprites
    - 3721c: sets up player two's character sprites
    - these run every frame, so changing a team will naturally cause the new characters to appear
    - interestingly, order select does not use these functions
  - if the timer on team select runs out, it sets 37086
    - 37086 is a nest of stuff, but ultimately it seems to be "pick whichever team is highlighted, then run cpu team select" (wherever that is...)

### 371c4: load the background routine

This routine just moves several values into memory. If this doesn't
happen, there is no background in team/member select screens, so these
values ultimately drive sprites

a5: 108000

; 109044 = $0021
0371C4: 3B7C 0021 1044 move.w #$21, ($1044,A5)
; 109046 = $00a1
0371CA: 3B7C 00A1 1046 move.w  #$a1, ($1046,A5)
; 109048 = $001f
0371D0: 3B7C 001F 1048 move.w #$1f, ($1048,A5)
; 10904a = $006c
0371D6: 3B7C 006C 104A move.w #$6c, ($104a,A5)
; 10903c = 0000
0371DC: 3B7C 0000 103C move.w #$0, ($103c,A5)
; 109040 = (109048, which was set to $001f just above)
0371E2: 3B6D 1048 1040 move.w ($1048,A5), ($1040,A5)
; 109040 += 1, 109040 becomes $0020
0371E8: 526D 1040 addq.w #1, ($1040,A5)
; 10903e = 0000
0371EC: 3B7C 0000 103E move.w #$0, ($103e,A5)
; 109042 = (10904a, which was set to $006c above)
0371F2: 3B6D 104A 1042 move.w ($104a,A5), ($1042,A5)
; 109042 += 1 becoms $006d
0371F8: 526D 1042 addq.w #1, ($1042,A5)
; exit
0371FC: 4E75 rts

### 36ec0 loads the flags and ultimately causes team select bg and flags to appear

hoo this is a big one

it calls 31c4 once, $1568 twice, and $260e 4 times

036EC0: 7009 moveq #$9, D0
036EC2: 4EB8 31C4           jsr     $31c4.w
036EC6: 42AD 104C           clr.l   ($104c,A5)
036ECA: 42AD 1058           clr.l   ($1058,A5)
036ECE: 422D 501C           clr.b   ($501c,A5)
036ED2: 422D 501D           clr.b   ($501d,A5)
036ED6: 422D 0653           clr.b   ($653,A5)
036EDA: 7000                moveq   #$0, D0
036EDC: 41FA 0C5A           lea     ($c5a,PC) ; ($37b38), A0
036EE0: 4EB8 1568           jsr     $1568.w
036EE4: 237C 0010 8584 0084 move.l  #$108584, ($84,A1)
036EEC: 337C 0061 006A      move.w  #$61, ($6a,A1)
036EF2: 237C 6364 6364 00C0 move.l  #$63646364, ($c0,A1)
036EFA: 337C 0000 00D0 move.w #$0, ($d0,A1)
036F00: 7001 moveq #$1, D0
036F02: 41FA 0CCE           lea     ($cce,PC) ; ($37bd2), A0
036F06: 4EB8 1568           jsr     $1568.w
036F0A: 237C 0010 8584 0084 move.l  #$108584, ($84,A1)
036F12: 337C 0081 006A      move.w  #$81, ($6a,A1)
036F18: 237C 2525 2525 00C0 move.l  #$25252525, ($c0,A1)
036F20: 337C 0001 00D0 move.w #$1, ($d0,A1)
036F26: 7C07 moveq #$7, D6
036F28: 41FA 0D6C           lea     ($d6c,PC) ; ($37c96), A0
036F2C: 303C 3500           move.w  #$3500, D0
036F30: 4EB8 260E           jsr     $260e.w
036F34: 237C 0010 8584 0084 move.l  #$108584, ($84,A1)
036F3C: 337C 0003 00D0      move.w  #$3, ($d0,A1)
036F42: 3346 002C move.w D6, ($2c,A1)
036F46: 3006                move.w  D6, D0
036F48: 0640 0031           addi.w  #$31, D0
036F4C: 3340 0072           move.w  D0, ($72,A1)
036F50: 236D 104C 0018      move.l  ($104c,A5), ($18,A1)
036F56: 236D 1058 001C      move.l  ($1058,A5), ($1c,A1)
036F5C: 42A9 0020           clr.l   ($20,A1)
036F60: 3006                move.w  D6, D0
036F62: D040                add.w   D0, D0
036F64: D040                add.w   D0, D0
036F66: 41FA 0D66           lea     ($d66,PC) ; ($37cce), A0
036F6A: 4E71                nop
036F6C: 2030 0000           move.l  (A0,D0.w), D0
036F70: D169 001C           add.w   D0, ($1c,A1)
036F74: 4840                swap    D0
036F76: D169 0018           add.w   D0, ($18,A1)
036F7A: 51CE FFAC           dbra    D6, $36f28
036F7E: 41FA 0D6E           lea     ($d6e,PC) ; ($37cee), A0
036F82: 303C 3500           move.w  #$3500, D0
036F86: 4EB8 260E           jsr     $260e.w
036F8A: 237C 0010 8584 0084 move.l  #$108584, ($84,A1)
036F92: 337C 0004 00D0      move.w  #$4, ($d0,A1)
036F98: 7C07 moveq #$7, D6
036F9A: 41FA 0DDE           lea     ($dde,PC) ; ($37d7a), A0
036F9E: 4E71                nop
036FA0: 303C 3500           move.w  #$3500, D0
036FA4: 4EB8 260E           jsr     $260e.w
036FA8: 237C 0010 8584 0084 move.l  #$108584, ($84,A1)
036FB0: 337C 0005 00D0      move.w  #$5, ($d0,A1)
036FB6: 3006 move.w D6, D0
036FB8: 0640 0039 addi.w #$39, D0
036FBC: 3340 0072           move.w  D0, ($72,A1)
036FC0: 41FA 03F0           lea     ($3f0,PC) ; ($373b2), A0
036FC4: 1370 6000 0131      move.b  (A0,D6.w), ($131,A1)
036FCA: 51CE FFCE           dbra    D6, $36f9a
036FCE: 41FA 0E38           lea     ($e38,PC) ; ($37e08), A0
036FD2: 303C 3500           move.w  #$3500, D0
036FD6: 4EB8 260E           jsr     $260e.w
036FDA: 237C 0010 8584 0084 move.l  #$108584, ($84,A1)
036FE2: 337C 0006 00D0      move.w  #$6, ($d0,A1)
036FE8: 4E75 rts

#### 31c4: this subroutine just bra's off...

this is a general routine, the very beginning of the game calls it

        D0  00000009
        D1  0000FFFF
        D2  0000FFFF
        D3  00007020
        D4  00000000
        D5  806A0000
        D6  0000FFFF
        D7  00000000
        A0  003C0002
        A1  001098C6
        A2  0006F0E0
        A3  00108F62
        A4  00108584
        A5  00108000
        A6  00108E4E

; D0 = D0 << 4 (from $9 to $90)
0031C4: E948 lsl.w #4, D0

; A0 = 3224
0031C6: 41FA 005C lea ($5c,PC) ; ($3224), A0

; A0 += D0, A0 = $32b4
0031CA: D0C0 adda.w D0, A0

D1 = *A0++, D1 = $300
0031CC: 3218 move.w (A0)+, D1
D2 = *A0++, D2 = $B0
0031CE: 3418 move.w (A0)+, D2
D3 = \*A0++, D3 = $40
0031D0: 3618 move.w (A0)+, D3

D3 -= 1, D3 = $3f
0031D2: 5343 subq.w #1, D3

REG_LSPCMODE = \*A0 ($0800)
set the auto animation speed to 8
0031D4: 33D0 003C 0006 move.w (A0), $3c0006.l

call $3512
0031DA: 6100 0336 bsr $3512

A0 = $343a
0031DE: 41FA 025A lea ($25a,PC) ; ($343a), A0
0031E2: 6000 0266 bra $344a

bra takes us here

; A2 = *(10b8a8, which is $10a0c6)
00344A: 246D 38A8 movea.l ($38a8,A5), A2
D0 = 0
00344E: 7000 moveq #$0, D0
D0 = *A0++, which was $65
003450: 3018 move.w (A0)+, D0

; branch if N flag is set, and it wasn't
003452: 6B24 bmi $3478

; \*A2 = D0, (10a0c6) = $65
003454: 3480 move.w D0, (A2)

; *A2 = *A2 & 0x00ff
; (10a0c6) = $65
003456: 025A 00FF      andi.w  #$ff, (A2)+

; A1 - $6f000
00345A: 43F9 0006 F000 lea $6f000.l, A1
D0 = D0 << 5, D0 becomes #ca0
003460: EB88 lsl.l #5, D0
; A1 += D0
; A1 becomes 6fca0
003462: D3C0 adda.l D0, A1
; A1 += 2
; A1 becomes 6fca2
003464: 5489 addq.l #2, A1

; *A1++ = *A2++
; A1 = 6fcA2
; A2 = 10a0c8
; looping numerous times, setting up values in RAM
; at 10a0c8 and beyond
003466: 34D9 move.w (A1)+, (A2)+
003468: 24D9 move.l (A1)+, (A2)+
00346A: 24D9 move.l (A1)+, (A2)+
00346C: 24D9 move.l (A1)+, (A2)+
00346E: 24D9 move.l (A1)+, (A2)+
003470: 24D9 move.l (A1)+, (A2)+
003472: 24D9 move.l (A1)+, (A2)+
003474: 24D9 move.l (A1)+, (A2)+
003476: 60D6 bra $344e
003478: 34BC FFFF      move.w  #$ffff, (A2)
00347C: 2B4A 38A8 move.l A2, ($38a8,A5)
003480: 4E75 rts

#### $1568

001568: 43F9 0010 907C lea $10907c.l, A1
00156E: 3F00           move.w  D0, -(A7)
001570: E148           lsl.w   #8, D0
001572: D2C0           adda.w  D0, A1
001574: 45D1           lea     (A1), A2
001576: 303C 000F      move.w  #$f, D0
00157A: 429A clr.l (A2)+
00157C: 429A clr.l (A2)+
00157E: 429A clr.l (A2)+
001580: 429A clr.l (A2)+
001582: 51C8 FFF6 dbra D0, $157a
001586: 2288           move.l  A0, (A1)
001588: 301F           move.w  (A7)+, D0
00158A: ED48           lsl.w   #6, D0
00158C: 41F9 0010 C1A8 lea     $10c1a8.l, A0
001592: D0C0           adda.w  D0, A0
001594: 2348 00A0      move.l  A0, ($a0,A1)
001598: 0029 0080 006E ori.b #$80, ($6e,A1)
00159E: 4E75 rts

# $260e

00260E: 3E2D 0580 move.w ($580,A5), D7
002612: 6B00 005C bmi $2670
002616: 556D 0580 subq.w #2, ($580,A5)
00261A: 43ED 0500 lea ($500,A5), A1
00261E: 3271 7000 movea.w (A1,D7.w), A1
002622: D3FC 0010 0000 adda.l #$100000, A1
002628: 2288 move.l A0, (A1)
00262A: 3340 0008 move.w D0, ($8,A1)
00262E: 41ED 8100 lea (-$7f00,A5), A0
002632: 2E08 move.l A0, D7
002634: 3E28 0004 move.w ($4,A0), D7
002638: 2047 movea.l D7, A0
00263A: B068 0008 cmp.w ($8,A0), D0
00263E: 64F4 bcc $2634
002640: 3348 0004 move.w A0, ($4,A1)
002644: 3368 0006 0006 move.w ($6,A0), ($6,A1)
00264A: 3E28 0006 move.w ($6,A0), D7
00264E: 3149 0006 move.w A1, ($6,A0)
002652: 2047 movea.l D7, A0
002654: 3149 0004 move.w A1, ($4,A0)
002658: 41E9 0010 lea ($10,A1), A0
00265C: 303C 001E move.w #$1e, D0
002660: 7E00 moveq #$0, D7
002662: 20C7 move.l D7, (A0)+
002664: 20C7 move.l D7, (A0)+
002666: 20C7 move.l D7, (A0)+
002668: 20C7 move.l D7, (A0)+
00266A: 51C8 FFF6 dbra
00266E: 4E75 rts

## 371fe: load p1 character sprites

0371FE: 2C6D 07EA movea.l ($7ea,A5), A6
037202: 082D 0005 8000 btst #$5, (-$8000,A5)
037208: 6704 beq $3720e
03720A: 4DED 39CA lea ($39ca,A5), A6
03720E: 49ED 0100 lea ($100,A5), A4
037212: 2054 movea.l (A4), A0
037214: 4E90 jsr (A0)
037216: 422E 0001 clr.b ($1,A6)
03721A: 4E75 rts

37214 is jumping to 3723A on the first time, and 37274 from then on. 3723A just "bleeds" into 37274 so the first time through it just does a bit more setup

## 3721c: load p2 character sprites

03721C: 2C6D 07EE movea.l ($7ee,A5), A6
037220: 082D 0005 8000 btst #$5, (-$8000,A5)
037226: 6704 beq $3722c
037228: 4DED 39E0 lea ($39e0,A5), A6
03722C: 49ED 0300 lea ($300,A5), A4
037230: 2054 movea.l (A4), A0
037232: 4E90 jsr (A0)
037234: 422E 0001 clr.b ($1,A6)
037238: 4E75 rts

37232 does the same thing as in the p1 routine above
