// kof94's crom pairs are 4 megabytes
const TILES_PER_PAIR = 32768;
// tiles in the croms that are empty or unused
// the hack needs about 110 tiles
// this nets 220 tiles
export const cromSpans = [
  {
    globalOffset: TILES_PER_PAIR * 3,
    start: 32547,
    end: 32766,
    pair: "c7/c8",
  },
];

// Given a "logical index" that sromcrom will emit (it has no idea we are
// squeezing tiles into existing croms), this will return the actual crom
// index based on cromSpans above.
//
// both injectCromTiles uses this to inject the tiles into the correct spot,
// and sromCromPreEmit uses this so the assembly data has the matching indexes
export function calcDestIndex(
  logicalIndex: number,
  includeGlobalOffset: boolean
): {
  destIndex: number;
  destCromPair: string;
} {
  const originalLogicalIndex = logicalIndex;

  for (let cs = 0; cs < cromSpans.length; ++cs) {
    const cromSpan = cromSpans[cs];
    const curSpanSize = cromSpan.end - cromSpan.start + 1;

    if (logicalIndex < curSpanSize) {
      const offset = includeGlobalOffset ? cromSpan.globalOffset : 0;
      return {
        destIndex: cromSpan.start + logicalIndex + offset,
        destCromPair: cromSpan.pair,
      };
    } else {
      logicalIndex -= curSpanSize;
    }
  }

  throw new Error(`Failed to find a destIndex for: ${originalLogicalIndex}`);
}
