import fs from "node:fs";
import { cromChars } from "./cromChars";

const cutsceneData = require("../../cutsceneRomReads.json");

function resolveValue(value: number, mask: number): string {
  const maskedValue = value & mask;

  if (mask === 0xff00) {
    return (maskedValue >> 8).toString(16);
  }

  return maskedValue.toString(16);
}

const withLetters = {
  ...cutsceneData,
  reads: cutsceneData.reads.map((r: any) => {
    const value = parseInt(r.value, 16);
    const mask = parseInt(r.mask, 16);
    const letter = cromChars[value];

    delete r.mask;

    if (letter) {
      return {
        ...r,
        value: resolveValue(value, mask),
        letter,
      };
    } else {
      return {
        ...r,
        value: resolveValue(value, mask),
      };
    }
  }),
};

const withoutLetters = withLetters.reads.filter(
  (r: any) => r.letter === undefined
);

console.log("with letters", withLetters.reads.length);
console.log("without letters", withoutLetters.length);

fs.writeFileSync(
  "./exploreCutsceneData/cutsceneRomRead.letters.json",
  JSON.stringify(withLetters, null, 2)
);

const valueMap = cutsceneData.reads.reduce((accum: any, r: any) => {
  accum[r.value] = accum[r.value] || [];
  accum[r.value].push(r);

  return accum;
}, {});

const valueMapEntries = Object.entries(valueMap);

for (const e of valueMapEntries) {
  if ((e[1] as any).length === 2) {
    const a = parseInt((e[1] as any)[0].address, 16);
    const b = parseInt((e[1] as any)[1].address, 16);
    const d = Math.abs(a - b);

    if (d < 10) {
      console.log("two values", JSON.stringify(e));
    }
  }
}
