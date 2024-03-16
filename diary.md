# Diary

Keeping track of how I'm progressing and how I made kof94te. I will make a blog post for sure, and possibly a video

## Is there enough space?

- Finding usable spans of empty bytes in the prom with `zeroReports.ts`
- Examining the CROMs in the tile viewer to confirm there was enough to work with
- Running the game and looking at user ram, does it look like there are pockets that can be used?
- What I failed to do and should have: how many palettes does the game generally use? Enough left over?

## look for previous work

Didn't find much at all. But did find this

https://www.youtube.com/watch?v=Se4UGd3RdsY

It showed the game's engine is flexible enough to (easily) support editted teams.

## Finding the memory tags

Finding the tags was a massive breakthrough. Thank you SNK devs. I literally found them by just scrolling through RAM while the game was running and seeing if anything jumped out. And boy did it ever. You just never know.

## Using lua scripts to explore the memory

- forceTeamItalyToBeUSA.lua
- forceTeamItalyOrder.lua
- swapAndyAndJoe.lua
- forceTeamOfTriplets.lua

In general, just using Lua to pock at memory and learn what I can

## findings docs

Just dumping whatever I figure out into md docs. THey are haphazard and poorly organized, but I refer back to them often.

## Figuring out how the game goes from HTP to team select

- lua script to help ensure the cpu trace is as short as possible (traceHTPToTeam.lua)
- First from tag to tag, but trace was 30k lines long WITH loop hiding
  - over 100k without loop hiding!
- second trace, from press A to P1 TEAM
  - 6k lines long. Still very long, but better

## btst is your friend

- look for btst against `#$4` in trace
  - there was only three of them
  - this is typically "is A pressed?"
  - located where HTP transitions to team select when pressing A

this caused me to learn of the function pointers.

The game engine calls a function pointer in 108584 each frame and it is that function that is responsible for either dealing with the current game state (how to play, team select, gameplay, etc), or preparing a state (loading sprites, memory, etc)

HTP moves through each of its instructions using FPs

## dump out all the function pointers

`wp 108584,4,w,, { printf "584: %x at %x",wpdata,pc; g }`

Showed me all the function pointers the game is using and moving through.

## Jump into the FP flow

- start by just having HTP jump into a new FP, that was a black screen and infinite loop
  - realized player two could still coin up and press start, pointing out there is an entire game engine running
- gradually worked my way up to making my FP jump a new char select screen
- had the game jump to my new char select screen instead of the OG team select screen by swapping in my FP
  - last patch in `HTP_toNewCharSelect.json`

## Learning more on how the engine works

- got a working char select screen but it was super raw
- realized the best way to get it fully polished is to work with the game engine, not fight it
  - getting things for free like "HERE COMES CHALLENGER" support and seemlessly moving into member order screen
- understanding how the team flags in the team select screen work
  - they are defined in ROM with width/height, starting tile, palette, etc
  - there is a list of pointers to each entity, basically `struct FlagEntity*[8] { ... }`

## next up

learn how the list of entities makes its way into the engine

- how can I have the flags NOT become live entities?
- how can I create new avatar entities and load them onto the screen via the engine?

## gave up, just hacking now

- learning how the game works was working, but it was very slow going
- doing some exploring and experimenting, realized I can work around the game
- building out that hack

## writing the hack

- doing the entire char select screen in assembly
- came up with what the screen looks like in aseprite
- integrated the screen into the game working with what I had
  - only some sprites at the bottom and top of range
  - only about 500 crom tiles
  - etc
- thought up some tricks like using the bg sprites for current team, etc
- using sromcrom to generate tiles
  - wrote a scrip to inject them into available gaps
  - assembly for the data taking those gaps into account
