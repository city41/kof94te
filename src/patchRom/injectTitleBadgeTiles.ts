import path from "node:path";
import { RomFileBuffer } from "./types";
import { createCromBytes } from "./createCromBytes";

const destTilesToOverwrite = [0x3fc4, 0x3fc5, 0x3fc6];

function mergeTile(
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

    // if the src pixel has color, choose it, otherwise go with
    // what was originally there
    if (srcC1[si] !== 0 || srcC2[si] !== 0) {
      destC1[di] = srcC1[si];
      destC2[di] = srcC2[si];
    }
  }
}

async function injectTitleBadgeTiles(cromBuffers: RomFileBuffer[]) {
  const badgeCromResult = await createCromBytes(
    path.resolve("./resources/title_badge.png"),
    path.resolve("./resources/title_badge.palette.png")
  );
  const badgeC1Buffer = badgeCromResult.oddCromBytes;
  const badgeC2Buffer = badgeCromResult.evenCromBytes;

  for (let i = 0; i < destTilesToOverwrite.length; ++i) {
    mergeTile(
      badgeC1Buffer,
      badgeC2Buffer,
      cromBuffers[0].data,
      cromBuffers[1].data,
      i,
      destTilesToOverwrite[i]
    );
  }

  return cromBuffers;
}

export { injectTitleBadgeTiles };
