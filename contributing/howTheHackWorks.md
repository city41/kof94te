# How the Hack Works

The hack has two major parts to it:

- The character select screen
- Using the custom teams throughout the rest of the game

## The Character Select Screen

This part of the hack is truly a hack. I originally tried to build a screen that replaced the team select screen and worked with the game engine. That proved to be incredibly difficult. So instead, the char select screen runs on top of the team select screen, which is still running.

This is possible because I was able to claw away about 30 sprites from the game and about 60 palettes. That proved to be just barely enough to pull off a decent character select screen.

This approach does have some huge advantages though

- The "insert coin" and "press start" messages at the top of the screen just work as-is
- "here comes challenger" when someone presses start to go into versus mode just works as-is
- whenever the game thinks it's time to show the team select screen, the char select screen just shows up and works. For example, in attract mode
- The cpu randomization for picking which team the player will fight is done by the original game, the char select screen just visualizes it by moving its cursor around
- whatever memory values are needed by the game that char select doesn't realize are needed, team select will set
- the cpu team in single player mode is fully set up correctly
- the game handles moving to cutscenes, Rugal, etc as-is

In the end, I actually think running the char select screen on top of the team select screen might even be the right way to go.

So the character select screen can be further divided...

### Running the screen itself

`charSelectInitRoutine.asm` is ran once every time a team select is about to load. It does various things to initialize character select, and loads the new graphics into video ram.

`charSelectMainRoutine.asm` is ran every frame and runs the character select screen. It deals with the cursors, the choices the players make, etc. It delegates a lot of its work to `charSelectPlayerRoutine.asm` which is called once per player.

A common theme throughout the hack is always handling player 1 and player 2, no matter how many people are actually playing. Because the CPU players often act just like human players. In attract mode, there's no human players at all.

### Pushing team select and the sprite engine aside

Inside `newCharSelect.json` are a lot of small patches that deal with making enough room for character select to run. They do things like not allow team select to load any sprites, and guard the palettes character select is using. This has the double bonus of reducing how much of vblank team select uses, as we want to hog as much vblank time to ourselves that we can.

### Moving forward into order select

The patch also deals with moving past character select into order select once both players have decided on their teams. This involves not allowing team select to read any inputs, and setting the team select timer to zero once character select is done. This allows char select to end and order select to begin, just as if the player let the timer run out. I would prefer to do whatever team select normally does when a player presses A, but I've not been able to find it :-/

Make no doubt about it, this part of the hack is very, well, hacky. But it works, and honestly that's really all that matters.

## Using the Custom Teams Throughout the Rest of the Game

From there the hack interjects itself and has the game use the custom team instead of one of the preformed 8 teams. This varies depending on which part of the game we're talking about.

### Team Ids and Character Ids

The game stores a team id and 3 character ids per player. For example in vanilla KOF94 if you picked team Italy, in RAM would be `050f 1011`. `5` is the id for team Italy, `f` is the id for Terry, `10` for Andy and `11` for Joe (this is in hex btw). This is very simplified, but the point is the game keeps track of both your team (Italy, China, etc) _and_ the characters.

In the hack, it might be `0501 080e`, which is Italy (`05`): Ralf (`01`), Goro (`08`) and Choi (`0e`). You must set a team id, there is no way around it. If you just set it to zero, well that's team Brazil. This means the hack has to get involved and interject whenever the game would consult the team id instead of character ids, which is explained below.

### Gameplay

Thankfully the hack does not get involved in gameplay at all. Once you tell the game what 6 characters to use for a fight, the engine can take it from there. If the hack only cared about custom teams fighting, it would be a pretty simple hack.

Team ids don't really come into play here. But the team id does determine which background the fight is on. In single player mode, the CPU's team id is not messed with, so the backgrounds always match. In versus mode, the hack randomly assigns a single team id to both teams. This accomplishes random backgrounds in versus mode, which is nice. This happens before the match starts. Once it has started, the team ids and character ids are locked in.

### Win screens

For win screens, the game looks up the team id of the player who won, then from there gets the real team members for that team. This is a problem for the hack. Let's say you had `0501 080e` as outlined above. During gameplay you'd see Ralf, Goro and Choi. But the win screen would show the team Italy characters.

In ROM, there is a list of who is on which team starting at `534dc`

```
0534DC:  0001 02FF 0304 05FF 0607 08FF 090A 0BFF  ................
0534EC:  0C0D 0EFF 0F10 11FF 1213 14FF 1516 17FF  ................
0534FC:  1819 19FF
```

