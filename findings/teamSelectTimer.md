# Team Select Timer

The game uses 108654.w as a timer in general. For example how to play uses it to keep each instruction on screen for an amount of time.

For Team Select, it is first seeded to 1501 at 36ffa

move.b #$15, $654(A5)
move.b #$1, $655(A5)

Team Select uses this timer at various points and for various things, it's not just a simple timer.
