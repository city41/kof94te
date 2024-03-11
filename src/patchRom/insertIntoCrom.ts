import { CromBuffer } from './types';

function getOddCromIndex(tileIndex: number): number {
	if (tileIndex < 16384) {
		return 0;
	} else if (tileIndex < 32768) {
		return 2;
	} else {
		return 4;
	}
}

// a CROM tile is 128 bytes total, so 64 bytes go into one half of the pair
const BYTES_PER_TILE_WITHIN_CROM = 64;

// NOTE: this does not properly handle tiles that straddle croms,
// ie start at the end of c1/c2 and finish in c3/c4
function insertIntoCrom(
	oddBytes: number[],
	evenBytes: number[],
	firstTileIndex: number,
	cromBuffers: CromBuffer[]
): CromBuffer[] {
	const oddCromIndex = getOddCromIndex(firstTileIndex);
	const evenCromIndex = oddCromIndex + 1;

	const tileIndexWithinCrom = firstTileIndex - 16384 * (evenCromIndex / 2);
	const byteIndexWithinCrom = tileIndexWithinCrom * BYTES_PER_TILE_WITHIN_CROM;

	return cromBuffers.map((cb, i) => {
		if (i === evenCromIndex) {
			cb.data.splice(byteIndexWithinCrom, evenBytes.length, ...evenBytes);
		}
		if (i === oddCromIndex) {
			cb.data.splice(byteIndexWithinCrom, oddBytes.length, ...oddBytes);
		}

		return cb;
	});
}

export { insertIntoCrom };
