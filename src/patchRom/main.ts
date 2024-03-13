import path from "node:path";
import fsp from "node:fs/promises";
import * as mkdirp from "mkdirp";
import { execSync } from "node:child_process";
import { PROM_FILE_NAME, asmTmpDir, romTmpDir, tmpDir } from "./dirs";
import {
  AddressPromFilePathPatch,
  AddressPromPatch,
  CromBuffer,
  CromPatch,
  InlinePatch,
  Patch,
  PatchJSON,
  StringPromPatch,
} from "./types";
import { doPromPatch } from "./doPromPatch";
import { createCromBytes } from "./createCromBytes";
import { insertIntoCrom } from "./insertIntoCrom";

function usage() {
  console.error("usage: ts-node src/patchRom/main.ts <patch-json>");
  process.exit(1);
}

async function getProm(zipPath: string): Promise<Buffer> {
  const cmd = `unzip -o ${zipPath} -d ${romTmpDir}`;
  const cwd = path.resolve();
  console.log("About to do", cmd, "in", cwd);
  const output = execSync(cmd, { cwd });
  console.log(output.toString());

  return fsp.readFile(path.resolve(romTmpDir, PROM_FILE_NAME));
}

async function getCrom(zipPath: string, cromFile: string): Promise<CromBuffer> {
  execSync(`unzip -o ${zipPath} -d ${romTmpDir}`);

  return {
    fileName: cromFile,
    data: Array.from(await fsp.readFile(path.resolve(romTmpDir, cromFile))),
  };
}

function flipBytes(data: number[]): number[] {
  for (let i = 0; i < data.length; i += 2) {
    const byte = data[i];
    data[i] = data[i + 1];
    data[i + 1] = byte;
  }

  return data;
}

function isStringPatch(obj: unknown): obj is StringPromPatch {
  if (!obj) {
    return false;
  }

  if (typeof obj !== "object") {
    return false;
  }

  const p = obj as StringPromPatch;

  return p.type === "prom" && p.string === true && typeof p.value === "string";
}

function isAddressPatch(obj: unknown): obj is AddressPromPatch {
  if (!obj) {
    return false;
  }

  if (typeof obj !== "object") {
    return false;
  }

  const p = obj as AddressPromPatch;

  return p.type === "prom" && Array.isArray(p.patchAsm);
}

function isAddressFilePathPatch(obj: unknown): obj is AddressPromFilePathPatch {
  if (!obj) {
    return false;
  }

  if (typeof obj !== "object") {
    return false;
  }

  const p = obj as AddressPromPatch;

  return p.type === "prom" && typeof p.patchAsm === "string";
}

function isCromPatch(obj: unknown): obj is CromPatch {
  if (!obj) {
    return false;
  }

  if (typeof obj !== "object") {
    return false;
  }

  const p = obj as CromPatch;

  return (
    p.type === "crom" &&
    typeof p.destStartingIndex === "string" &&
    typeof p.imgFile === "string" &&
    typeof p.paletteFile === "string"
  );
}

function isPatch(obj: unknown): obj is Patch {
  if (!obj) {
    return false;
  }

  if (typeof obj !== "object") {
    return false;
  }

  const p = obj as Patch;

  return (
    isStringPatch(p) ||
    isAddressPatch(p) ||
    isAddressFilePathPatch(p) ||
    isCromPatch(p)
  );
}

function isPatchJSON(obj: unknown): obj is PatchJSON {
  if (!obj) {
    return false;
  }

  if (Array.isArray(obj)) {
    return true;
  }

  const p = obj as PatchJSON;

  if (typeof p.description !== "string") {
    return false;
  }

  if (!Array.isArray(p.patches)) {
    return false;
  }

  return p.patches.every(isPatch);
}

async function writePatchedZip(
  promData: number[],
  cromBuffers: CromBuffer[],
  outputPath: string
): Promise<void> {
  await fsp.writeFile(
    path.resolve(romTmpDir, PROM_FILE_NAME),
    new Uint8Array(promData)
  );

  for (const cromBuffer of cromBuffers) {
    await fsp.writeFile(
      path.resolve(romTmpDir, cromBuffer.fileName),
      new Uint8Array(cromBuffer.data)
    );
  }

  const cmd = "zip kof94.zip *";
  console.log("about to execute", cmd, "in", romTmpDir);
  const output = execSync(cmd, { cwd: romTmpDir });
  console.log(output.toString());

  const cpCmd = `cp kof94.zip ${outputPath}`;
  console.log("about to execute", cpCmd, "in", romTmpDir);
  const output2 = execSync(cpCmd, { cwd: romTmpDir });
  console.log(output2.toString());
}

async function hydratePatch(
  patch: Patch,
  jsonDir: string
): Promise<InlinePatch> {
  if (isStringPatch(patch) || isCromPatch(patch) || isAddressPatch(patch)) {
    return patch;
  } else if (isAddressFilePathPatch(patch)) {
    const asmPath = path.resolve(jsonDir, patch.patchAsm);
    const asmString = (await fsp.readFile(asmPath)).toString();

    return {
      ...patch,
      patchAsm: asmString.split("\n"),
    };
  } else {
    throw new Error(`unexpected patch: ${JSON.stringify(patch)}`);
  }
}

