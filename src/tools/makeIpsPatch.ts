import path from 'node:path';
import fsp from 'node:fs/promises';

type Diff = {
	offset: number;
	length: number;
	diffBytes: number[];
};

const IPS_HEADER = 'PATCH'.split('').map((c) => c.charCodeAt(0));
const IPS_EOF = 'EOF'.split('').map((c) => c.charCodeAt(0));

function usage() {
	console.error(
		'ts-node makeIpsPatch.ts <hacked-binary-path> <original-binary-path> <ips-dest-path>'
	);
}

function toBytes(num: number, byteCount: number): number[] {
	const bytes: number[] = [];

	for (let i = 0; i < byteCount; ++i) {
		const byte = num & 0xff;
		bytes.push(byte);
		num = num >> 8;
	}

	return bytes.reverse();
}

function getDiffs(originalBinary: number[], hackedBinary: number[]): Diff[] {
	if (originalBinary.length !== hackedBinary.length) {
		throw new Error(
			`hackedBinary(${hackedBinary.length}) and originalBinary(${originalBinary.length}) are different lengths`
		);
	}

	const diffs: Diff[] = [];
	let currentDiff: Diff | null = null;

	for (let i = 0; i < originalBinary.length; i++) {
		if (hackedBinary[i] !== originalBinary[i]) {
			if (currentDiff === null) {
				currentDiff = { offset: i, length: 1, diffBytes: [hackedBinary[i]] };
			} else {
				currentDiff.length++;
				currentDiff.diffBytes.push(hackedBinary[i]);
			}
		} else {
			if (currentDiff !== null) {
				diffs.push(currentDiff);
				currentDiff = null;
			}
		}
	}

	if (currentDiff !== null) {
		diffs.push(currentDiff);
	}

	return diffs;
}

export function dumpDiffs(diffs: Diff[], originalBinary: number[]) {
	for (const diff of diffs) {
		console.log(
			`diff at ${diff.offset} of length: ${diff.length} (diffBytes.length: ${diff.diffBytes.length})`
		);

		console.log('hk --- og');
		console.log('---------');
		for (let i = 0; i < diff.diffBytes.length; i++) {
			console.log(
				diff.diffBytes[i].toString(16),
				'---',
				originalBinary[i + diff.offset].toString(16)
			);
		}

		console.log('\n');
	}
}

function createIpsPatch(
	originalBinary: number[],
	hackedBinary: number[]
): number[] {
	const diffs = getDiffs(originalBinary, hackedBinary);

	// dumpDiffs(diffs, originalBinary);

	const ipsDiffData = diffs.flatMap((d) => {
		return [...toBytes(d.offset, 3), ...toBytes(d.length, 2), ...d.diffBytes];
	});

	const ipsData = [...IPS_HEADER, ...ipsDiffData, ...IPS_EOF];

	return ipsData;
}

async function main(
	originalPath: string,
	hackedPath: string,
	destPath: string
): Promise<void> {
	const originalBuffer = await fsp.readFile(originalPath);
	const originalBinary = Array.from(originalBuffer);
	const hackedBuffer = await fsp.readFile(hackedPath);
	const hackedBinary = Array.from(hackedBuffer);

	const ipsPatchData = createIpsPatch(originalBinary, hackedBinary);

	return fsp.writeFile(destPath, Uint8Array.from(ipsPatchData));
}

const [_tsnode, _makeIpsPatch, originalBinaryPath, hackedBinaryPath, destPath] =
	process.argv;

if (!originalBinaryPath || !hackedBinaryPath || !destPath) {
	usage();
	process.exit(1);
}

main(
	path.resolve(process.cwd(), originalBinaryPath),
	path.resolve(process.cwd(), hackedBinaryPath),
	path.resolve(process.cwd(), destPath)
)
	.then(() => console.log('done'))
	.catch((e) => console.error(e));
