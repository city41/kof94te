/**
 * dumpCutsceneText.ts
 *
 * The custscene "font" are sprite tiles from $4983-49a6 for englist letters.
 * Japanese letters are in their too but unsure about those.
 *
 * This script finds spans of using these IDs and dumps out the corresponding letters,
 * allowing one to see all the custscene text in the gamed and where it's located
 * on the ROM.
 */

import * as path from "path";
import * as fsp from "fs/promises";
import { cromChars } from "./cromChars";

function flipBytes(data: number[]): number[] {
  for (let i = 0; i < data.length; i += 2) {
    const byte = data[i];
    data[i] = data[i + 1];
    data[i + 1] = byte;
  }

  return data;
}

async function main(pRomPath: string): Promise<void> {
  const buffer = await fsp.readFile(pRomPath);
  const data = flipBytes(Array.from(buffer));

  let collected = [];

  for (let i = 0x155956; i < 0x165500; i += 2) {
    const word = (data[i] << 8) | data[i + 1];
    const cchar = cromChars[word] ?? "u";

    if (cchar.toUpperCase() === cchar && cchar !== "\n") {
      collected.push(cchar);
    } else {
      if (collected.length > 0) {
        const address = i - collected.length * 2;
        console.log(`${address.toString(16)}: ${collected.join("")}`);
        collected = [];
      }

      console.log(`${i.toString(16)}: ${cchar === "\n" ? "<nl>" : cchar}`);
    }
  }
}

const [_tsnode, _dumpCutsceneText, pRomPath] = process.argv;

if (!pRomPath) {
  console.error("usage: ts-node dumpCutsceneText.ts <prom-path>");
  process.exit(1);
}

main(path.resolve(pRomPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
