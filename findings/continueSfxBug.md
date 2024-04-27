# Continue SFX Bug

When continuing, a character will say something. That character is often not on the custom team.

## The character

The character that speaks is based on who truly lost the match. Whoever lost the match, get a "representative" from their team and load their sfx. For example, Chang loses, load a Kim sfx. Sie/Chin loses -> Athena sfx.

That representative is not always the team leader. For example it's Mai for team England.

The rep's ID is loaded via this routine

;; A0 = \_10cfd0, in this case it was 108100, team 1
045D7E: 206D 4FD0 movea.l ($4fd0,A5), A0

;; $10d556 = *$1081d8, in this case it was zero
045D82: 1B68 00D8 5556      move.b  ($d8,A0), ($5556,A5)

D0 = 0
045D88: 7000 moveq #$0, D0

D0 = \*108231, load the losing team ID
045D8A: 1028 0131 move.b ($131,A0), D0

10d555 = losing team ID
045D8E: 1B40 5555 move.b D0, ($5555,A5)

;; quadruple the team ID to use it to offset into the team list
045D92: D040 add.w D0, D0
045D94: D040 add.w D0, D0

;; load the team list into A)
045D96: 41F9 0005 34DC lea $534dc.l, A0

;; offset into the losing team's section
045D9C: D1C0 adda.l D0, A0

;; move team leader to 10d552
045D9E: 1B50 5552 move.b (A0), ($5552,A5)

;; move team secondary to 10d553
045DA2: 1B68 0001 5553 move.b ($1,A0), ($5553,A5)

;; call continueScreenInit.asm
045DA8: 4EB9 002B D258 jsr $2bd258.l
045DAE: 4E75 rts

since continueScreenInit wipes out the team id changes, this isn't it.

## reading the team "leader"

a wp on 10d552 (team leader in continue) is hit at 4495e

;; move continue screen team leader to 100571
4495E: move.b ($5552, A5), ($72, A1)

a wp on 100571 hits at 45418

45418: move.b (&71,A1), D0

## A different approach, trace back from REG_SOUND write

1AD5 seems to be Athena's cry

> wp 320000,1,w,, { printf "s: %x at %x",wpdata,pc; g }
> Watchpoint 1 set
> go
> s: 63 at 2BCBD0
> s: 7F at 2BCBD0
> s: 63 at 2BCBD0
> s: 63 at 2BCBD0
> s: 63 at 2BCBD0
> s: 1A at 2BCBD0
> s: D5 at 2BCBD0
> s: 32 at 2BCBD0

2bcbb2 is the "play a sfx" routine patched by the hack to avoid sfx's during char select. All it's really doing is pushing bytes to REG_SOUND.

Before 2bcbb2 6536 is called

;; D0 = 0
006536: 7000 moveq #$0, D0

;; A0 = 10B8C4
006538: 41ED 38C4 lea ($38c4,A5), A0

;; D0 = \*10B8bd
00653C: 102D 38BD move.b ($38bd,A5), D0

does D0 == \*10b8bc?
006540: B02D 38BC cmp.b ($38bc,A5), D0

;; if so, exit
006544: 6716 beq $655c

;; \*10b8bd += 1
006546: 522D 38BD addq.b #1, ($38bd,A5)

;; D0 = \*(10b8c4 + D0)
00654A: 1030 0000 move.b (A0,D0.w), D0

;; if it's zero, jump up and try again?
00654E: 67EC beq $653c

;; if it's 1, exit
006550: 0C00 0001 cmpi.b #$1, D0
006554: 6706 beq $655c

;; otherwise, send the byte to REG_SOUND
006556: 4EB9 002B CBB2 jsr $2bcbb2.l
00655C: 4E75 rts

## Kim's sfx

it is 1c3c

It is in ROM at 51bfa

It is read from ROM at 6590

6590: move.w (A0,D0.w), ($38c0,A5)
