# Alternate Endings

The hack contains 4 alternate endings: Team USA, Japan, England and Mexico. If you beat the game with a custom team, you will get one of these endings. There are 4 to ensure you get an ending for a team that none of your characters are on. This is because they are "negative" endings. They show a losing team and generally they are talking about the winners. This enables the hack to offer an ending experience to custom teams in a realistic way. Doing a real new ending would be more work than I prefer to do.

## English and Spanish

These endings are stored in resources at `<Team>Ending_part<x>_<lang>.txt`, such as `EnglandEnding_part1_en.txt`. They are converted to assembly with `src/tools/convertToCromText.ts`. This is done for the entire hack using `scripts/generateAllEndingText.sh`, which just calls `convertToCromText.ts` repeatedly.

### To change the text

1. Update the corresponding txt file in resources.
2. Run `scripts/generateAllEndingText.sh`
3. Build the hack as normal from there.

## Japanese

Japanese is different due to needing new crom tiles. The game only has a very small subset of Japanese tiles available.

It also stores the endings in resources in the same txt files, but with a `_ja.txt` ending. These files are unicode and so can store Japanese characters directly in them.

To generate the Japanese endings, run `src/tools/convertToJapaneseCromText.ts`. Despite appearing like a general tool on the surface, the only thing it can do is convert the Japanese endings into assembly. It will also create new CROM tiles and place them at `resources/japanese-tiles.c1` and `resources/japanese-tiles.c2`.

The main hack script, `src/patchRom/main.ts`, will pull these new tiles out and inject them into the game.

### To change the text

1. Update the corresponding txt file in resources.
2. Run `yarn ts-node src/tools/convertToJapaneseCromText.ts`
3. Build the hack as normal from there.
