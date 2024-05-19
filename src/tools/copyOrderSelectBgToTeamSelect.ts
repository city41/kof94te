/**
 * copyOrderSelectBgToTeamSelect.ts
 *
 * Team select and order select have the same backgrounds, except team select also
 * includes the frame for the flags. This script copies order selects tilemap
 * on top of team select's tilemap, so the game doesn't render the flag frame anymore.
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

function getTileWord(x: number, y: number, tilemap: number[]) {
  const longIndex = x * 16 + y;
  const byteIndex = longIndex * 4;

  return (tilemap[byteIndex] << 8) | tilemap[byteIndex + 1];
}

function getPaletteWord(x: number, y: number, tilemap: number[]) {
  const longIndex = x * 16 + y;
  const byteIndex = longIndex * 4 + 2;

  return (tilemap[byteIndex] << 8) | tilemap[byteIndex + 1];
}

async function writeTilemapToAsm(
  orderSelectTilemap: number[],
  htpTilemap: number[]
): Promise<void> {
  const tilemapDcs: string[] = [];

  for (let x = 0; x < 20; ++x) {
    for (let y = 0; y < 16; ++y) {
      const tileWord =
        y < 12
          ? getTileWord(x, y, htpTilemap)
          : getTileWord(x, y, orderSelectTilemap);
      const paletteWord = getPaletteWord(0, 0, htpTilemap);

      const longVal = (tileWord << 16) | paletteWord;
      tilemapDcs.push(`dc.l $${longVal.toString(16)}`);
    }
  }

  const asm = `;;; replace the team select bg with the order select bg tiles
;;; this gets rid of the "flag frame" on team select
${tilemapDcs.join("\n")}
`;

  return fsp.writeFile(
    path.resolve("src/patches/orderSelectBgForTeamSelect.asm"),
    asm
  );
}

// this is the physical address inside a resting ROM file
// when mapped into the 68k memory space, add 0x200000
const htpBgTilemapStartingAddress = 0xc9800;
const orderSelectBgTilemapStartingAddress = 0xc8c00;
// 20 bg sprites, each with 64 bytes worth of tile data
const TILEMAP_SIZE = 20 * 64;

async function main(pRomPath: string): Promise<void> {
  const buffer = await fsp.readFile(pRomPath);
  const data = flipBytes(Array.from(buffer));

  const htpBgTilemap: number[] = data.slice(
    htpBgTilemapStartingAddress,
    htpBgTilemapStartingAddress + TILEMAP_SIZE
  );

  const orderSelectBgTilemap: number[] = data.slice(
    orderSelectBgTilemapStartingAddress,
    orderSelectBgTilemapStartingAddress + TILEMAP_SIZE
  );

  return writeTilemapToAsm(orderSelectBgTilemap, htpBgTilemap);
}

const [_tsnode, _copyOrderSelectBgToTeamSelect, pRomPath] = process.argv;

if (!pRomPath) {
  console.error("usage: ts-node copyOrderSelectBgToTeamSelect.ts <prom-path>");
  process.exit(1);
}

main(path.resolve(pRomPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
