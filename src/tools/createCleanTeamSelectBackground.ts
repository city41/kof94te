/**
 * createCleanTeamSelectBackground.ts
 *
 * This script pulls tiles from the how to play screen and the order select
 * screen to create a new tilemap for the team select screen that does not have the globe.
 *
 * Then at runtime, the hack constantly takes the logo/countries sprites and moves them offscreen,
 * the result is a character select screen with a clean/simple background very much like KOF95's
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
      let tileWord;

      if (y === 0) {
        // the first row in team/order's tilemap is zero
        tileWord = 0;
      } else if (y >= 12) {
        // grab from order select to avoid the control panel background in HTP
        tileWord = getTileWord(x, y, orderSelectTilemap);
      } else {
        // pull from HTP to avoid the globe, but up by one
        // as the tilemap for HTP has zero at the bottom for some reason
        tileWord = getTileWord(x, y - 1, htpTilemap);
      }

      const paletteWord =
        x < 10
          ? getPaletteWord(0, y, orderSelectTilemap)
          : getPaletteWord(19, 6, orderSelectTilemap);

      const longVal = (tileWord << 16) | paletteWord;
      tilemapDcs.push(`dc.l $${longVal.toString(16)}`);
    }
  }

  const asm = `;;; replace the team select bg tilemap with a new one
;;; that is just the repeating SNK logo and red/blue divided color scheme
${tilemapDcs.join("\n")}
`;

  return fsp.writeFile(
    path.resolve("src/patches/cleanTeamSelectBgTilemap.asm"),
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
