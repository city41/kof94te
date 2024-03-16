# Plan

## Load the static bg

- leave how to play on the screen
- load the two layers into vram, both with sticky sprites, and height 0
  - emit binary data accounting for:
    - needed gaps in croms
    - both layers are sticky
    - height is first zero
    - second pass sets full height
- run through just about all sprites

  - set the two sticky sprites on screen with proper height -> bg appears
  - set all other sprites to height zero

- making changes only during vblank
  - idea 1: inject a routine just after vblank
    - if a FP is set, run that function
    - only set FP during char select
  - idea 2: the engine makes a jump to clear out sprites
    - inject a routine after the jump address has been set but before the jump
      - might not be possible
    - if in char select and jump is known, alter jump to skip all clean up
    - otherwise, do nothing
  - idea 3: don't do anything, it will all still likely work

## move cursors around

TBD

Character name font is on the fix layer

## Set chosen team portraits

Whenever a character is chosen, inject that character's portrait tiles into the background sprites
