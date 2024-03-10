import * as path from "path";
import * as fsp from "fs/promises";

type Span = {
  start: number;
  end: number;
};

async function main(pRomPath: string) {
  const buffer = await fsp.readFile(pRomPath);
  const data = Array.from(buffer);

  let i = 0;

  const spans: Span[] = [];

  while (i < data.length) {
    let start = i;
    while (start < data.length && data[start] !== 0) {
      ++start;
    }

    let end = start;

    while (end < data.length && data[end] === 0) {
      ++end;
    }

    ++end;

    if (end - start > 1023) {
      spans.push({ start, end });
    }

    i = end;
  }

  for (const span of spans) {
    console.log(
      `s: 0x${span.start.toString(16)}, e: 0x${span.end.toString(16)} -- ${
        span.end - span.start
      }`
    );
  }
}

const [_tsnode, _zeroReport, pRomPath] = process.argv;

if (!pRomPath) {
  console.error("usage: ts-node zeroReport.ts <prom-path>");
  process.exit(1);
}

main(path.resolve(pRomPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
