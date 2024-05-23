// kof94's crom pairs are 4 megabytes
const TILES_PER_PAIR = 32768;

// 1.1.9 uses 387 tiles

// tiles in the croms that are empty or unused
export const cromSpans = [
  {
    // 348 tiles
    globalOffset: TILES_PER_PAIR * 0,
    start: 2728,
    end: 3071,
    pair: "c1/c2",
  },
  {
    // 219
    globalOffset: TILES_PER_PAIR * 3,
    start: 32547,
    end: 32766,
    pair: "c7/c8",
  },
  {
    // 115 tiles
    globalOffset: TILES_PER_PAIR * 0,
    start: 9973,
    end: 10087,
    pair: "c1/c2",
  },
  {
    // 48 tiles
    globalOffset: TILES_PER_PAIR * 0,
    start: 11728,
    end: 11775,
    pair: "c1/c2",
  },
  {
    // 257 tiles
    globalOffset: TILES_PER_PAIR * 0,
    start: 11880,
    end: 12031,
    pair: "c1/c2",
  },
  {
    // 403 tiles
    globalOffset: TILES_PER_PAIR * 0,
    start: 13419,
    end: 13821,
    pair: "c1/c2",
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
