import path from "node:path";
import { getRom } from "./getRom";
import { RomFileBuffer } from "./types";
import { SROM_FILE_NAME } from "./dirs";

const tilesToClear = [
  {
    // top half of TEAM SELECT
    start: 928,
    end: 937,
  },
  {
    // bottom half of TEAM SELECT
    start: 944,
    end: 953,
  },
  {
    // first span of country abbreviations
    start: 971,
    end: 975,
  },
  {
    // second span of country abbreviations
    start: 987,
    end: 1002,
  },
  {
    // third span of country abbreviations
    start: 1008,
    end: 1018,
  },
  {
    // first span of country names
    start: 1168,
    end: 1261,
  },
  {
    // second span of country names
    start: 1424,
    end: 1453,
  },
  {
    // third span of country names
    start: 1467,
    end: 1471,
  },
  {
    // fourth span of country names
    start: 1483,
    end: 1519,
  },
  {
    // fifth span of country names
    start: 1683,
    end: 1751,
  },
  {
    // sixth span of country names
    start: 1762,
    end: 1767,
  },
];

const FIX_TILE_SIZE = 32;
const BLANK_TILE = new Array(FIX_TILE_SIZE).fill(0);

async function clearFixTiles(): Promise<RomFileBuffer> {
  console.log("clearing fix tiles...");

  const fixBuffer = await getRom(path.resolve("./kof94.zip"), SROM_FILE_NAME);

  for (const ttc of tilesToClear) {
    for (let i = ttc.start; i <= ttc.end; ++i) {
      fixBuffer.data.splice(i * FIX_TILE_SIZE, FIX_TILE_SIZE, ...BLANK_TILE);
    }
  }

  return fixBuffer;
}

export { clearFixTiles };
