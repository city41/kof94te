import * as path from "path";
import * as fsp from "fs/promises";

type Match = {
  address: number;
  value: number;
};

function countBits(b: number): number {
  if (b > 0xff) {
    throw new Error("countBits: not given a byte");
  }

  let numBits = 0;

  for (let i = 0; i < 8; ++i) {
    if ((b & 1) === 1) {
      numBits += 1;
    }

    b = b >> 1;
  }

  return numBits;
}

//100100:  0000 25A8 0500 FFFF 0000 0000 0000 0000  ..%.............
function findBitMatches(line: string, numBits: number): Match[] {
  const baseAddressS = line.substring(0, 6);
  const baseAddress = parseInt(baseAddressS, 16);

  const rawWords = line.substring(9, 48);
  const bytes = rawWords.split(" ").flatMap((rw) => {
    const w = parseInt(rw, 16);
    const upperByte = w >> 8;
    const lowerByte = w & 0xff;

    return [upperByte, lowerByte];
  });

  const matches: Match[] = [];

  for (let i = 0; i < bytes.length; ++i) {
    const byte = bytes[i];

    if (countBits(byte) === numBits) {
      matches.push({
        address: baseAddress + i,
        value: byte,
      });
    }
  }

  return matches;
}

async function main(memTextPath: string, numBits: number) {
  if (isNaN(numBits)) {
    throw new Error("numBits is NaN");
  }

  const m = (await fsp.readFile(memTextPath)).toString();
  const lines = m.split("\n");

  for (const line of lines) {
    if (line.trim() === "") {
      continue;
    }

    const matches = findBitMatches(line, numBits);

    matches.forEach((match) => {
      console.log(`${match.address.toString(16)}: ${match.value.toString(16)}`);
    });
  }
}

const [_tsnode, _bitFinder, memTxtFile, numBitsS] = process.argv;

if (!memTxtFile || !numBitsS) {
  console.error("usage: ts-node bitFinder.ts <mem-txt-file> <num-bits>");
  process.exit(1);
}

main(path.resolve(memTxtFile), parseInt(numBitsS))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
