#cutscene 3

Rugal's IMPOSSIBLE HOW COULD I LOSE A BATTLE part is its own scene that runs for all teams.

Here is team Mexico's cutscene 3 dialog

1572be: ROBERT
1572cc: .YOU.SEE
1572e0: .THIS.IS.KYOKU-
157300: .GENRYU.KARATE
157320: RUGAL
15732c: .TCH
157340: .KYOKUGENRYU
15735a: .KARATE
15736a: .SO
157372: .IT.DEPENDS.ON
157390: .THE.PRACTIONER
1573b2: .BUT
1573bc: .I.WON'T
1573ce: .LET.YOU.GET.OUT
1573f0: .OF.HERE.ALIVE
157410: RUGAL
15741c: .A.WATERY.GRAVE
15743c: .AWAITS.YOU
157456: .FAREWELL
15746c: RYO
157474: .WATCH.OUT
15748c: .LET'S.GET.OUT
1574aa: .OF.HERE

572be is accessed at 63c6
63C6: move.w (A1)+, D1
A1 is 572be

A1 loaded at 63ac
movea.l $c0(A4), A1

lot's of similaries to cutscene2, but the routine at 443ea is not called for these cutscenes

team Mexico is set for cutscene 3, the game doesn't seem to access the team list for this.

## Andy's Y

In cutscene 2 Andy's Y is 74, and that is read from 43d08, which is BB

In cutscene 3, his Y is 79.

So possibly a value of BB+5 BB-5 is read from ROM somewhere.

Sadly there is a ton of 00C0 and 00B6 words in the ROM.

## Andy's X

cutscene 2: 129
cutscene 3: 93

cutscene 2 reads X from 43d06, which is 93
