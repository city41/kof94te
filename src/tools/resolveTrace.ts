import * as path from "path";
import * as fsp from "fs/promises";

type RegisterMap = Record<string, number>;

// D0=72DD0371 D1=1B D2=749D0370 D3=FFFF D4=8402E40 D5=80218000 D6=842184B9 D7=FFFF A0=37046 A1=D00034 A2=4ABB4 A3=108F6C A4=108584 A5=108000 A6=108E3C
function createRegisterMap(
  registerS: string,
  rawAddress?: string
): RegisterMap {
  const registerPairs = registerS.split(" ");

  let address = 0;

  if (rawAddress) {
    address = parseInt(rawAddress.replace(":", ""), 16);
  }

  return registerPairs.reduce<RegisterMap>(
    (accum, rp) => {
      const [reg, val] = rp.split("=");

      return {
        ...accum,
        [reg]: parseInt(val, 16),
      };
    },
    { PC: address + 2 }
  );
}

function parseDasmLiteral(l: string): number {
  const multiplier = l.startsWith("-") ? -1 : 1;

  l = l.replace(/-?\$/, "");

  return parseInt(l, 16) * multiplier;
}

function resolveRegister(
  regS: string,
  registerMap: RegisterMap
): number | undefined {
  const [reg, sizeModifier] = regS.split(".");

  const regValue = registerMap[reg];

  if (regValue === undefined) {
    return undefined;
  }

  switch (sizeModifier) {
    case "b":
      return regValue & 0xff;
    case "w":
      return regValue & 0xffff;
    case "l":
    default:
      return regValue;
  }
}

function getOpcodeSizeMask(opcode: string): number {
  const [_opcodeRoot, size] = opcode.split(".");

  switch (size) {
    case "b":
      return 0xff;
    case "w":
      return 0xffff;
    case "l":
    default:
      return 0xffffffff;
  }
}

function resolveParam(
  param: string,
  pos: number,
  total: number,
  opcode: string,
  registerMap: RegisterMap
): string {
  // chop off the trailing comma, if any
  param = param.replace(/,$/, "");

  const opcodeSizeMask = pos === 1 ? getOpcodeSizeMask(opcode) : 0xffffffff;

  if (registerMap[param] && pos < total) {
    return `$${(registerMap[param] & opcodeSizeMask).toString(16)}`;
  }

  if (param.startsWith("(") && param.endsWith(")")) {
    // chop off the parens
    param = param.substring(1);
    param = param.substring(0, param.length - 1);

    if (param.includes(",")) {
      debugger;
      // (-$8000,A5) or (A1,D7.w)
      const [leftS, rightS] = param.split(",");
      const left =
        resolveRegister(leftS, registerMap) ?? parseDasmLiteral(leftS);
      const right =
        resolveRegister(rightS, registerMap) ?? parseDasmLiteral(rightS);

      return `$${(left + right).toString(16)}`;
    } else {
      // (A0)
      const val = resolveRegister(param, registerMap);

      if (val === undefined) {
        throw new Error(`Failed to find a value for ${param}`);
      }

      return `$${val.toString(16)}`;
    }
  }

  // likely just a constant
  return param;
}

function removeDuplicateSpaces(s: string): string {
  return s.replace(/\s+/g, " ");
}

function resolveLine(
  l: string,
  nextL: string,
  indentDepth: number
): { resolvedLine: string; indentDepth: number } {
  l = removeDuplicateSpaces(l);
  nextL = removeDuplicateSpaces(nextL);

  const [line, comment] = l.split(" ; ");

  const [registerS, asmS] = line.split(" -- ");
  const [rawAddress, opcode, ...params] = asmS.split(" ");
  const address = rawAddress.replace(":", "");

  let nextIndentDepth = indentDepth;
  if (opcode === "jsr" || opcode === "bsr") {
    nextIndentDepth += 1;
  }
  if (opcode === "rts") {
    // since a trace can start at any point, jsr/bsr <-> rts
    // calls don't always pair up
    nextIndentDepth = Math.max(0, nextIndentDepth - 1);
  }

  const registerMap = createRegisterMap(registerS, address);
  const [nextRegisterS] = nextL.split(" -- ");
  const nextRegisterMap = createRegisterMap(nextRegisterS);

  const resolvedParams = params.map((p, i, a) =>
    resolveParam(p, i + 1, a.length, opcode, registerMap)
  );

  const nonResolvedLine = [opcode, ...params].join(" ");
  const indent = new Array(indentDepth * 1).fill(".").join("");

  const lastResolvedParam = resolvedParams[resolvedParams.length - 1];
  const registerResult =
    typeof nextRegisterMap[lastResolvedParam] === "number"
      ? `    result: $${nextRegisterMap[lastResolvedParam].toString(16)}`
      : "";

  const resolvedLine = [
    address,
    "|",
    indent,
    opcode,
    resolvedParams.join(", "),
  ].join(" ");

  const resultSpacerCount = 70 - resolvedLine.length;
  if (resultSpacerCount < 0) {
    throw new Error(
      `resultSpacerCount is negative, resolvedLine.length: ${resolvedLine.length}`
    );
  }

  const resultSpacer = new Array(resultSpacerCount).fill(" ").join("");
  const commentSpacer = comment ? " ; " : "";

  const fullResolvedLine = `${resolvedLine}${resultSpacer}${registerResult}`;

  const unresolvedSpacerCount = 120 - fullResolvedLine.length;
  if (unresolvedSpacerCount < 0) {
    throw new Error(
      `unresolvedSpacerCount is negative, fullResolvedLine.length: ${fullResolvedLine.length}`
    );
  }
  const unresolvedSpacer = new Array(unresolvedSpacerCount).fill(" ").join("");

  const finalResolvedLine = `${resolvedLine}${resultSpacer}${registerResult}${unresolvedSpacer} | ${nonResolvedLine}${commentSpacer}${
    comment ?? ""
  }`;

  return {
    resolvedLine: finalResolvedLine,
    indentDepth: nextIndentDepth,
  };
}

async function main(tracePath: string) {
  const trace = (await fsp.readFile(tracePath)).toString();
  const lines = trace.split("\n").filter((l) => l.trim() !== "");

  let indentDepth = 0;
  const resolvedLines: string[] = [];

  for (let i = 0; i < lines.length - 1; ++i) {
    const line = lines[i];
    const nextLine = lines[i + 1];
    try {
      const result = resolveLine(line, nextLine, indentDepth);
      indentDepth = result.indentDepth;
      resolvedLines.push(result.resolvedLine);
    } catch (e) {
      console.error("resolve fail at line", i, e);
      console.log("line\n", line);
      throw e;
    }
  }

  await fsp.writeFile(`${tracePath}.resolved.txt`, resolvedLines.join("\n"));
}

const [_tsnode, _resolveTrace, tracePath] = process.argv;

if (!tracePath) {
  console.error("usage: ts-node resolveTrace.ts <trace-path>");
  process.exit(1);
}

main(path.resolve(tracePath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
