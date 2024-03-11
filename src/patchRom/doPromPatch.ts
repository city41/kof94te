import path from "node:path";
import fsp from "node:fs/promises";
import * as mkdirp from "mkdirp";
import { execSync } from "node:child_process";
import { AddressPromPatch, Patch } from "./types";
import { asmTmpDir } from "./dirs";
import { isCromPatch, isStringPatch } from "./main";

function hexDump(bytes: number[]): string {
  return bytes.map((b) => b.toString(16)).join(" ");
}

async function assemble(asm: string[]): Promise<number[]> {
  mkdirp.sync(asmTmpDir);
  const inputAsmPath = path.resolve(asmTmpDir, "tmp.asm");
  const outputBinPath = path.resolve(asmTmpDir, "tmp.bin");

  const asmSrc = asm.map((a) => `\t${a}`).join("\n");
  console.log("asm\n", asmSrc);

  console.log("writing asm to", inputAsmPath);
  await fsp.writeFile(inputAsmPath, asmSrc);

  const assembleCommand = `./clownassembler/clownassembler -i ${inputAsmPath} -o ${outputBinPath}`;
  console.log("about to assemble", assembleCommand);
  execSync(assembleCommand);

  const binBuffer = await fsp.readFile(outputBinPath);

  console.log("binary length", binBuffer.length);

  return Array.from(binBuffer);
}

async function replaceAt(
  data: number[],
  address: string,
  asm: string[]
): Promise<number[]> {
  const asmBytes = await assemble(asm);

  console.log("asmBytes", hexDump(asmBytes));

  const index = parseInt(address, 16);
  console.log(`splicing in at 0x${index.toString(16)}`);
  console.log(
    "existing data",
    data
      .slice(index, index + asmBytes.length)
      .map((b) => b.toString(16))
      .join(" ")
  );
  data.splice(index, asmBytes.length, ...asmBytes);

  return data;
}

function formJsrAsm(numBytesToReplace: number, jsrAddress: number): string[] {
  if (numBytesToReplace < 6) {
    throw new Error(
      `formJsr: not enough room. Need 6 bytes, only have ${numBytesToReplace}`
    );
  }

  if (numBytesToReplace % 1 !== 0) {
    throw new Error(
      `formJsr: bytes to replace must be an even count, got ${numBytesToReplace}`
    );
  }

  const numNops = (numBytesToReplace - 6) / 2;

  const asmNops = new Array(numNops).fill(0).map(() => "nop");
  return asmNops.concat(`jsr $${jsrAddress.toString(16)}`);
}

function stringToassembly(str: string): string[] {
  return str
    .split("")
    .map((c) => {
      const asciiVal = c.charCodeAt(0);

      return `dc.b $${asciiVal.toString(16)} ; ${c} in ascii`;
    })
    .concat("dc.b $0  ; null terminator");
}

async function addStringToProm(
  data: number[],
  subroutineInsertEnd: number,
  str: string
): Promise<{ patchedPromData: number[]; subroutineInsertEnd: number }> {
  const subroutineBytes = await assemble(stringToassembly(str));
  console.log(
    "addStringToProm: subroutinebytes for",
    str,
    hexDump(subroutineBytes)
  );

  let subroutineStartAddress = subroutineInsertEnd - subroutineBytes.length;

  if (subroutineStartAddress & 1) {
    // the 68k cannot address odd bytes, need to back off one to get an even address
    subroutineStartAddress -= 1;
  }

  console.log(
    `Adding str (${str}) at address $${subroutineStartAddress.toString(16)}`
  );

  data.splice(
    subroutineStartAddress,
    subroutineBytes.length,
    ...subroutineBytes
  );

  return {
    patchedPromData: data,
    subroutineInsertEnd: subroutineStartAddress,
  };
}

async function replaceWithSubroutine(
  data: number[],
  subroutineInsertEnd: number,
  patch: AddressPromPatch
): Promise<{ patchedPromData: number[]; subroutineInsertEnd: number }> {
  const subroutineBytes = await assemble(patch.patchAsm);
  console.log(
    "replaceWithSubroutine: subroutinebytes",
    hexDump(subroutineBytes)
  );

  let subroutineStartAddress = subroutineInsertEnd - subroutineBytes.length;

  if (subroutineStartAddress & 1) {
    // the 68k cannot address odd bytes, need to back off one to get an even address
    subroutineStartAddress -= 1;
  }

  let jsrAsm;
  let jsrAddedData: number[];

  if ("address" in patch && typeof patch.address === "string") {
    jsrAsm = await formJsrAsm(6, subroutineStartAddress);
    jsrAddedData = await replaceAt(data, patch.address, jsrAsm);
  } else {
    console.log(
      "subroutine has no address for jsr specified, just inserting it into rom"
    );
    console.log("at", subroutineStartAddress.toString(16));
    jsrAddedData = data;
  }

  console.log(
    `replacedWithSubroutine: splicing in subroutine at 0x${subroutineStartAddress.toString(
      16
    )}`
  );
  jsrAddedData.splice(
    subroutineStartAddress,
    subroutineBytes.length,
    ...subroutineBytes
  );

  return {
    patchedPromData: jsrAddedData,
    subroutineInsertEnd: subroutineStartAddress,
  };
}

async function replace(
  data: number[],
  patch: AddressPromPatch
): Promise<number[]> {
  if ("address" in patch) {
    if (typeof patch.address !== "string") {
      throw new Error("replace: a non subroutine patch requires an address");
    }
    return replaceAt(data, patch.address, patch.patchAsm);
  } else {
    throw new Error(`replace, unexpected patch: ${JSON.stringify(patch)}`);
  }
}

function applySymbolsToLine(
  symbolTable: Record<string, number>,
  line: string
): string {
  return Object.entries(symbolTable).reduce((l, e) => {
    return l.replace(e[0], e[1].toString(16));
  }, line);
}

function applySymbols(
  symbolTable: Record<string, number>,
  patch: AddressPromPatch
): AddressPromPatch {
  return {
    ...patch,
    patchAsm: patch.patchAsm.map((line) =>
      applySymbolsToLine(symbolTable, line)
    ),
  };
}

async function doPromPatch(
  symbolTable: Record<string, number>,
  promData: number[],
  subroutineInsertEnd: number,
  patch: Patch
): Promise<{
  patchedPromData: number[];
  subroutineInsertEnd: number;
  symbolTable: Record<string, number>;
}> {
  if (isCromPatch(patch)) {
    throw new Error("doPromPatch: given a crom patch");
  }

  console.log("applying patch");
  console.log(patch.description ?? "(patch has no description)");

  let result: { patchedPromData: number[]; subroutineInsertEnd: number };

  if (isStringPatch(patch)) {
    result = await addStringToProm(promData, subroutineInsertEnd, patch.value);
  } else if (patch.subroutine) {
    patch = applySymbols(symbolTable, patch);
    result = await replaceWithSubroutine(promData, subroutineInsertEnd, patch);
  } else {
    if (!patch.address) {
      throw new Error(
        "a prom patch that isnt a subroutine must have an address"
      );
    }
    patch = applySymbols(symbolTable, patch);
    result = {
      patchedPromData: await replace(promData, patch),
      subroutineInsertEnd,
    };
  }

  if (patch.symbol) {
    symbolTable = {
      ...symbolTable,
      [patch.symbol]: result.subroutineInsertEnd,
    };
  }

  return { ...result, symbolTable };
}

export { doPromPatch };
