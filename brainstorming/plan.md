# Plan

## Space

### Find out how much room there is in the P ROM

A quick scan of the PROM finds numerous sections of zeros. These are likely unused sections of the ROM.

How much space is there really?

Are these sections really unused? Try, one at a time, filling them with junk bytes and see if the game crashes

### Find out how much free RAM there is

???

### Find out how much free space there is in the C ROMs

there is a little bit of space at the end of C7/C8, but not much

some space in C1/C2 from 0x346b to 0x35ff

Can we just add on an additional pair? (I doubt it)

Can we switch the C ROMs to be bigger? from 2m to 8m each? (I doubt it)

We could just take like team USA's ending tiles or something like that

### The Fix ROM

looks to be completely full. Doubt there is much leeway there, but also doubt it will be needed much. If something is needed on the fix layer, can likely re-use what is already there.

## Logic

### How does the game store which team was chosen

Does the game store a pointer to an entire team, or three pointers, one to each character?

If individual character pointers, great, that is much simpler.

If, team pointers, that is more complex.

## Spikes

- Force a certain team to be chosen no matter what
- Swap two characters. Put Heidern on Team Italy and Terry on Team Brazil for example
- instead of the game going to character select, just jump to a hello world screen
