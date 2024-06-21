import path from "node:path";
import fsp from "node:fs/promises";
import * as mkdirp from "mkdirp";
import { execSync } from "node:child_process";
import {
  PROM_FILE_NAME,
  SROM_FILE_NAME,
  asmTmpDir,
  romTmpDir,
  tmpDir,
} from "./dirs";
import {
  AddressPromFilePathPatch,
  AddressPromPatch,
  RomFileBuffer,
  InlinePatch,
  Patch,
  PatchJSON,
  StringPromPatch,
  AddressPromFileAvatarPathPatch,
} from "./types";
import { doPromPatch } from "./doPromPatch";
import { injectCromTiles } from "./injectCromTiles";
import { clearFixTiles } from "./clearFixTiles";
import { injectTitleBadgeTiles } from "./injectTitleBadgeTiles";

type AvatarMode = "a94" | "a95";

function usage() {
  console.error(
    "usage: ts-node src/patchRom/main.ts <a94 or a95> <patch-jsons...>"
  );
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

function isAddressFileAvatarPathPatch(
  obj: unknown
): obj is AddressPromFileAvatarPathPatch {
  if (!obj) {
    return false;
  }

  if (typeof obj !== "object") {
    return false;
  }

  const p = obj as AddressPromFileAvatarPathPatch;

  return (
    p.type === "prom" &&
    typeof p.a94PatchAsm === "string" &&
    typeof p.a95PatchAsm === "string"
  );
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
    (isAddressFilePathPatch(p) && !isAddressFileAvatarPathPatch(p)) ||
    (isAddressFileAvatarPathPatch(p) && !isAddressFilePathPatch(p))
  );
}

function isPatchJSON(obj: unknown): obj is PatchJSON {
  if (!obj) {
    return false;
  }

  if (Array.isArray(obj)) {
    return false;
  }

  const p = obj as PatchJSON;

  if (typeof p.description !== "string") {
    return false;
  }

  if (!Array.isArray(p.patches)) {
    return false;
  }

  return p.patches.every((patch) => {
    if (isPatch(patch)) {
      return true;
    } else {
      console.error(
        "not a valid patch\n\n",
        JSON.stringify(patch, null, 2),
        "\n\n"
      );
      return false;
    }
  });
}

async function writePatchedZip(
  promData: number[],
  cromBuffers: RomFileBuffer[],
  fixBuffer: RomFileBuffer,
  outputPath: string
): Promise<void> {
  await fsp.writeFile(
    path.resolve(romTmpDir, PROM_FILE_NAME),
    new Uint8Array(promData)
  );

  await fsp.writeFile(
    path.resolve(romTmpDir, SROM_FILE_NAME),
    new Uint8Array(fixBuffer.data)
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

function resolveAvatarPatch(patch: Patch, avatarMode: AvatarMode): Patch {
  if (isAddressFileAvatarPathPatch(patch)) {
    const patchAsm =
      avatarMode === "a94" ? patch.a94PatchAsm : patch.a95PatchAsm;
    return {
      ...patch,
      patchAsm,
    };
  } else {
    return patch;
  }
}

async function hydratePatch(
  patch: Patch,
  jsonDir: string
): Promise<InlinePatch> {
  if (isStringPatch(patch) || isAddressPatch(patch)) {
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

function loadInitialSymbols(
  initialSymbols: Record<string, string> | undefined
): Record<string, number> {
  if (!initialSymbols) {
    return {};
  }

  return Object.entries(initialSymbols).reduce<Record<string, number>>(
    (accum, entry) => {
      return {
        ...accum,
        [entry[0]]: parseInt(entry[1], 16),
      };
    },
    {}
  );
}

async function main(avatarMode: AvatarMode, patchJsonPaths: string[]) {
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
      console.log("patch json", JSON.stringify(patchJson, null, 2));
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

      let symbolTable: Record<string, number> = loadInitialSymbols(
        patchJson.symbols
      );
      const subroutineInsertStart = patchJson.subroutineSpace?.start
        ? parseInt(patchJson.subroutineSpace.start, 16)
        : 0;
      let subroutineInsertEnd = patchJson.subroutineSpace?.end
        ? parseInt(patchJson.subroutineSpace.end, 16)
        : 0;

      console.log(patchJson.description);

      for (const patch of patchJson.patches) {
        if (patch.skip) {
          console.log(
            "SKIPPING!",
            patch.symbol ?? patch.description ?? "(unknown)"
          );
          continue;
        }
        console.log(
          "next patch",
          patch.symbol ?? patch.description ?? "(unknown)"
        );

        try {
          const hydratedPatch = await hydratePatch(
            resolveAvatarPatch(patch, avatarMode),
            jsonDir
          );
          const result = await doPromPatch(
            symbolTable,
            patchedPromData,
            subroutineInsertEnd,
            hydratedPatch
          );
          patchedPromData = result.patchedPromData;
          subroutineInsertEnd = result.subroutineInsertEnd;
          symbolTable = result.symbolTable;

          if (
            !!patchJson.subroutineSpace &&
            subroutineInsertEnd < subroutineInsertStart
          ) {
            throw new Error("patch used up all of the subroutine space");
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

  try {
    const cromBuffers = await injectCromTiles();
    const finalCromBuffers = await injectTitleBadgeTiles(cromBuffers);
    const fixBuffer = await clearFixTiles();

    const writePath = path.resolve(mameDir, "kof94.zip");
    await writePatchedZip(
      flippedBackPatch,
      finalCromBuffers,
      fixBuffer,
      writePath
    );

    console.log("wrote patched rom to", writePath);
  } catch (e) {
    console.error(e);
  }
}

const [_tsNode, _main, avatarMode, ...patchJsonInputPaths] = process.argv;

if (!avatarMode || !patchJsonInputPaths?.length) {
  usage();
}

if (avatarMode !== "a94" && avatarMode !== "a95") {
  usage();
}

const finalPatchJsonPaths = patchJsonInputPaths.map((pjip) =>
  path.resolve(process.cwd(), pjip)
);

main(avatarMode as AvatarMode, finalPatchJsonPaths).catch((e) => console.error);

export { isStringPatch };
