# Engine

## Input

Input is read at 32c8a and stored at 10b9c4, and then at 10b9c7. But it looks like nothing reads 10b9c7?

Seems stored at 10b9cf too, here if I press an input, it gets stored at 10b9cf 4 times then never again. it's kind of a "poor man's BIOS_P1CHANGE"

It is read during gameplay, but not during how to play

## Entities

the routine at 4860 seems to be a general "put sprites for an entity onto screen" routine. It is driven by A4, which loads into D0 and then coupled with what is A0, ultimately points to a list in ROM of entity addresses. Following one of those addresses seems to lead to the entity data, which includes tiles, palettes and probably a lot more
