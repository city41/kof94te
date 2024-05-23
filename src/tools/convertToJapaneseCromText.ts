import path from "path";
import fsp from "fs/promises";
import { createCanvas, Canvas } from "canvas";
import { charsCrom } from "./cromChars";
import { calcDestIndex, japaneseEndingsCromSpans } from "src/cromSpans";

let fill = "green";

type ExistingTileOutput = {
  existingTile: " " | "c" | "n" | "e";
};

type NewTileOuput = {
  newTile: Canvas;
};

type TileOutput = ExistingTileOutput | NewTileOuput;

function isExistingTileOutput(tile: TileOutput): tile is ExistingTileOutput {
  return "existingTile" in tile;
}

function createTile(char: string): Canvas {
  const largeC = createCanvas(160, 160);
  const lctx = largeC.getContext("2d");

  lctx.fillStyle = fill;

  if (fill === "green") {
    fill = "red";
  } else {
    fill = "green";
  }

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

function generateAssembly(tiles: TileOutput[]): string {
  let newIndex = 0;

  const asm: string[] = [];

  for (let i = 0; i < tiles.length; ++i) {
    const tile = tiles[i];
    if (isExistingTileOutput(tile)) {
      const word = charsCrom[tile.existingTile];
      asm.push(`dc.w $${word.toString(16)}`);
    } else {
      const destIndexResult = calcDestIndex(
        newIndex,
        true,
        japaneseEndingsCromSpans
      );
      asm.push(`dc.w $${destIndexResult.destIndex.toString(16)}`);
      newIndex += 1;
    }
  }

  return asm.join("\n");
}

async function main(inputFilePath: string, outputDir: string) {
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
          tileOutput.push({ existingTile: char });
          break;
        default: {
          const tile = createTile(char);
          tileOutput.push({ newTile: tile });
        }
      }
    }
  }

  const assembly = generateAssembly(tileOutput);
  fsp.writeFile(
    path.resolve(outputDir, `${path.basename(inputFilePath)}.asm`),
    assembly
  );
  // const cromTiles = generateCromTiles(tileOutput);
  // fsp.writeFile(
  //   path.resolve(outputDir, `${path.basename(inputFilePath)}.c1`),
  //   cromTiles.c1
  // );
  // fsp.writeFile(
  //   path.resolve(outputDir, `${path.basename(inputFilePath)}.c2`),
  //   cromTiles.c2
  // );
}

const [_tsnode, _convertToJapaneseCromText, inputFilePath, outputDir] =
  process.argv;

if (!inputFilePath || !outputDir) {
  console.error(
    "usage: ts-node convertToJapaneseCromText.ts <input-file-path> <output-dir-path>"
  );
  process.exit(1);
}

main(path.resolve(inputFilePath), path.resolve(outputDir))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