This list is just `<member1><member2><member3>FF`, so for example Italy is in here as `0F1011FF`. also the last team `181919FF` is Rugal's team.

The character Ids all ascend in order, so this list isn't strictly necessary. The game is mostly using it to figure out which position on a team a member is. For example Heidern is position 0, Ralf is position 1, and Clark at position 2. Or Terry at 0, Andy at 1, Joe at 2.

The hack has the game look for this list in RAM instead of in ROM. So the hack can then write to that place in RAM and build out a dynamic list of the characters the player actually chose.

#### Character positioning on the win screen

When the win screen pops up, the player that actually won the match is in the center, and the other two team members are to the sides. The game does this by first figuring out which position in the team the winning character is (0, 1 or 2). Then based on that, runs one of three routines that will set up where the characters should go on the screen. These routines all just consult tables stored in ROM of where each character should go depending on who won the match. So one table will place Terry in the center of the screen, another will place him to the left, and another to the right.

The hack deals with this in two steps:

- First it has its own tables it consults to figure out where characters should go. They are built with `src/tools/buildWinscreenTables.ts`. This script uses the tables already in the game to build out three new tables. Each table places characters at different positions. So the first table it builds places all characters in the center. The second one, all to the left, and the last has them all to the right. These tables can be seen at `src/patches/winscreenTables.asm`.
- Then depending on who won the match and the makeup of the custom team, a dynamic table is built in RAM that only has the three characters in it. The game is then told to look up the positions using this RAM table instead of its normal ROM table, and the end result is custom teams showing up on the win screen correctly

![win screen with a custom team](https://github.com/city41/kof94te/blob/main/contributing/winScreen.png?raw=true)

This all happens in `winScreenInit.asm`.

#### Character positioning on the continue screen

This is very similar to how win screens work. The hack will have the game look in RAM for a table that positions the characters properly on screen instead of the built in ROM table. The hack builds this RAM table on the fly in `continueScreenInit.asm`.

Unlike the win screens, no new tables of xy values are built. Instead the built in ROM table is read to get the character's y position, then a hardcoded x position is chosen based on the character going to the center (160px), left (90px) or right (230px).

#### Cut scenes

The second cut scene (just before fighting Rugal), shows the team. This showing of the team works almost exactly how win and continue screens work. This can be seen in `cutscene2Init.asm` and `buildCutscene2Tables.ts`.

Cut scenes are still very early and a lot more work on them needs to be done at the time of writing this.

#### Alternate Colors

Each character has two sets of palettes. These are so when there is a mirror match (both players are using the same character), each player's character is colored differently to tell them apart.

![regular versus alternate colors](https://github.com/city41/kof94te/blob/main/contributing/altColors.png?raw=true)

You can also purposely pick the alternate colors by choosing your team with C or D instead of A or B.

In the vanilla game, this is pretty simple. Each player has a flag that is either `0` for regular colors or `1` for alternate. This flag applies to all characters on the team. Whenever the game needs to know which set of palettes to load, it just reads that flag out of memory.

This is one of the most complex parts of the hack. For the hack, we need:

- To set regular or alternate colors per character, not per team
- Have the CPU team pick the opposite colors per character, not per team
- In versus mode be first come first serve per character, not per team

The hack's character select screen stores a word per character, each word is `[character id]|[palette flag]`, so it'd be `0F01` for Terry with alternate colors. Not sure this was a great idea and probably should be changed to be keep the character ids and palette flags separate.

Then whenever the game tries to load the team colors flag from memory, instead the hack runs a routine that figures out what that flag should be for the character taking into account all of the needs above.

So the vanilla game just does `move.b $TEAM_COLOR_FLAG, D1` and the hack runs a 222 line long routine :)

This routine is at `setupCharacterColors.asm`

This palette set choice needs to be made often:

- attract mode order select
- attract mode gameplay
- Terry and Ryo in the how to play screen
- in order select
- each round of the match
- the final blow that ends the match
  - the character falling in slow motion and the stage background still being present is handled separately and reloads palettes
- the falling character on the white background when a match ends
- the winning team on the win screen
- the losing team on the continue screen
- all cutscenes
- possibly more places

Also since the game just needs to do a simple `move.b` to load the palette flag, it does this in several places. I have swapped in the `setupCharacterColors` routine in most of those places, but probably not all.
