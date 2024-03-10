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
| USA  | 3     | 06    |
| Kor  | 4     | 0c    |
| Brz  | 5     | 00    |
| Eng  | 6     | 15    |
| Mex  | 7     | 12    |

These values don't change depending on what team the CPU picks.

The lua script, `forceTeamItalToBeUSA.lua` successfully forces a selection of Team Italy to be USA once the game starts. The order select screen still shows Italy, but I am guessing they just reused the sprites and don't bother to update them as normally they would not change.
