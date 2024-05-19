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

function buildLong(a: number[], i: number): number {
  return (a[i] << 24) | (a[i + 1] << 16) | (a[i + 2] << 8) | a[i + 3];
}

async function writeTilemapToAsm(tilemap: number[]): Promise<void> {
  const tilemapDcs: string[] = [];

  for (let i = 0; i < tilemap.length; i += 4) {
    const longVal = buildLong(tilemap, i);
    tilemapDcs.push(`dc.l $${longVal.toString(16)}`);
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
const orderSelectBgTilemapStartingAddress = 0xc9800;
// 20 bg sprites, each with 64 bytes worth of tile data
const TILEMAP_SIZE = 20 * 64;

async function main(pRomPath: string): Promise<void> {
  const buffer = await fsp.readFile(pRomPath);
  const data = flipBytes(Array.from(buffer));

  const orderSelectBgTilemap: number[] = data.slice(
    orderSelectBgTilemapStartingAddress,
    orderSelectBgTilemapStartingAddress + TILEMAP_SIZE
  );

  return writeTilemapToAsm(orderSelectBgTilemap);
}

const [_tsnode, _copyOrderSelectBgToTeamSelect, pRomPath] = process.argv;

if (!pRomPath) {
  console.error("usage: ts-node copyOrderSelectBgToTeamSelect.ts <prom-path>");
  process.exit(1);
}

main(path.resolve(pRomPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
