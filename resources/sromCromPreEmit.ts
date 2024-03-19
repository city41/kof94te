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
  /**
   * If set, this tile has an auto animation associated with it
   */
  autoAnimation?: 4 | 8;

  flipH?: boolean;
  flipV?: boolean;
};

type SromCromCromImage = {
  name: string;
  imageFile: string;
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
  tile: SromCromTile,
  startingPaletteIndex: number
): AsmCromTileSCB1 {
  const destIndex = calcDestIndex(tile.index - 256, true).destIndex;

  // lsb of tile index
  const evenWord = destIndex & 0xffff;

  // [palette] | [tile msb] | [auto anim] | [vert flip] | [hor flip]
  const palette = (tile.paletteIndex + startingPaletteIndex) << 8;
  const msb = ((destIndex & 0xf0000) >> 16) << 4;

  const oddWord = palette | msb;

  return {
    evenWord,
    oddWord,
  };
}

function createAssemblyTileSBC3(column: SromCromTile[], y: number): number {
  // for now, setting all ys to zero
  // onscreen y is 496-y
  const yToWrite = 496 - y;
  return (yToWrite << 7) | column.length;
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
    scb1.push(createAssemblyTileSCB1(tile, startingPaletteIndex));
  }

  const scb3 = createAssemblyTileSBC3(sromCromColumn, cromImage.custom.y);
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
  const startingPaletteIndex = 140;
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
