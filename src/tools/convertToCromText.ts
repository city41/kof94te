import * as path from "path";
import * as fsp from "fs/promises";
import { charsCrom, cromChars } from "./cromChars";

function tableToAsm(table: number[]): string[] {
  return table.map((ctv) => {
    return `dc.w $${ctv.toString(16)} ; ${
      cromChars[ctv] ?? "not-in-cromChars"
    }`;
  });
}

async function writeTableToAsm(
  cromWordsTable: number[],
  inputS: string,
  outputPath: string
): Promise<void> {
  const cromWordsDcs = tableToAsm(cromWordsTable);

  const inputLines = inputS.split("\n").map((l) => `; ${l}`);

  const asm = `;;; crom string
;;; source
${inputLines.join("\n")}

;;; crom result
${cromWordsDcs.join("\n")}
`;

  return fsp.writeFile(outputPath, asm);
}

const NEW_LINE = 0xd;
const CLEAR = 0xfffe;
const END_DIALOG = 0xffff;

function convertToCromChars(inputS: string): number[] {
  return inputS
    .split("\n")
    .filter((l) => !l.startsWith("#")) // remove comments
    .map((l) => l.trimEnd())
    .join("")
    .split("")
    .filter((c) => c !== "\n")
    .map((c) => {
      if (c === "n") {
        return NEW_LINE;
      }

      if (c === "c") {
        return CLEAR;
      }

      if (c === "e") {
        return END_DIALOG;
      }

      const cromId = charsCrom[c];

      if (cromId === undefined) {
        throw new Error(`no crom id found for: '${c}'`);
      }

      return cromId;
    });
}

async function main(inputPath: string, outputPath: string) {
  const inputS = (await fsp.readFile(inputPath)).toString();

  const outputWords = convertToCromChars(inputS);
  console.log("number of bytes", outputWords.length * 2);

  await writeTableToAsm(outputWords, inputS, outputPath);
  console.log("wrote to", outputPath);
}

const [_tsnode, _convertToCromText, inputFilePath, outFilePath] = process.argv;

if (!inputFilePath || !outFilePath) {
  console.error(
    "usage: ts-node convertToCromText.ts <input-text-file-path> <output-asm-file-path>"
  );
  process.exit(1);
}

main(path.resolve(inputFilePath), path.resolve(outFilePath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
