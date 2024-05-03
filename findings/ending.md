# Ending

108584 (the function pointer address) gets these values when the ending starts

584: 3EF52
584: 01558
584: 3EF98
584: 342D8
584: 3BF62
584: 3BFDA
584: 3C0AC
584: 3E622

Forcing team select to jump to these with wildJumps.json

3EF52 - address error
01558 - how to play???
3EF98 - address error
342D8 - address error
3BF62 - rugal defeated cutscene, clean
3BFDA - lots of graphic corruption, some graphics from the rugal defeated cutscene, and HTP
3C0AC - seems to write something on screen then HTP
3E622 - locks up

## 3bf62

This plays the third cutscene quite cleanly except the character palettes are very messed up. So far the winning team is USA.
Other than the palettes it plays the ending, credits and final screen just fine, then starts the game over.

From there it does

584: 3BF62
584: 3BFDA
584: 3C0AC
584: 3E622
584: 3E636
584: 3BFB4
584: 3C174
584: 3E622
...
584: 3E636
584: 3BFB4
584: 443FC
584: 444C4

I think 3e622 is a routine for putting dialog on screen. 3c174 might be where the team is shown

3c174 - start of thank you
443fc - end of thank you
