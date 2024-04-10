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

## Displaying the winners

The three routines, 3fd76, 3fdb0, 3fdea all are very similar. They move several things into memory, but most notably they move the current team into 10d065-7. All three do this. They move other things too, but that sticks out.

## The double words at the end

At the end of these functions they each move a differet double word to 10d06a

3fd76 -> 626ee Terry needs to win to hit this, order: Andy/Terry/Joe

- 10d062: 1112 130f 1011

3fdb0 -> 62756 Andy needs to win, order: Terry/Andy/Joe

- 10d062: 1112 130f 1011

3fdea -> 627be Joe needs to win, order: Andy/Joe/Terry

- 10d062: 1312 1111 100f

THese are rom addresses for three x/y position tables. Each character gets two words, one for x and one for y. There are 26 xy pairs, so for the 24 characters plus the two rugals?

(Terry is the winner)
having 3fd76 set 62756: from Andy/Terry/Joe to Terry/Andy/Joe
having 3fd76 set 627be: from Andy/Terry/Joe to Andy/Joe/Terry

## positioning routine

The routine at 3fba4 is used to position the portraits, using one of the rom addresses that one of the three init routines set.

## Plan

If character is a leader

- table 626ee -> center
- 62756 -> left
- 627be -> right

If character is second

- table 62756 -> center
- 626ee -> left
- 627be -> right

## Determining who the winning team was

When the win screen runs, it needs to know who won the match. How does it do that?

03FD0A moveq #$0, D0 7000
; load team 1 id into D0
03FD0C move.b ($231,A5), D0 102D 0231
; load team 1's base address into A0 (108100)
03FD10 lea ($100,A5), A0 41ED 0100
; is 108238 -$80?
03FD14 cmpi.b #-$80, ($238,A5) 0C2D 0080 0238
; if it is, skip ahead
03FD1A bne $3fd26 6600 000A
; load team 2 id into D0
03FD1E move.b ($431,A5), D0 102D 0431
; load team 2's base address into A0 (108300)

it looks like if 108238 is $80, then p1 lost
and if 108438 is $80, then p2 lost

## x/y location of portraits

| character | word | where ends up |
| --------- | ---- | ------------- |
| Terry     | 0038 | center        |
| Athena    | ffd7 | center        |
| Kyo       | ff87 | center        |
