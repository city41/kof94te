import os from "node:os";
import path from "node:path";

export const tmpDir = path.resolve(os.tmpdir(), "kof94te");
export const romTmpDir = path.resolve(tmpDir, "rom");
export const asmTmpDir = path.resolve(tmpDir, "asm");
export const PROM_FILE_NAME = "055-p1.p1";
export const SROM_FILE_NAME = "055-s1.s1";
