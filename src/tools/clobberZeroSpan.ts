import * as path from "path";
import * as fsp from "fs/promises";
import { execSync } from "node:child_process";
import * as mkdirp from "mkdirp";
import { PROM_FILE_NAME, romTmpDir, tmpDir } from "./dirs";

async function getProm(zipPath: string): Promise<Buffer> {
  execSync(`unzip -o ${zipPath} -d ${romTmpDir}`);

  return fsp.readFile(path.resolve(romTmpDir, PROM_FILE_NAME));
}

async function writePatchedZip(
  promData: number[],
  outputPath: string
): Promise<void> {
  await fsp.writeFile(
    path.resolve(romTmpDir, PROM_FILE_NAME),
    new Uint8Array(promData)
  );

  const cmd = "zip kof94.zip *";
  console.log("about to execute", cmd);
  const output = execSync(cmd, { cwd: romTmpDir });
  console.log(output.toString());

  const cpCmd = `cp kof94.zip ${outputPath}`;
  console.log("about to execute", cpCmd);
  const output2 = execSync(cpCmd, { cwd: romTmpDir });
  console.log(output2.toString());
}

async function main(zipPath: string, start: number, end: number) {
  await fsp.rm(tmpDir, {
    recursive: true,
    force: true,
    maxRetries: 5,
    retryDelay: 1000,
  });
  mkdirp.sync(romTmpDir);

  const buffer = await getProm(zipPath);

  const patchedProm = Array.from(buffer);

  for (let i = start; i < end; ++i) {
    if (patchedProm[i] !== 0) {
      throw new Error(
        `This range contains a non zero at ${i}: ${patchedProm[i]}`
      );
    }
    patchedProm[i] = Math.floor(Math.random() * 255) & 0xff;
  }

  const mameDir = process.env.MAME_ROM_DIR;

  if (!mameDir?.trim()) {
    throw new Error("MAME_ROM_DIR env variable is not set");
  }

  const writePath = path.resolve(mameDir, "kof94.zip");
  await writePatchedZip(patchedProm, writePath);
  console.log("wrote patched rom to", writePath);
  console.log(`clobbered ${(end - start) / 1024}kb`);
}

const [_tsnode, _clobberZeroSpan, zipPath, startS, endS] = process.argv;

if (!zipPath || !startS || !endS) {
  console.error(
    "usage: ts-node clobberZeroSpan.ts <rom-zip-path> <start> <end>"
  );
  process.exit(1);
}

const start = parseInt(startS, 16);
const end = parseInt(endS, 16);

if (isNaN(start)) {
  console.error("invalid starting address", start);
  process.exit(1);
}

if (isNaN(end)) {
  console.error("invalid ending address", end);
  process.exit(1);
}

main(path.resolve(zipPath), start, end)
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
