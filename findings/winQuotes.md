# Win Quotes

The win quote is decided by

- the winning character's id
- the losing team's id

So for example, Terry will say the same thing to team Mexico, regardless of who on team Mexico lost. It's "LET'S DO IT AGAIN SOMETIME!" at 5ecd0

# From win screen init to loading the quote: Terry wins, Mexico loses

this needs to be done on a vanilla rom as the hack changes the team ids in unpredictable ways

win screen init is at 3fd40
then a wp on 5ecd0

### mame command

bp 3fd40,, { trace traces/winQuote_terry_to_mexico.txt,,, { tracelog "D0=%x D1=%x D2=%x D3=%x D4=%x D5=%x D6=%x D7=%x A0=%x A1=%x A2=%x A3=%x A4=%x A5=%x A6=%x PC=%x -- ",d0,d1,d2,d3,d4,d5,d6,d7,a0,a1,a2,a3,a4,a5,a6,pc }}

wp 5ecd0,1,r,, { trace off }

sed -i '1,619879d' traces/winQuote_terry_to_mexico.txt

# From win screen init to loading the quote: Andy wins, Mexico loses

15ee88: WE MANAGED TO
15eea2: <nl>
15eea4: WIN THIS TIME!

win screen init is at 3fd40
then a wp on 5ee88

### mame command

bp 3fd40,, { trace traces/winQuote_andy_to_mexico.txt,,, { tracelog "D0=%x D1=%x D2=%x D3=%x D4=%x D5=%x D6=%x D7=%x A0=%x A1=%x A2=%x A3=%x A4=%x A5=%x A6=%x PC=%x -- ",d0,d1,d2,d3,d4,d5,d6,d7,a0,a1,a2,a3,a4,a5,a6,pc }}

wp 5ee88,1,r,, { trace off }

sed -i '1,619879d' traces/winQuote_andy_to_mexico.txt

## loading losing team's id

happens at subroutine 3f2bc

```asm
03F2BC: 7200           moveq   #$0, D1
03F2BE: 122D 0231      move.b  ($231,A5), D1      ; load player 1's team id
03F2C2: 0C2D 0080 0238 cmpi.b  #-$80, ($238,A5)   ; did player one lose?
03F2C8: 6700 0006      beq     $3f2d0             ; jump if they did
03F2CC: 122D 0431      move.b  ($431,A5), D1      ; load player 2's team id
03F2D0: D241           add.w   D1, D1             ; double the id for indexing
03F2D2: 7000           moveq   #$0, D0            ; use it from here to help get the win quote...
03F2D4: 102D 5065      move.b  ($5065,A5), D0
03F2D8: E948           lsl.w   #4, D0
03F2DA: D041           add.w   D1, D0
03F2DC: 3030 0000      move.w  (A0,D0.w), D0
03F2E0: 4E75           rts
```

pretty sure can just hook in here and load the losing team id based on the losing character
