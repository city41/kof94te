import path from "path";
import fsp from "fs/promises";
import { createCanvas, Canvas } from "canvas";

let fill = "green";

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

async function main() {
  const text = "何が起きているの？";

  const c = createCanvas(16 * text.length, 16);
  const ctx = c.getContext("2d");

  for (let i = 0; i < text.length; ++i) {
    const tile = createTile(text[i]);

    ctx.drawImage(tile, i * 16, 0);
  }

  const buffer = c.toBuffer();
  await fsp.writeFile(path.resolve("./text.png"), buffer);
}

// const [_tsnode, _convertToJapaneseCromText, inputFilePath] = process.argv;

// if (!inputFilePath) {
//   console.error("usage: ts-node convertToJapaneseCromText.ts");
//   process.exit(1);
// }

main()
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
