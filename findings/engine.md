# Engine

## Input

Input is read at 32c8a and stored at 10b9c4, and then at 10b9c7. But it looks like nothing reads 10b9c7?

Seems stored at 10b9cf too, here if I press an input, it gets stored at 10b9cf 4 times then never again. it's kind of a "poor man's BIOS_P1CHANGE"

It is read during gameplay, but not during how to play
