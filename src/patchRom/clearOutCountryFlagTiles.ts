import { RomFileBuffer } from "./types";

// the first flag tile
const destTilesToClearStartingAddress = 0x1dca4;
// 8 flags, one for each team
const destTilesToClearCount = 8;

function clearTile(destC1: number[], destC2: number[], destIndex: number) {
  for (let i = 0; i < 64; ++i) {
    const di = destIndex * 64 + i;

    destC1[di] = 0;
    destC2[di] = 0;
  }
}

function clearOutCountryFlagTiles(cromBuffers: RomFileBuffer[]) {
  for (let i = 0; i < destTilesToClearCount; ++i) {
    const destIndex = (destTilesToClearStartingAddress + i) % 2 ** 15;

    clearTile(cromBuffers[6].data, cromBuffers[7].data, destIndex);
  }

  return cromBuffers;
}

export { clearOutCountryFlagTiles };
