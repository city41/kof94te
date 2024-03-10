import * as path from "path";
import * as fsp from "fs/promises";

type Mem = {
  path: string;
  mem: string;
  lines: string[];
};

function allLinesAreDifferent(mems: Mem[], i: number): boolean {
  return mems.every((mm) => {
    return mems.every((mc) => {
      return mc === mm || mm.lines[i] !== mc.lines[i];
    });
  });
}

async function main(memTextPaths: string[]) {
  const mems: Array<Mem> = [];

  for (const memTextPath of memTextPaths) {
    const m = (await fsp.readFile(memTextPath)).toString();
    mems.push({
      path: memTextPath,
      mem: m,
      lines: m.split("\n"),
    });
  }

  const avgLength =
    mems.reduce((accum, m) => {
      return accum + m.mem.length;
    }, 0) / mems.length;

  if (!mems.every((m) => m.mem.length === avgLength)) {
    throw new Error("the memory dumps are not all the same length");
  }

  let diffCount = 0;
  for (let i = 0; i < mems[0].lines.length; ++i) {
    if (allLinesAreDifferent(mems, i)) {
      console.log("-----------");
      mems.forEach((m) => {
        console.log(m.lines[i]);
      });
      console.log("-----------");
      ++diffCount;
    }
  }

  console.log({ diffCount });
}

const [_tsnode, _memDiff, ...memTxtFiles] = process.argv;

if (!memTxtFiles?.length || memTxtFiles.length === 1) {
  console.error(
    "usage: ts-node memDiff.ts <mem-txt-file-1> <mem-txt-file-2>..."
  );
  process.exit(1);
}

main(memTxtFiles.map((mtf) => path.resolve(mtf)))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
