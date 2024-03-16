# Run Both

Have the game run team select, and on top of it run char select

turn off team select's timer with `teamSelectNeverEnds`, which also turns off pressing A to proceed

instead of having the game jump to 36e66 (team select init), jump to char select init. Have it init, then jump the game to 36e66 so team select also inits.

Might need to save/restore address registers

team select's init will move into running team select, which is at 37046. Before it rts, have it jump into char select main.

# 37046

right before it rts's it does a move.b which is three words

- replace the move with a jsr to a new routine
  - it does the move that got clobbered
  - it stores all address registers
  - it runs char select main
  - it restores all address registers
