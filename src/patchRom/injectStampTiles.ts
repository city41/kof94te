import path from "node:path";
import { RomFileBuffer } from "./types";
import { createCromBytes } from "./createCromBytes";

const tileSpecs = [
  {
    sourceIndex: 0,
    destIndex: 0x6b3f,
    pair: "c7/c8",
  },
  {
    sourceIndex: 1,
    destIndex: 0x6afa,
    pair: "c7/c8",
  },
  {
    sourceIndex: 2,
    destIndex: 0x6b01,
    pair: "c7/c8",
  },
  {
    sourceIndex: 3,
    destIndex: 0x6b20,
    pair: "c7/c8",
  },
];

function replaceTile(
  srcC1: number[],
  srcC2: number[],
  destC1: number[],
  destC2: number[],
  srcIndex: number,
  destIndex: number
) {
  for (let i = 0; i < 64; ++i) {
    const si = srcIndex * 64 + i;
    const di = destIndex * 64 + i;

    destC1[di] = srcC1[si];
    destC2[di] = srcC2[si];
  }
}

async function injectStampTiles(cromBuffers: RomFileBuffer[]) {
  const stampCromResult = await createCromBytes(
    path.resolve("./resources/stamp.png"),
    path.resolve("./resources/stamp.palette.png")
  );
  const stampC1Buffer = stampCromResult.oddCromBytes;
  const stampC2Buffer = stampCromResult.evenCromBytes;

  for (const tileSpec of tileSpecs) {
    replaceTile(
      stampC1Buffer,
      stampC2Buffer,
      cromBuffers[6].data,
      cromBuffers[7].data,
      tileSpec.sourceIndex,
      tileSpec.destIndex
    );
  }

  return cromBuffers;
}

export { injectStampTiles };
