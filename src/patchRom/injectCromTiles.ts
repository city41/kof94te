import path from "node:path";
import fsp from "node:fs/promises";
import { getRom } from "./getRom";
import { calcDestIndex } from "../cromSpans";
import { RomFileBuffer } from "./types";

// todo: can this be calculated?
const NEW_TILES_FIRST_INDEX = 256;
const NEW_TILES_LAST_INDEX = 666;
const TOTAL_NEW_TILES = NEW_TILES_LAST_INDEX - NEW_TILES_FIRST_INDEX + 1;

// a crom tile is 128 bytes, but this is since it's split across two files
const CROM_TILE_SIZE_PER_ROM = 64;

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

  function replaceTile(srcIndex: number, destIndex: number, destPair: string) {
    const oddData = newTilesC1Buffer.slice(
      srcIndex * CROM_TILE_SIZE_PER_ROM,
      (srcIndex + 1) * CROM_TILE_SIZE_PER_ROM
    );
    const evenData = newTilesC2Buffer.slice(
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

    replaceTile(srcIndex, destIndex, destCromPair);
  }

  return Object.values(cromBuffers).flat(1);
}

export { injectCromTiles };
