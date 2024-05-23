import path from "path";
import fsp from "fs/promises";
import { createCanvas, Canvas, CanvasRenderingContext2D } from "canvas";
import { calcDestIndex, japaneseEndingsCromSpans } from "../cromSpans";
// @ts-ignore
import { getCanvasContextFromImagePath } from "@city41/sromcrom/lib/api/canvas/getCanvasContextFromImagePath";
import { createCromBytesFromCanvasContext } from "../patchRom/createCromBytes";

type ControlChar = " " | "c" | "n" | "e";

type ControlTileOutput = {
  control: ControlChar;
};

type NewTileOuput = {
  char: string;
  newTile: Canvas;
};

type TileOutput = ControlTileOutput | NewTileOuput;

function isControlTileOutput(tile: TileOutput): tile is ControlTileOutput {
  return "control" in tile;
}

function createTile(char: string): Canvas {
  const largeC = createCanvas(160, 160);
  const lctx = largeC.getContext("2d");

  lctx.fillStyle = "rgb(255, 0, 255)";

  lctx.fillRect(0, 0, largeC.width, largeC.height);
  lctx.font = "160px JF Dot jiskan16";
  lctx.fillStyle = "white";

  lctx.fillText(char, 0, 140);

  const c16 = createCanvas(16, 16);
  const c16ctx = c16.getContext("2d");

  c16ctx.imageSmoothingEnabled = false;
  c16ctx.drawImage(largeC, 0, 0, 16, 16);

  return c16;
}

const controlWords: Record<ControlChar, number> = {
  " ": 0,
  n: 0xd,
  c: 0xfffe,
  e: 0xffff,
};

function generateAssembly(tiles: TileOutput[]): string {
  let newIndex = 0;

  const asm: string[] = [];

  for (let i = 0; i < tiles.length; ++i) {
    const tile = tiles[i];
    if (isControlTileOutput(tile)) {
      const word = controlWords[tile.control];
      asm.push(`dc.w $${word.toString(16)} ; ${tile.control}`);
    } else {
      const destIndexResult = calcDestIndex(
        newIndex,
        true,
        japaneseEndingsCromSpans
      );
      asm.push(
        `dc.w $${destIndexResult.destIndex.toString(16)} ; ${tile.char}`
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

async function main(
  inputFilePath: string,
  palettePath: string,
  outputDir: string
) {
  const paletteCanvasContext = getCanvasContextFromImagePath(palettePath);
  const rawText = (await fsp.readFile(inputFilePath)).toString();
  const lines = rawText.split("\n").filter((l) => !l.startsWith("#"));

  const tileOutput: TileOutput[] = [];

  for (let i = 0; i < lines.length; ++i) {
    const line = lines[i];

    for (let c = 0; c < line.length; ++c) {
      const char = line[c];

      switch (char) {
        case " ":
        case "c":
        case "n":
        case "e":
          tileOutput.push({ control: char });
          break;
        default: {
          const tile = createTile(char);
          tileOutput.push({ newTile: tile, char });
        }
      }
    }
  }

  const assembly = generateAssembly(tileOutput);
  fsp.writeFile(
    path.resolve(outputDir, `${path.basename(inputFilePath)}.asm`),
    assembly
  );
  const cromTiles = generateCromTiles(tileOutput, paletteCanvasContext);
  fsp.writeFile(
    path.resolve(outputDir, `${path.basename(inputFilePath)}.c1`),
    new Uint8Array(cromTiles.oddData)
  );
  fsp.writeFile(
    path.resolve(outputDir, `${path.basename(inputFilePath)}.c2`),
    new Uint8Array(cromTiles.evenData)
  );
}

const [
  _tsnode,
  _convertToJapaneseCromText,
  inputFilePath,
  palettePath,
  outputDir,
] = process.argv;

if (!inputFilePath || !palettePath || !outputDir) {
  console.error(
    "usage: ts-node convertToJapaneseCromText.ts <input-file-path> <palette-path> <output-dir-path>"
  );
  process.exit(1);
}

main(
  path.resolve(inputFilePath),
  path.resolve(palettePath),
  path.resolve(outputDir)
)
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
