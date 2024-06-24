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
  sticky = false
): number {
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
  startingPaletteIndex: number,
  sticky = false
): AsmCromColumn {
  const scb1: AsmCromTileSCB1[] = [];

  for (let y = 0; y < sromCromColumn.length; ++y) {
    const tile = sromCromColumn[y];
    scb1.push(createAssemblyTileSCB1(cromImage, tile, startingPaletteIndex));
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
      // HACK ALERT: just making character_grid sticky
      createAsmColumn(
        tx,
        column,
        cromImage,
        startingPaletteIndex,
        cromImage.name === "character_grid" && tx > 0
      )
    ),
  };
}

// these are in order of team ids
const characterToGridSpriteData: Array<{
  spriteIndexOffset: number;
  tileIndexOffset: number;
}> = [
  {
    // Heidern
    spriteIndexOffset: 12,
    tileIndexOffset: 0,
  },
  {
    // Ralf
    spriteIndexOffset: 14,
    tileIndexOffset: 0,
  },
  {
    // Clark
    spriteIndexOffset: 16,
    tileIndexOffset: 0,
  },
  {
    // Athena
    spriteIndexOffset: 0,
    tileIndexOffset: 2,
  },
  {
    // Sie
    spriteIndexOffset: 2,
    tileIndexOffset: 2,
  },
  {
    // Chin
    spriteIndexOffset: 4,
    tileIndexOffset: 2,
  },
  {
    // Kyo
    spriteIndexOffset: 0,
    tileIndexOffset: 4,
  },
  {
    // Beni
    spriteIndexOffset: 2,
    tileIndexOffset: 4,
  },
  {
    // Goro
    spriteIndexOffset: 4,
    tileIndexOffset: 4,
  },
  {
    // Heavy
    spriteIndexOffset: 6,
    tileIndexOffset: 0,
  },
  {
    // Lucky
    spriteIndexOffset: 8,
    tileIndexOffset: 0,
  },
  {
    // Brian
    spriteIndexOffset: 10,
    tileIndexOffset: 0,
  },
  {
    // Kim
    spriteIndexOffset: 6,
    tileIndexOffset: 2,
  },
  {
    // Chang
    spriteIndexOffset: 8,
    tileIndexOffset: 2,
  },
  {
    // Choi
    spriteIndexOffset: 10,
    tileIndexOffset: 2,
  },
  {
    // Terry
    spriteIndexOffset: 0,
    tileIndexOffset: 0,
  },
  {
    // Andy
    spriteIndexOffset: 2,
    tileIndexOffset: 0,
  },
  {
    // Joe
    spriteIndexOffset: 4,
    tileIndexOffset: 0,
  },
  {
    // Ryo
    spriteIndexOffset: 12,
    tileIndexOffset: 4,
  },
  {
    // Robert
    spriteIndexOffset: 14,
    tileIndexOffset: 4,
  },
  {
    // Takuma
    spriteIndexOffset: 16,
    tileIndexOffset: 4,
  },
  {
    // Yuri
    spriteIndexOffset: 12,
    tileIndexOffset: 2,
  },
  {
    // Mai
    spriteIndexOffset: 14,
    tileIndexOffset: 2,
  },
  {
    // King
    spriteIndexOffset: 16,
    tileIndexOffset: 2,
  },
];

// taken from the patch's symbols
const GRID_IMAGE_SI = 0x153;
const SCB1_TILE_WORDS_PER_SPRITE = 64;

// take the grey crom image data and generate the data that will ultimately
// create CHARACTER_TO_GREY_OUT_TABLE used in greyOutDefeatedCharacter.asm
function createGreyCharacterGridEmit(greyCromImage: AsmCromImage) {
  return characterToGridSpriteData.flatMap((charSpriteData, i) => {
    const scb1Columns = greyCromImage.columns.slice(i * 2, (i + 1) * 2);

    const data: number[] = [];

    for (let x = 0; x < scb1Columns.length; ++x) {
      const column = scb1Columns[x];
      const si = GRID_IMAGE_SI + charSpriteData.spriteIndexOffset + x;

      // this starts at y = 0 every time because the source is the grey grid image
      // which is a flat image with characters in characterId order
      for (let y = 0; y < column.scb1.length; ++y) {
        const ti = charSpriteData.tileIndexOffset + y;
        // SCB1 starts at 0
        const vramAddress = si * SCB1_TILE_WORDS_PER_SPRITE + ti * 2;
        data.push(vramAddress);
        data.push(column.scb1[y].evenWord);
        data.push(vramAddress + 1);
        data.push(column.scb1[y].oddWord);
      }
    }

    return data;
  });
}

function createRugalInjectData(rugalImage: AsmCromImage): number[] {
  const words: number[] = [];

  // grid first si is 0x153, Rugal's first column is 8 over, and 7 tiles down
  const firstColumnSCB1StartingAddress = (0x153 + 8) * 64 + 7 * 2;

  words.push(firstColumnSCB1StartingAddress);
  words.push(rugalImage.columns[0].scb1[0].evenWord);
  words.push(firstColumnSCB1StartingAddress + 1);
  words.push(rugalImage.columns[0].scb1[0].oddWord);
  words.push(firstColumnSCB1StartingAddress + 2);
  words.push(rugalImage.columns[0].scb1[1].evenWord);
  words.push(firstColumnSCB1StartingAddress + 3);
  words.push(rugalImage.columns[0].scb1[1].oddWord);

  // grid first si is 0x153, Rugal's second column is 9 over, and 7 tiles down

  const secondColumnSCB1StartingAddress = (0x153 + 9) * 64 + 7 * 2;

  words.push(secondColumnSCB1StartingAddress);
  words.push(rugalImage.columns[1].scb1[0].evenWord);
  words.push(secondColumnSCB1StartingAddress + 1);
  words.push(rugalImage.columns[1].scb1[0].oddWord);
  words.push(secondColumnSCB1StartingAddress + 2);
  words.push(rugalImage.columns[1].scb1[1].evenWord);
  words.push(secondColumnSCB1StartingAddress + 3);
  words.push(rugalImage.columns[1].scb1[1].oddWord);

  return words;
}

function createRugalClearData() {
  const words: number[] = [];

  // grid first si is 0x153, Rugal's first column is 8 over, and 6 tiles down
  const firstColumnSCB1StartingAddress = (0x153 + 8) * 64 + 6 * 2;

  words.push(firstColumnSCB1StartingAddress);
  words.push(0);
  words.push(firstColumnSCB1StartingAddress + 1);
  words.push(0);
  words.push(firstColumnSCB1StartingAddress + 2);
  words.push(0);
  words.push(firstColumnSCB1StartingAddress + 3);
  words.push(0);

  // grid first si is 0x153, Rugal's second column is 9 over, and 6 tiles down

  const secondColumnSCB1StartingAddress = (0x153 + 9) * 64 + 6 * 2;

  words.push(secondColumnSCB1StartingAddress);
  words.push(0);
  words.push(secondColumnSCB1StartingAddress + 1);
  words.push(0);
  words.push(secondColumnSCB1StartingAddress + 2);
  words.push(0);
  words.push(secondColumnSCB1StartingAddress + 3);
  words.push(0);

  return words;
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
    greyCharacterGrid: createGreyCharacterGridEmit(
      cromImages.character_grid_grey
    ),
    rugalInjectData: createRugalInjectData(cromImages.rugal_character_grid),
    rugalClearData: createRugalClearData(),
  };

  return finalCodeEmitData;
}
