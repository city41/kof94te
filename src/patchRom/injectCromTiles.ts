import path from "node:path";
import fsp from "node:fs/promises";
import { getRom } from "./getRom";
import { calcDestIndex, japaneseEndingsCromSpans } from "../cromSpans";
import { RomFileBuffer } from "./types";

// todo: can this be calculated?
const NEW_TILES_FIRST_INDEX = 256;
// these are dynamically calculated below depending on if we are building a94 or a95
let NEW_TILES_LAST_INDEX = 0;
let TOTAL_NEW_TILES = 0;

// a crom tile is 128 bytes, but this is since it's split across two files
const CROM_TILE_SIZE_PER_ROM = 64;

function isEmptyTile(crom: number[], i: number): boolean {
  const bytes = crom.slice(
    i * CROM_TILE_SIZE_PER_ROM,
    (i + 1) * CROM_TILE_SIZE_PER_ROM
  );

  return bytes.every((b) => b === 0);
}

function getLastIndex(crom: number[]): number {
  let i = NEW_TILES_FIRST_INDEX;

  for (;;) {
    if (isEmptyTile(crom, i)) {
      break;
    } else {
      i += 1;
    }
  }

  return i;
}

async function injectCromTiles(): Promise<RomFileBuffer[]> {
  console.log("injecting crom tiles...");

  const cromBuffers: Record<string, RomFileBuffer[]> = {
    "c1/c2": [
      await getRom(path.resolve("./kof94.zip"), "055-c1.c1"),
      await getRom(path.resolve("./kof94.zip"), "055-c2.c2"),
    ],
    "c3/c4": [
      await getRom(path.resolve("./kof94.zip"), "055-c3.c3"),
      await getRom(path.resolve("./kof94.zip"), "055-c4.c4"),
    ],
    "c5/c6": [
      await getRom(path.resolve("./kof94.zip"), "055-c5.c5"),
      await getRom(path.resolve("./kof94.zip"), "055-c6.c6"),
    ],
    "c7/c8": [
      await getRom(path.resolve("./kof94.zip"), "055-c7.c7"),
      await getRom(path.resolve("./kof94.zip"), "055-c8.c8"),
    ],
  };

  const newTilesC1Buffer = Array.from(
    await fsp.readFile(
      path.resolve(__dirname, "../../resources/newtiles-c1.c1")
    )
  );
  const newTilesC2Buffer = Array.from(
    await fsp.readFile(
      path.resolve(__dirname, "../../resources/newtiles-c2.c2")
    )
  );
  const japaneseEndingTilesC1Buffer = Array.from(
    await fsp.readFile(
      path.resolve(__dirname, "../../resources/japanese-tiles.c1")
    )
  );
  const japaneseEndingTilesC2Buffer = Array.from(
    await fsp.readFile(
      path.resolve(__dirname, "../../resources/japanese-tiles.c2")
    )
  );

  NEW_TILES_LAST_INDEX = getLastIndex(newTilesC1Buffer);
  TOTAL_NEW_TILES = NEW_TILES_LAST_INDEX - NEW_TILES_FIRST_INDEX + 1;

  function replaceTile(
    srcIndex: number,
    destIndex: number,
    destPair: string,
    srcC1Buffer: number[],
    srcC2Buffer: number[]
  ) {
    const oddData = srcC1Buffer.slice(
      srcIndex * CROM_TILE_SIZE_PER_ROM,
      (srcIndex + 1) * CROM_TILE_SIZE_PER_ROM
    );
    const evenData = srcC2Buffer.slice(
      srcIndex * CROM_TILE_SIZE_PER_ROM,
      (srcIndex + 1) * CROM_TILE_SIZE_PER_ROM
    );

    const destPairBuffers = cromBuffers[destPair];

    destPairBuffers[0].data.splice(
      destIndex * CROM_TILE_SIZE_PER_ROM,
      CROM_TILE_SIZE_PER_ROM,
      ...oddData
    );
    destPairBuffers[1].data.splice(
      destIndex * CROM_TILE_SIZE_PER_ROM,
      CROM_TILE_SIZE_PER_ROM,
      ...evenData
    );
  }

  for (let i = 0; i < TOTAL_NEW_TILES; ++i) {
    const srcIndex = i + NEW_TILES_FIRST_INDEX;
    const { destIndex, destCromPair } = calcDestIndex(i, false);

    replaceTile(
      srcIndex,
      destIndex,
      destCromPair,
      newTilesC1Buffer,
      newTilesC2Buffer
    );
  }

  const totalJATiles =
    japaneseEndingTilesC1Buffer.length / CROM_TILE_SIZE_PER_ROM;

  for (let i = 0; i < totalJATiles; ++i) {
    const { destIndex, destCromPair } = calcDestIndex(
      i,
      false,
      japaneseEndingsCromSpans
    );

    replaceTile(
      i,
      destIndex,
      destCromPair,
      japaneseEndingTilesC1Buffer,
      japaneseEndingTilesC2Buffer
    );
  }

  return Object.values(cromBuffers).flat(1);
}

export { injectCromTiles };
