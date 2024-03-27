import { calcDestIndex } from "../src/cromSpans";

type SromCromTile = {
  /**
   * Where in CROM this tile lives
   */
  index: number;
  /**
   * Which palette this tile uses
   */
  paletteIndex: number;

  flipH?: boolean;
  flipV?: boolean;
};

type SromCromCromImage = {
  name: string;
  imageFile: string;
  autoAnimation?: 4 | 8;
  tiles: SromCromTile[][];
  custom: {
    x: number;
    y: number;
  };
};

type AsmCromTileSCB1 = {
  evenWord: number;
  oddWord: number;
};

type AsmCromColumn = {
  scb1: AsmCromTileSCB1[];
  scb3: number;
  scb4: number;
};

type AsmCromImage = {
  name: string;
  width: number;
  height: number;
  columns: AsmCromColumn[];
};

function createAssemblyTileSCB1(
  cromImage: SromCromCromImage,
  tile: SromCromTile,
  startingPaletteIndex: number
): AsmCromTileSCB1 {
  const destIndex = calcDestIndex(tile.index - 256, true).destIndex;

  // lsb of tile index
  const evenWord = destIndex & 0xffff;
  const autoAnim = cromImage.autoAnimation ?? 0;

  // [palette] | [tile msb] | [auto anim] | [vert flip] | [hor flip]
  const palette = (tile.paletteIndex + startingPaletteIndex) << 8;
  const msb = ((destIndex & 0xf0000) >> 16) << 4;

  const oddWord = palette | autoAnim | msb;

  return {
    evenWord,
    oddWord,
  };
}

function createAssemblyTileSBC3(
  column: SromCromTile[],
  y: number,
  sticky: boolean
): number {
  // for now, setting all ys to zero
  // onscreen y is 496-y
  const yToWrite = 496 - y;
  const stickyBit = sticky ? 1 << 6 : 0;
  return (yToWrite << 7) | stickyBit | column.length;
}

function createAssemblyTileSBC4(tx: number, startingX: number): number {
  return (startingX + tx * 16) << 7;
}

function createAsmColumn(
  tx: number,
  sromCromColumn: SromCromTile[],
  cromImage: SromCromCromImage,
  startingPaletteIndex: number
): AsmCromColumn {
  const scb1: AsmCromTileSCB1[] = [];

  for (let y = 0; y < sromCromColumn.length; ++y) {
    const tile = sromCromColumn[y];
    scb1.push(createAssemblyTileSCB1(cromImage, tile, startingPaletteIndex));
  }

  let sticky = false;

  // TODO: such a hack, make every other column for avatars sticky
  if (
    (cromImage.name !== "avatars" && tx > 0) ||
    (cromImage.name === "avatars" && tx % 2 === 1)
  ) {
    sticky = true;
  }

  const scb3 = createAssemblyTileSBC3(
    sromCromColumn,
    cromImage.custom.y,
    sticky
  );
  const scb4 = createAssemblyTileSBC4(tx, cromImage.custom.x);

  return { scb1, scb3, scb4 };
}

function convertTilesFromRowsToColumns(
  tiles: SromCromTile[][]
): SromCromTile[][] {
  const columns: SromCromTile[][] = [];

  for (let x = 0; x < tiles[0].length; ++x) {
    const column: SromCromTile[] = [];

    for (let y = 0; y < tiles.length; ++y) {
      column.push(tiles[y][x]);
    }

    columns.push(column);
  }

  return columns;
}

function prepareForAssembly(
  cromImage: SromCromCromImage,
  startingPaletteIndex: number
): AsmCromImage {
  const sromCromColumns = convertTilesFromRowsToColumns(cromImage.tiles);

  return {
    name: cromImage.name,
    width: cromImage.tiles[0].length,
    height: cromImage.tiles.length,
    columns: sromCromColumns.map((column, tx) =>
      createAsmColumn(tx, column, cromImage, startingPaletteIndex)
    ),
  };
}

export default function sromCromPreEmit(_rootDir: string, codeEmitData: any) {
  const startingPaletteIndex = 16;
  console.log({ startingPaletteIndex });
  const cromImages = codeEmitData.cromImages.reduce(
    (accum: Record<string, AsmCromImage>, ci: SromCromCromImage) => {
      accum[ci.name] = prepareForAssembly(ci, startingPaletteIndex);
      return accum;
    },
    {}
  );

  const finalCodeEmitData = {
    ...codeEmitData,
    cromImages,
  };

  return finalCodeEmitData;
}
