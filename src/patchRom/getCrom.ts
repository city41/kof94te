import path from "node:path";
import fsp from "node:fs/promises";
import { execSync } from "node:child_process";
import { romTmpDir } from "./dirs";
import { CromBuffer } from "./types";

async function getCrom(zipPath: string, cromFile: string): Promise<CromBuffer> {
  execSync(`unzip -o ${zipPath} -d ${romTmpDir}`);

  return {
    fileName: cromFile,
    data: Array.from(await fsp.readFile(path.resolve(romTmpDir, cromFile))),
  };
}

export { getCrom };
