# Team Select Input

These bytes contain the current input, here is what happens on team select when a lua script forces them to zero

10b9c4: 0>4 -- denied = team selection runs as fast as possible
10b9cf: 0>4 -- denied = doesn't seem to get read
10b9d3: 0>4 -- denied = can't change teams
10ba00: 0>4 -- denied = makes no difference

10b9d3 seems to be the winner

soon after pressing A:

37fbe: jsr (A0)
375f8: jsr...

pressing A causes the game to go into 375f8 very soon after

# btst #$4

from pressing A -> 375f8, bit 4 is tested numerous times

3746a: btst #$4, D0
45e54: btst #$4, ($80c,A5)
673e: btst #$4, (-$7fff,A5)
c126fe: btst #$4, $d00038 (this is in the bios, and testing a ROM bit, not relevant)