async function main(patchJsonPaths: string[]) {
  await fsp.rm(tmpDir, {
    recursive: true,
    force: true,
    maxRetries: 5,
    retryDelay: 1000,
  });
  mkdirp.sync(romTmpDir);
  mkdirp.sync(asmTmpDir);

  const flippedPromBuffer = await getProm(path.resolve("./kof94.zip"));
  const flippedPromData = Array.from(flippedPromBuffer);
  const promData = flipBytes(flippedPromData);

  let patchedPromData = [...promData];

  await fsp.writeFile("/home/matt/tmp/p1.bin", new Uint8Array(patchedPromData));

  let cromBuffers = [
    await getCrom(path.resolve("./kof94.zip"), "055-c1.c1"),
    await getCrom(path.resolve("./kof94.zip"), "055-c2.c2"),
    await getCrom(path.resolve("./kof94.zip"), "055-c3.c3"),
    await getCrom(path.resolve("./kof94.zip"), "055-c4.c4"),
    await getCrom(path.resolve("./kof94.zip"), "055-c5.c5"),
    await getCrom(path.resolve("./kof94.zip"), "055-c6.c6"),
    await getCrom(path.resolve("./kof94.zip"), "055-c7.c7"),
    await getCrom(path.resolve("./kof94.zip"), "055-c8.c8"),
  ];

  for (const patchJsonPath of patchJsonPaths) {
    const jsonDir = path.dirname(patchJsonPath);
    console.log("Starting patch", patchJsonPath);

    let patchJson: unknown;
    try {
      patchJson = require(patchJsonPath);
    } catch (e) {
      console.error("Error occured loading the patch", e);
    }

    if (!isPatchJSON(patchJson)) {
      console.error(
        "The JSON at",
        patchJsonPath,
        ", is not a valid patch file"
      );
      usage();
    } else {
      if (
        patchJson.patches.some(
          (p) => isAddressPatch(p) && p.subroutine == true
        ) &&
        !patchJson.subroutineSpace
      ) {
        console.error(
          "This patch contains subroutine patches, but did not specify subroutineSpace"
        );
        process.exit(1);
      }
      let symbolTable: Record<string, number> = {};
      const subroutineInsertStart = patchJson.subroutineSpace?.start
        ? parseInt(patchJson.subroutineSpace.start, 16)
        : 0;
      let subroutineInsertEnd = patchJson.subroutineSpace?.end
        ? parseInt(patchJson.subroutineSpace.end, 16)
        : 0;

      console.log(patchJson.description);

      for (const patch of patchJson.patches) {
        if (patch.skip) {
          console.log("SKIPPING!", patch.description);
          continue;
        }

        try {
          if (patch.type === "prom") {
            const hydratedPatch = await hydratePatch(patch, jsonDir);
            const result = await doPromPatch(
              symbolTable,
              patchedPromData,
              subroutineInsertEnd,
              hydratedPatch
            );
            patchedPromData = result.patchedPromData;
            subroutineInsertEnd = result.subroutineInsertEnd;
            symbolTable = result.symbolTable;

            if (subroutineInsertEnd < subroutineInsertStart) {
              throw new Error("patch used up all of the subroutine space");
            }
          } else if (patch.type === "crom") {
            console.log(patch.description);
            console.log("creating crom bytes for", patch.imgFile);
            const { oddCromBytes, evenCromBytes } = createCromBytes(
              path.resolve(jsonDir, patch.imgFile),
              path.resolve(jsonDir, patch.paletteFile)
            );

            const startingCromTileIndex = parseInt(patch.destStartingIndex, 16);
            const tileIndexes: number[] = [];
            const tileCount = oddCromBytes.length / 64;
            for (let t = 0; t < tileCount; ++t) {
              tileIndexes.push(startingCromTileIndex + t);
            }

            console.log(
              "inserting crom data into croms at tile indexes:",
              tileIndexes.map((ti) => ti.toString(16)).join(",")
            );
            cromBuffers = await insertIntoCrom(
              oddCromBytes,
              evenCromBytes,
              parseInt(patch.destStartingIndex, 16),
              cromBuffers
            );

            console.log("\n\n");
          }
        } catch (e) {
          console.error(e);
          process.exit(1);
        }

        console.log("\n\n");
      }
      console.log(
        `after patching, ${
          subroutineInsertEnd - subroutineInsertStart
        } bytes left for subroutines`
      );

      console.log("final symbols");
      for (const entry of Object.entries(symbolTable)) {
        console.log(entry[0], entry[1].toString(16));
      }
    }
  }

  const flippedBackPatch = flipBytes(patchedPromData);

  const mameDir = process.env.MAME_ROM_DIR;

  if (!mameDir?.trim()) {
    throw new Error("MAME_ROM_DIR env variable is not set");
  }

  const writePath = path.resolve(mameDir, "kof94.zip");
  await writePatchedZip(flippedBackPatch, cromBuffers, writePath);

  console.log("wrote patched rom to", writePath);
}

const patchJsonInputPaths = process.argv.slice(2);

if (!patchJsonInputPaths?.length) {
  usage();
}

const finalPatchJsonPaths = patchJsonInputPaths.map((pjip) =>
  path.resolve(process.cwd(), pjip)
);

main(finalPatchJsonPaths).catch((e) => console.error);

export { isStringPatch, isCromPatch };
