import fsp from "fs/promises";
import { createCanvas, Canvas, CanvasRenderingContext2D } from "canvas";
import { calcDestIndex, japaneseEndingsCromSpans } from "../cromSpans";
// @ts-ignore
import { getCanvasContextFromImagePath } from "@city41/sromcrom/lib/api/canvas/getCanvasContextFromImagePath";
import { createCromBytesFromCanvasContext } from "../patchRom/createCromBytes";

type ExistingChar = " " | "c" | "n" | "e" | "D" | "?" | "!";

type ExistingTileOutput = {
  control: ExistingChar;
};

type NewTileOutput = {
  char: string;
  newTile: Canvas;
};

type TileOutput = ExistingTileOutput | NewTileOutput;

const inputSpec = {
  destAsmDir: "src/patches",
  destCromRootPath: "resources/japanese-tiles",
  inputs: [
    {
      inputTxt: "resources/EnglandEnding_part1_ja.txt",
      destAsm: "src/patches/EnglandEndingDialog_part1_ja.asm",
    },
    {
      inputTxt: "resources/EnglandEnding_part2_ja.txt",
      destAsm: "src/patches/EnglandEndingDialog_part2_ja.asm",
    },
    {
      inputTxt: "resources/EnglandEnding_part3_ja.txt",
      destAsm: "src/patches/EnglandEndingDialog_part3_ja.asm",
    },
    {
      inputTxt: "resources/USAEnding_part1_ja.txt",
      destAsm: "src/patches/USAEndingDialog_part1_ja.asm",
    },
    {
      inputTxt: "resources/USAEnding_part2_ja.txt",
      destAsm: "src/patches/USAEndingDialog_part2_ja.asm",
    },
    {
      inputTxt: "resources/USAEnding_part3_ja.txt",
      destAsm: "src/patches/USAEndingDialog_part3_ja.asm",
    },
    {
      inputTxt: "resources/MexicoEnding_part1_ja.txt",
      destAsm: "src/patches/MexicoEndingDialog_part1_ja.asm",
    },
    {
      inputTxt: "resources/MexicoEnding_part2_ja.txt",
      destAsm: "src/patches/MexicoEndingDialog_part2_ja.asm",
    },
    {
      inputTxt: "resources/MexicoEnding_part3_ja.txt",
      destAsm: "src/patches/MexicoEndingDialog_part3_ja.asm",
    },
    {
      inputTxt: "resources/MexicoEnding_part4_ja.txt",
      destAsm: "src/patches/MexicoEndingDialog_part4_ja.asm",
    },
    {
      inputTxt: "resources/JapanEnding_part1_ja.txt",
      destAsm: "src/patches/JapanEndingDialog_part1_ja.asm",
    },
    {
      inputTxt: "resources/JapanEnding_part2_ja.txt",
      destAsm: "src/patches/JapanEndingDialog_part2_ja.asm",
    },
    {
      inputTxt: "resources/JapanEnding_part3_ja.txt",
      destAsm: "src/patches/JapanEndingDialog_part3_ja.asm",
    },
  ],
  palette: "resources/japanese.palette.png",
};

function isControlTileOutput(tile: TileOutput): tile is ExistingTileOutput {
  return "control" in tile;
}

function createTile(char: string): Canvas {
  const largeC = createCanvas(160, 160);
  const lctx = largeC.getContext("2d");

  lctx.fillStyle = "rgb(255, 0, 255)";

  lctx.fillRect(0, 0, largeC.width, largeC.height);
  lctx.font = "160px JF Dot jiskan16";

  lctx.fillStyle = "rgb(128,128,128)";
  lctx.fillText(char, 0, 140);

  lctx.fillStyle = "white";
  lctx.fillText(char, 0, 130);

  const c16 = createCanvas(16, 16);
  const c16ctx = c16.getContext("2d");

  c16ctx.imageSmoothingEnabled = false;
  c16ctx.drawImage(largeC, 0, 0, 16, 16);

  return c16;
}

const existingTileWords: Record<ExistingChar, number> = {
  " ": 0,
  n: 0xd,
  c: 0xfffe,
  e: 0xffff,
  D: 0x4990,
  "?": 0x76,
  "!": 0x77,
};

function generateAssembly(tiles: TileOutput[], startingIndex: number): string {
  let newIndex = startingIndex;

  const asm: string[] = [];

  for (let i = 0; i < tiles.length; ++i) {
    const tile = tiles[i];
    if (isControlTileOutput(tile)) {
      const word = existingTileWords[tile.control];
      asm.push(`dc.w $${word.toString(16)} ; ${tile.control}`);
    } else {
      const destIndexResult = calcDestIndex(
        newIndex,
        true,
        japaneseEndingsCromSpans
      );
      asm.push(
        `dc.w $${destIndexResult.destIndex.toString(16)} ; ${tile.char} -- ${
          destIndexResult.destIndex
        }`
      );
      newIndex += 1;
    }
  }

  return asm.join("\n");
}

function generateCromTiles(
  tiles: TileOutput[],
  paletteCanvasContext: CanvasRenderingContext2D
): {
  oddData: number[];
  evenData: number[];
} {
  const oddData: number[] = [];
  const evenData: number[] = [];

  for (let i = 0; i < tiles.length; ++i) {
    const tile = tiles[i];
    if (isControlTileOutput(tile)) {
      continue;
    }
    const cromByteResult = createCromBytesFromCanvasContext(
      tile.newTile.getContext("2d"),
      paletteCanvasContext
    );
    oddData.push(...cromByteResult.oddCromBytes);
    evenData.push(...cromByteResult.evenCromBytes);
  }

  return { oddData, evenData };
}

async function main() {
  const paletteCanvasContext = getCanvasContextFromImagePath(inputSpec.palette);

  const totalTileOutput: NewTileOutput[] = [];

  for (const input of inputSpec.inputs) {
    const rawText = (await fsp.readFile(input.inputTxt)).toString();
    const lines = rawText.split("\n").filter((l) => !l.startsWith("#"));

    const currentPartTileOutput: TileOutput[] = [];

    for (let i = 0; i < lines.length; ++i) {
      const line = lines[i];

      for (let c = 0; c < line.length; ++c) {
        const char = line[c];

        switch (char) {
          case " ":
          case "c":
          case "n":
          case "e":
          case "D":
          case "?":
          case "!":
            currentPartTileOutput.push({ control: char });
            break;
          default: {
            const tile = createTile(char);
            currentPartTileOutput.push({ newTile: tile, char });
          }
        }
      }
    }

    const assembly = generateAssembly(
      currentPartTileOutput,
      totalTileOutput.length
    );
    fsp.writeFile(input.destAsm, assembly);

    totalTileOutput.push(
      ...(currentPartTileOutput.filter(
        (c) => !isControlTileOutput(c)
      ) as NewTileOutput[])
    );
  }

  const cromTiles = generateCromTiles(totalTileOutput, paletteCanvasContext);
  fsp.writeFile(
    `${inputSpec.destCromRootPath}.c1`,
    new Uint8Array(cromTiles.oddData)
  );
  fsp.writeFile(
    `${inputSpec.destCromRootPath}.c2`,
    new Uint8Array(cromTiles.evenData)
  );
}

main()
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
