/**
 * findCutsceneTable.ts
 *
 * Attempts to find the x/y sprite table(s) for the second cutscene
 */

import * as path from "path";
import * as fsp from "fs/promises";

function flipBytes(data: number[]): number[] {
  for (let i = 0; i < data.length; i += 2) {
    const byte = data[i];
    data[i] = data[i + 1];
    data[i + 1] = byte;
  }

  return data;
}

function findWordDiffs(view: DataView, diff: number, gap: number): number[] {
  const diffs: number[] = [];
  for (let i = 0; i < view.byteLength - 8; i += 2) {
    const w1 = view.getUint16(i);
    const w2 = view.getUint16(i + (gap + 1) * 2);

    if (w1 - w2 === diff) {
      diffs.push(i);
    }
  }

  return diffs;
}

function dumpConsecutiveAddresses(a: number[], b: number[]) {
  a.forEach((av) => {
    b.forEach((bv) => {
      console.log(bv - av);
      if (bv - av === 2) {
        console.log("potential at", av.toString(16));
      }
    });
  });
}

async function main(pRomPath: string): Promise<void> {
  const buffer = await fsp.readFile(pRomPath);
  const data = flipBytes(Array.from(buffer));
  const view = new DataView(new Uint8Array(data).buffer);

  // look for diffs with no space between the words
  // this is assuming there is a table of just x's
  const terryAndyDiffs = findWordDiffs(view, 155 - 114, 0);
  const andyJoeDiffs = findWordDiffs(view, 114 - 86, 0);

  dumpConsecutiveAddresses(terryAndyDiffs, andyJoeDiffs);

  // look for diffs with one word between the words
  // this is assuming there is a table of x/y pairs
  //   findWordDiffs(view, 114 - 155, 1);
}

const [_tsnode, _findCutsceneTable, pRomPath] = process.argv;

if (!pRomPath) {
  console.error("usage: ts-node findCutsceneTable.ts <prom-path>");
  process.exit(1);
}

main(path.resolve(pRomPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
