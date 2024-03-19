# Team Select Input

These bytes contain the current input, here is what happens on team select when a lua script forces them to zero

10b9c4: 0>4 -- denied = team selection runs as fast as possible
10b9cf: 0>4 -- denied = doesn't seem to get read
10b9d3: 0>4 -- denied = can't change teams
10ba00: 0>4 -- denied = makes no difference

10b9d3 seems to be the winner
