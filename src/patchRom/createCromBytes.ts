// @ts-ignore
import { getCanvasContextFromImagePath } from '@city41/sromcrom/lib/api/canvas/getCanvasContextFromImagePath';
// @ts-ignore
import { extractCromTileSources } from '@city41/sromcrom/lib/api/crom/extractCromTileSources';
// @ts-ignore
import { setCROMBinaryData } from '@city41/sromcrom/lib/api/crom/setCROMBinaryData';
// @ts-ignore
import { get24BitPalette } from '@city41/sromcrom/lib/api/palette/get24BitPalette';
// @ts-ignore
import { convertTo16BitPalette } from '@city41/sromcrom/lib/api/palette/convertTo16Bit';
import { CanvasRenderingContext2D } from 'canvas';

type CreateCromBytesResult = {
	oddCromBytes: number[];
	evenCromBytes: number[];
};

type Color24Bit = [number, number, number, number];
type Palette24 = [Color24Bit, ...Color24Bit[]];

type CROMTile = {
	canvasSource: any;
	palette: any;
	cromBinaryData: {
		cEvenData: number[];
		cOddData: number[];
	};
};

type CROMTileMatrixRow = CROMTile[];
type CROMTileMatrix = CROMTileMatrixRow[];

function createPalette24(context: CanvasRenderingContext2D): Palette24 {
	if (context.canvas.width !== 16) {
		throw new Error('the palette image must be 16px wide');
	}

	if (context.canvas.height !== 1) {
		throw new Error('the palette image must be 1px tall');
	}

	const imgData = context.getImageData(0, 0, 16, 1);

	const pal = [];

	for (let c = 0; c < 16 * 4; c += 4) {
		const color = Array.from(imgData.data.slice(c, c + 4));
		pal.push(color);
	}

	return pal as Palette24;
}

function createCromBytes(
	pngFilePath: string,
	pngPalettePath: string
): CreateCromBytesResult {
	const imgCanvasContext = getCanvasContextFromImagePath(pngFilePath);
	const paletteCanvasContext = getCanvasContextFromImagePath(pngPalettePath);
	const cromMatrix: CROMTileMatrix = extractCromTileSources(imgCanvasContext);

	const oddCromBytes: number[] = [];
	const evenCromBytes: number[] = [];

	const palette24 = createPalette24(paletteCanvasContext);

	for (let y = 0; y < cromMatrix.length; ++y) {
		for (let x = 0; x < cromMatrix[y].length; ++x) {
			let cromTile = cromMatrix[y][x];
			cromTile.palette = convertTo16BitPalette(palette24);

			cromTile = setCROMBinaryData(cromTile);
			oddCromBytes.push(...cromTile.cromBinaryData.cOddData);
			evenCromBytes.push(...cromTile.cromBinaryData.cEvenData);
		}
	}

	return { oddCromBytes, evenCromBytes };
}

export { createCromBytes };
