# Team Select

When on the team select screen, the current cursor index is stored at 1081C0

Once the player selects a team, it overwrites the index value with a new value

move.b $135(a4), $c0(a4) where $c0(a4) is 1081c0.

Here are the bytes that get moved depending on team chosen

| team | index | value |
| ---- | ----- | ----- |
| Itl  | 0     | 0f    |
| Chn  | 1     | 03    |
| Jpn  | 2     | 06    |
| USA  | 3     | 09    |
| Kor  | 4     | 0c    |
| Brz  | 5     | 00    |
| Eng  | 6     | 15    |
| Mex  | 7     | 12    |

These values don't change depending on what team the CPU picks.

The lua script, `forceTeamItalToBeUSA.lua` successfully forces a selection of Team Italy to be USA once the game starts. The order select screen still shows Italy, but I am guessing they just reused the sprites and don't bother to update them as normally they would not change.

## Player Memory Blocks

From 108110 to 10830f is a memory block for player 1, and 108310 to 10850f is player 2's block. They are 512 bytes each.

These blocks contain a starting "tag" in ascii, that indicates what the block is currently being used for, where X is either '1' or '2' depending on the player

| tag      | use                                                   |
| -------- | ----------------------------------------------------- |
| PLAYERXI | set before a player has pressed start to start a game |
| PXSELECT | set after pressing start and during how to play       |
| PX TEAM  | set when the player is choosing their team            |
| PXMEMBER | set when the player is choosing the player order      |
| PLAYER X | set while the match is playing                        |

"PLAYER X" is set throughout the entire match and win screen. It goes back to "PX TEAM" when choosing the next team to fight.

### When picking character order

terryOrderDumps contain the p1 memory block with team italy chosen and Terry as the 1st, 2nd and 3rd character.

108232 through 108234 seem to be the order

terry1.txt
108230: 8105 0F10 11

terry2.txt
108230: 8105 100F 11

terry3.txt
108230: 8105 1011 0F

It seems to be

| value | character |
| ----- | --------- |
| 0F    | Terry     |
| 10    | Andy      |
| 11    | Joe       |

So far, `src/lua/forceTeamItalyOrder.lua` creates a team of two Heiderns and a Joe :O

When first coming into character order select, it writes from 1081c0 to 108232.

I think 1081c0 through 1081c2 is the currently selected team. For Italy it is `0f1011`, which should be Terry(0f)|Andy(10)|Joe(11)

### Character IDs

| value | character           |
| ----- | ------------------- |
| 00    | Heidern             |
| 01    | Ralf                |
| 02    | Clark               |
| 03    | Athena              |
| 04    | Kensou              |
| 05    | Chin                |
| 06    | Kyo                 |
| 07    | Benimaru            |
| 08    | Goro                |
| 09    | Heavy D             |
| 0a    | Lucky               |
| 0b    | Brian               |
| 0c    | Kim                 |
| 0d    | Chang               |
| 0e    | Choi                |
| 0f    | Terry               |
| 10    | Andy                |
| 11    | Joe                 |
| 12    | Ryo                 |
| 13    | Robert              |
| 14    | Takuma              |
| 15    | Yuri                |
| 16    | Mai                 |
| 17    | King                |
| 18    | Rugal               |
| 19    | O.Rugal             |
| 1a    | Invisible Rugal (?) |
