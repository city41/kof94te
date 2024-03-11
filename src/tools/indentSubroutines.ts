import * as path from "path";
import * as fsp from "fs/promises";

async function main(tracePath: string) {
  const trace = (await fsp.readFile(tracePath)).toString();
  const lines = trace.split("\n");

  const indentedLines: string[] = [];

  let indent = 0;

  for (let i = 0; i < lines.length; ++i) {
    const opcode = lines[i].substring(8, 11);
    let nextIndent = indent;

    if (opcode === "jsr" || opcode === "bsr") {
      nextIndent += 1;
    }

    if (opcode === "rts") {
      nextIndent = Math.max(0, nextIndent - 1);
    }

    indentedLines.push(
      `${new Array(indent * 2).fill(" ").join("")}${lines[i]}`
    );
    indent = nextIndent;
  }

  await fsp.writeFile(`${tracePath}.indented.txt`, indentedLines.join("\n"));
}

const [_tsnode, _indentSubroutines, tracePath] = process.argv;

if (!tracePath) {
  console.error("usage: ts-node indentSubroutines.ts <trace-path>");
  process.exit(1);
}

main(path.resolve(tracePath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
