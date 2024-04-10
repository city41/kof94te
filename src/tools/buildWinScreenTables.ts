/**
 * buildWinScreenTables.ts
 *
 * The game inclues three tables of xy words for all characters to position
 * them during the win screen. A table is chosen depending on who won the match,
 * character 0 (leader), 1 or 2.
 *
 * For the team edit hack, we need three tables too.
 *
 * table 1: places all characters at the center
 * table 2: places all characters to the left
 * table 3: places all characters to the right
 *
 * To build these tables, we'll consult the existing tables and reuse the xy values
 * as much as possible. All y's can be reused, but not all x's because some characters
 * (like Benimaru) never show up on one side (ie Benimaru is only in the center or right side
 * during win screens. I might be misremembering for Benimaru but the concept is correct at least)
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

// these are the physical addresses inside the ROM
// when the game is running, they get mapped into the first megabyte
// so subtract 0x100000 to see them when game is running
const gameTableAddresses = [0x1626ee, 0x162756, 0x1627be] as const;
// there are actually 26 entries in the table, possibly for Rugal,
// but we only care about the main characters
const ENTRY_SIZE = 4;
const GAME_TABLE_SIZE = 24 * ENTRY_SIZE;

type GameTable = Record<(typeof gameTableAddresses)[number], number[]>;

function buildCenterTable(gameTables: GameTable): number[] {
  const charIds = Object.values(characterIds);

  return charIds.reduce<number[]>((accum, cid, i) => {
    const gameTableAddress = gameTableAddresses[i % 3];
    const gameTable = gameTables[gameTableAddress];
    const gameTableEntry = gameTable.slice(
      cid * ENTRY_SIZE,
      (cid + 1) * ENTRY_SIZE
    );

    accum.push(...gameTableEntry);

    return accum;
  }, []);
}

function getXWithY(
  gameTables: GameTable,
  charId: number,
  predicate: (a: number, b: number) => boolean
): { x: number; ybytes: [number, number] } {
  const gameTableSideAddress1 = gameTableAddresses[(charId + 1) % 3];
  const gameTableSideAddress2 = gameTableAddresses[(charId + 2) % 3];
  const gameTableSide1 = gameTables[gameTableSideAddress1];
  const gameTableSide2 = gameTables[gameTableSideAddress2];

  const gameTableSide1Entry = gameTableSide1.slice(
    charId * ENTRY_SIZE,
    (charId + 1) * ENTRY_SIZE
  );

  const gameTableSide2Entry = gameTableSide2.slice(
    charId * ENTRY_SIZE,
    (charId + 1) * ENTRY_SIZE
  );

  const x1 = (gameTableSide1Entry[0] << 8) | gameTableSide1Entry[1];
  const x2 = (gameTableSide2Entry[0] << 8) | gameTableSide2Entry[1];

  if (predicate(x1, x2)) {
    return {
      x: x1,
      ybytes: gameTableSide1Entry.slice(2) as [number, number],
    };
  } else {
    return {
      x: x2,
      ybytes: gameTableSide2Entry.slice(2) as [number, number],
    };
  }
}

function buildLeftTable(gameTables: GameTable): number[] {
  const charIds = Object.values(characterIds);

  const leftTable: number[] = [];

  for (let i = 0; i < charIds.length; i += 3) {
    const minPredicate = (a: number, b: number) => a < b;
    const { x: leaderX, ybytes: leaderY } = getXWithY(
      gameTables,
      i,
      minPredicate
    );
    const { x: secondX, ybytes: secondY } = getXWithY(
      gameTables,
      i + 1,
      minPredicate
    );
    const { x: thirdX, ybytes: thirdY } = getXWithY(
      gameTables,
      i + 2,
      minPredicate
    );

    const minX = Math.min(leaderX, secondX, thirdX);
    const minXHsb = minX >> 8;
    const minXLsb = minX & 0xff;

    leftTable.push(minXHsb, minXLsb);
    leftTable.push(...leaderY);

    leftTable.push(minXHsb, minXLsb);
    leftTable.push(...secondY);

    leftTable.push(minXHsb, minXLsb);
    leftTable.push(...thirdY);
  }

  return leftTable;
}

function buildRightTable(gameTables: GameTable): number[] {
  const charIds = Object.values(characterIds);

  const rightTable: number[] = [];

  for (let i = 0; i < charIds.length; i += 3) {
    const maxPredicate = (a: number, b: number) => a > b;
    const { x: leaderX, ybytes: leaderY } = getXWithY(
      gameTables,
      i,
      maxPredicate
    );
    const { x: secondX, ybytes: secondY } = getXWithY(
      gameTables,
      i + 1,
      maxPredicate
    );
    const { x: thirdX, ybytes: thirdY } = getXWithY(
      gameTables,
      i + 2,
      maxPredicate
    );

    const maxX = Math.max(leaderX, secondX, thirdX);
    const maxXHsb = maxX >> 8;
    const maxXLsb = maxX & 0xff;

    rightTable.push(maxXHsb, maxXLsb);
    rightTable.push(...leaderY);

    rightTable.push(maxXHsb, maxXLsb);
    rightTable.push(...secondY);

    rightTable.push(maxXHsb, maxXLsb);
    rightTable.push(...thirdY);
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
  centerTable: number[],
  leftTable: number[],
  rightTable: number[]
): Promise<void> {
  const centerTableDcs = tableToAsm(centerTable);
  const leftTableDcs = tableToAsm(leftTable);
  const rightTableDcs = tableToAsm(rightTable);

  const asm = `;;; win screen tables, generated by buildWinScreenTables.ts
;;; center table: places all characters in center of screen
${centerTableDcs.join("\n")}
;;; left table: places all characters to left side
${leftTableDcs.join("\n")}
;;; right table: places all characters to right side
${rightTableDcs.join("\n")}
`;

  return fsp.writeFile(path.resolve("src/patches/winScreenTables.asm"), asm);
}

async function main(pRomPath: string): Promise<void> {
  const buffer = await fsp.readFile(pRomPath);
  const data = flipBytes(Array.from(buffer));

  const gameTables: GameTable = gameTableAddresses.reduce((accum, addr) => {
    accum[addr] = data.slice(addr, addr + GAME_TABLE_SIZE);
    return accum;
  }, {} as unknown as GameTable);

  const centerTable = buildCenterTable(gameTables);
  const leftTable = buildLeftTable(gameTables);
  const rightTable = buildRightTable(gameTables);

  return writeTablesToAsm(centerTable, leftTable, rightTable);
}

const [_tsnode, _buildWinScreenTable, pRomPath] = process.argv;

if (!pRomPath) {
  console.error("usage: ts-node buildWinScreenTable.ts <prom-path>");
  process.exit(1);
}

main(path.resolve(pRomPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
