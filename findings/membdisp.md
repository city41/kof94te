# MEMBDISP

NOTE: applying `teamSelectNeverEnds.json` patch is helpful.

This is the memory used to display characters during team and order select.

There are six of them, one for each character

102910: team 1, char 1
102B10: team 1, char 2
102D10: team 1, char 3
102f10: team 2, char 1
103110: team 2, char 2
103310: team 2, char 3

## decoding

Team Italy

| address | value    | description                                        |
| ------- | -------- | -------------------------------------------------- |
| 102928  | 000d19e8 | Pointer into ROM of first character's tiles        |
| 10292c  | 0070     | Same value for all teams, written once, never read |
| 102930  | 0001     | Same value for all teams, written once, never read |
| 10296a  | ffe0ff90 | Never changes, but was diff in dumps???            |
| 102970  | 000f     | The character, likely the only byte that matters   |

[1] Forcing other teams to get 000D using `membdispExplorer.lua`

| team   | result                                                       |
| ------ | ------------------------------------------------------------ |
| China  | Athena does not show                                         |
| Japan  | team select resets and is very glitched                      |
| USA    | rapid graphical glitches but team select seems to still work |
| Korea  | Kim is missing, Chang has weird palettes and tiles           |
| Brazil | Heidern is missing                                           |
| Eng    | Yuri is Missing                                              |
| Mexico | No noticable change                                          |

[2] Forcing other teams to get 19e8 using `membdispExplorer.lua`

| team   | result                                                            |
| ------ | ----------------------------------------------------------------- |
| China  | Athena does not show, A Ralf tile as at the top of Kensou         |
| Japan  | Kyo does not show                                                 |
| USA    | Heavy does not show                                               |
| Korea  | rapid graphical glitches but team select seems to still work      |
| Brazil | even worse graphical glitches but team select seems to still work |
| Eng    | Yuri is Missing                                                   |
| Mexico | Clark shows, using Ryo's palettes                                 |

[3] Forcing the entire long word to be 000d19e8 at 102928 using `membdispExplorer.lua`

| team   | result                                               |
| ------ | ---------------------------------------------------- |
| China  | Terry shows, using Athena's palettes and starting Y  |
| Japan  | Clark shows, using Kyo's palettes                    |
| USA    | Clark shows, using Heavy's palettes and starting Y   |
| Korea  | Terry shows, using Kim's palettes                    |
| Brazil | Clark shows, using Heidern's palettes and starting Y |
| Eng    | Clark shows, using Yuri's palette and starting Y     |
| Mexico | Clark shows, using Ryo's palette                     |

102928 looks like a double word pointer for the first character's tiles

| value | id  | character           |
| ----- | --- | ------------------- |
| 9eda0 | 00  | Heidern             |
| a080e | 01  | Ralf                |
| a3116 | 02  | Clark               |
| aab74 | 03  | Athena              |
| ab9d0 | 04  | Kensou              |
| ac6f8 | 05  | Chin                |
| b45be | 06  | Kyo                 |
| b52f6 | 07  | Benimaru            |
| b5f12 | 08  | Goro                |
| be588 | 09  | Heavy D             |
| bf3fa | 0a  | Lucky               |
| c01e4 | 0b  | Brian               |
| c8bd0 | 0c  | Kim                 |
| ca12e | 0d  | Chang               |
| ca1fc | 0e  | Choi                |
| d19e8 | 0f  | Terry               |
| d2588 | 10  | Andy                |
| d311e | 11  | Joe                 |
| db244 | 12  | Ryo                 |
| dbe48 | 13  | Robert              |
| dc958 | 14  | Takuma              |
| e4f8c | 15  | Yuri                |
| e6610 | 16  | Mai                 |
| e67ac | 17  | King                |
| ecd48 | 18  | Rugal               |
|       | 19  | O.Rugal             |
|       | 1a  | Invisible Rugal (?) |
