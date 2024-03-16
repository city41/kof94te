// tiles in the croms that are empty or unused
// the hack needs about 550 tiles
// this nets 666 tiles
export const cromSpans = [
  // 255 is also blank, but it's supposed to be, can't use it
  // 0 is too, but often zero gets used, skipping to be safe
  { start: 1, end: 254, pair: "c1/c2" },
  { start: 320, end: 510, pair: "c1/c2" },
  { start: 32547, end: 32766, pair: "c7/c8" },
];

// Given a "logical index" that sromcrom will emit (it has no idea we are
// squeezing tiles into existing croms), this will return the actual crom
// index based on cromSpans above.
//
// both injectCromTiles uses this to inject the tiles into the correct spot,
// and sromCromPreEmit uses this so the assembly data has the matching indexes
export function calcDestIndex(logicalIndex: number): {
  destIndex: number;
  destCromPair: string;
} {
  const originalLogicalIndex = logicalIndex;

  for (let cs = 0; cs < cromSpans.length; ++cs) {
    const cromSpan = cromSpans[cs];
    const curSpanSize = cromSpan.end - cromSpan.start + 1;

    if (logicalIndex < curSpanSize) {
      return {
        destIndex: cromSpan.start + logicalIndex,
        destCromPair: cromSpan.pair,
      };
    } else {
      logicalIndex -= curSpanSize;
    }
  }

  throw new Error(`Failed to find a destIndex for: ${originalLogicalIndex}`);
}
