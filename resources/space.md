# Space

## P ROM

There is about 160kb from 969c8 to c0001. I've used clobberZeroSpan.ts and the game works just fine. That should be plenty of room.

## C ROM

character_grid: 18x6 = 108
total: 538

Actually the total is 411 as there are a lot of duplicate tiles.

## S ROM

The S ROM is pretty much completely full. But I doubt we'll need anything added to it. Should be ok.

## V ROM

I doubt we will need any additional sound effects/music. Can just use the existing ones from the existing char select screen.

# Available Sprites

- character grid: 18
- p1 chosen team: 6
- p2 chosen team: 6
- p1 cursor: 3 + 3 (due to alternating)
- p2 cursor: 3 + 3 (due to alternating)
- cpu cursor: 4 + 4 additional

total: 50

grid: 14b - 331 - 348
p1black: 15d - 349 - 351
p1white: 160 - 352 - 354
p2cpublack: 163 - 355 - 361
p2cpuwhite: 16a - 362 - 368
p1chosen: 171 - 369 - 374
p2chosen: 178 - 376 - 379
