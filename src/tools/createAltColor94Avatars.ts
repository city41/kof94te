import * as path from "path";
import * as fsp from "fs/promises";
import { createCanvas, Image, ImageData } from "canvas";
import { closest } from "color-diff";

type ColorMap = Array<{
  reg: [number, number, number];
  alt: [number, number, number];
}>;

async function loadImage(imgPath: string): Promise<Image> {
  return new Promise((resolve) => {
    const i = new Image();
    i.onload = () => resolve(i);
    i.src = imgPath;
  });
}

function createColorMap(screenshot: Image): ColorMap {
  const regSideScreenshotCanvas = createCanvas(
    screenshot.width / 2,
    screenshot.height
  );
  const regSideScreenshotContext = regSideScreenshotCanvas.getContext("2d");

  const altSideScreenshotCanvas = createCanvas(
    screenshot.width / 2,
    screenshot.height
  );
  const altSideScreenshotContext = altSideScreenshotCanvas.getContext("2d");

  regSideScreenshotContext.drawImage(
    screenshot,
    0,
    0,
    screenshot.width / 2,
    screenshot.height,
    0,
    0,
    screenshot.width / 2,
    screenshot.height
  );

  altSideScreenshotContext.drawImage(
    screenshot,
    screenshot.width / 2,
    0,
    screenshot.width / 2,
    screenshot.height,
    0,
    0,
    screenshot.width / 2,
    screenshot.height
  );

  const regSideData = Array.from(
    regSideScreenshotContext.getImageData(
      0,
      0,
      screenshot.width / 2,
      screenshot.height
    ).data
  );
  const altSideData = Array.from(
    altSideScreenshotContext.getImageData(
      0,
      0,
      screenshot.width / 2,
      screenshot.height
    ).data
  );

  const colorMap: Array<{
    reg: [number, number, number];
    alt: [number, number, number];
  }> = [];

  for (let i = 0; i < regSideData.length; i += 4) {
    const regPixel = regSideData.slice(i, i + 3) as [number, number, number];
    const altPixel = altSideData.slice(i, i + 3) as [number, number, number];

    colorMap.push({ reg: regPixel, alt: altPixel });
  }

  return colorMap;
}

function findAltPixel(
  regPixel: [number, number, number],
  colorMap: ColorMap
): [number, number, number] {
  // special case for magenta
  if (regPixel[0] === 255 && regPixel[1] === 0 && regPixel[2] === 255) {
    return regPixel;
  }

  // special case for white
  if (regPixel[0] === 255 && regPixel[1] === 255 && regPixel[2] === 255) {
    return regPixel;
  }

  const palette = colorMap.map((cme) => {
    return {
      R: cme.reg[0],
      G: cme.reg[1],
      B: cme.reg[2],
    };
  });

  const regPixelO = { R: regPixel[0], G: regPixel[1], B: regPixel[2] };
  const closestMatch = closest(regPixelO, palette);
  const matchingPaletteIndex = palette.findIndex((p) => {
    return (
      p.R === closestMatch.R && p.G === closestMatch.G && p.B === closestMatch.B
    );
  });

  return colorMap[matchingPaletteIndex].alt;
}

function renderAltData(
  regData: ImageData,
  altData: ImageData,
  screenshot: Image
) {
  const colorMap = createColorMap(screenshot);

  const regDataA = Array.from(regData.data);

  for (let i = 0; i < regDataA.length; i += 4) {
    const regPixel = regDataA.slice(i, i + 3) as [number, number, number];
    const altPixel = findAltPixel(regPixel, colorMap);

    altData.data[i] = altPixel[0];
    altData.data[i + 1] = altPixel[1];
    altData.data[i + 2] = altPixel[2];
    altData.data[i + 3] = 255;
  }
}

async function main(
  k95AvatarPath: string,
  k95AvatarAltPath: string,
  k94AvatarPath: string
) {
  const reg94AvatarImage = await loadImage(k94AvatarPath);
  const reg94AvatarCanvas = createCanvas(
    reg94AvatarImage.width,
    reg94AvatarImage.height
  );
  const reg94AvatarContext = reg94AvatarCanvas.getContext("2d");
  reg94AvatarContext.drawImage(reg94AvatarImage, 0, 0);

  const alt94AvatarCanvas = createCanvas(
    reg94AvatarImage.width,
    reg94AvatarImage.height
  );
  const alt94AvatarContext = alt94AvatarCanvas.getContext("2d");

  const reg95AvatarImage = await loadImage(k95AvatarPath);
  const alt95AvatarImage = await loadImage(k95AvatarAltPath);

  for (let i = 0; i < 24; ++i) {
    const screenshotPath = path.resolve(
      screenshotDirPath,
      `${i.toString(16)}.png`
    );
    const screenshot = await loadImage(screenshotPath);

    const regData = reg94AvatarContext.getImageData(i * 32, 0, 32, 32);
    const altData = alt94AvatarContext.getImageData(i * 32, 0, 32, 32);

    renderAltData(regData, altData, screenshot);

    console.log({ altData });

    alt94AvatarContext.putImageData(altData, i * 32, 0);
  }

  const altBuffer = alt94AvatarCanvas.toBuffer();
  const writeDir = path.dirname(avatarPngPath);
  const writePath = path.resolve(writeDir, "avatars_alt.generated.png");

  await fsp.writeFile(writePath, altBuffer);

  console.log("wrote to", writePath);
}

const [
  _tsnode,
  _createAltColorAvatars,
  k95AvatarPath,
  k95AltAvatarPath,
  k94avatarPngPath,
] = process.argv;

if (!k95AvatarPath || !k95AltAvatarPath || !k94avatarPngPath) {
  console.error(
    "usage: ts-node createAltColor94Avatars.ts <k95-avatar-path> <k95-alt-avatar-path> <k94-avatar-path>"
  );
  process.exit(1);
}

main(
  path.resolve(k95AvatarPath),
  path.resolve(k95AltAvatarPath),
  path.resolve(k94avatarPngPath)
)
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
