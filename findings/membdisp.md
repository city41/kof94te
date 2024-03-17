# MEMBDISP

NOTE: applying `teamSelectNeverEnds.json` patch is helpful.

This seems to be the memory that is used to decide which characters are rendered in team select (order select too?)

P1's is at 102910, and P2 at 102b10. half a kb in size, just like the P1MEMBER section

## decoding

Team Italy

| address | value    | description                                        |
| ------- | -------- | -------------------------------------------------- |
| 102928  | 000d19e8 | Pointer into ROM of first character's tiles        |
| 10292c  | 0070     | Same value for all teams, written once, never read |
| 102930  | 0001     | Same value for all teams, written once, never read |
| 10296a  | ffe0ff90 | Never changes, but was diff in dumps???            |
| 102970  | 000f     | The first character!!!!                            |

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

| value    | character |
| -------- | --------- |
| 000d19e8 | Terry     |
| 000aab74 | Athena    |
| 000b45be | Kyo       |
| 000be588 | Heavy     |
| 000c8bd0 | Kim       |
| 0009eda0 | Heidern   |
| 000e4f8c | Yuri      |
| 000db244 | Ryo       |
