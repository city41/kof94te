/**
 * buildCutscene2Tables.ts
 *
 * The game includess a table of xy words for all characters to position
 * them during the second cutscreen screen. Characters xy values in this table
 * are dependent on if they are character 0, 1 or 2 for the team, but also account for
 * size, such as Chang and Choi.
 *
 * For the team edit hack, this single table needs to become three tables
 *
 * table 1: places all characters at the right
 * table 2: places all characters to the center
 * table 3: places all characters to the left
 *
 * To build these tables, we'll consult the existing table and reuse the xy values
 * as much as possible. All y's can be reused, and for x most characters will just get a
 * generic one that should work, and this script will probably add tweeks for characters
 * of unusual size (small or large)
 */
import * as path from "path";
import * as fsp from "fs/promises";
import { characterIds } from "./characterIds";

function flipBytes(data: number[]): number[] {
  for (let i = 0; i < data.length; i += 2) {
    const byte = data[i];
    data[i] = data[i + 1];
    data[i + 1] = byte;
  }

  return data;
}

// this is the physical addresses inside the ROM
// when the game is running, it gets mapped into the first megabyte
// so subtract 0x100000 to see it when game is running
const gameTableAddress = 0x143cc6;
const ENTRY_SIZE = 4;
const GAME_TABLE_SIZE = 24 * ENTRY_SIZE;

function buildTable(gameTable: number[], targetCharIndex: 0 | 1 | 2): number[] {
  const charIds = Object.values(characterIds);

  const rightTable: number[] = [];

  for (let i = 0; i < charIds.length; ++i) {
    const teamId = Math.floor(i / 3);

    // just use the ys the game already has, they are fine
    const y = (gameTable[i * 4 + 2] << 8) | gameTable[i * 4 + 3];

    // use the targetCharIndex for the whole team. So the whole team will
    // use the leader's value to be on the right side, for example
    const xI = teamId * 3 + targetCharIndex;
    const x = (gameTable[xI * 4] << 8) | gameTable[xI * 4 + 1];

    const yHb = y >> 8;
    const yLb = y & 0xff;
    const xHb = x >> 8;
    const xLb = x & 0xff;

    rightTable.push(xHb, xLb, yHb, yLb);
  }

  return rightTable;
}

function tableToAsm(table: number[]): string[] {
  const charEntries = Object.entries(characterIds);

  return table.map((ctv, i) => {
    const charEntry = charEntries[Math.floor(i / 4)];
    const xyComment = {
      0: "x hb",
      1: "x lb",
      2: "y hb",
      3: "y lb",
    }[i % 4];

    return `dc.b $${ctv.toString(16)} ; ${charEntry[0]} ${xyComment}`;
  });
}

async function writeTablesToAsm(
  rightTable: number[],
  centerTable: number[],
  leftTable: number[]
): Promise<void> {
  const rightTableDcs = tableToAsm(rightTable);
  const centerTableDcs = tableToAsm(centerTable);
  const leftTableDcs = tableToAsm(leftTable);

  const asm = `;;; cutscene 2 tables, generated by buildCutscene2Tables.ts
;;; right table: places all characters to right side (leader position)
${rightTableDcs.join("\n")}
;;; center table: places all characters in center of screen (secondary position)
${centerTableDcs.join("\n")}
;;; left table: places all characters to left side (tertiary position)
${leftTableDcs.join("\n")}
`;

  return fsp.writeFile(path.resolve("src/patches/cutscene2Tables.asm"), asm);
}

async function main(pRomPath: string): Promise<void> {
  const buffer = await fsp.readFile(pRomPath);
  const data = flipBytes(Array.from(buffer));

  const gameTable: number[] = data.slice(
    gameTableAddress,
    gameTableAddress + GAME_TABLE_SIZE
  );

  const rightTable = buildTable(gameTable, 0);
  const centerTable = buildTable(gameTable, 1);
  const leftTable = buildTable(gameTable, 2);

  return writeTablesToAsm(rightTable, centerTable, leftTable);
}

const [_tsnode, _buildCutscene2Tables, pRomPath] = process.argv;

if (!pRomPath) {
  console.error("usage: ts-node buildCutscene2Tables.ts <prom-path>");
  process.exit(1);
}

main(path.resolve(pRomPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
