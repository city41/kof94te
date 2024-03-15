export type BasePatch = {
  type: "crom" | "prom";
  description?: string;
  skip?: boolean;
};

export type CromPatch = BasePatch & {
  type: "crom";
  imgFile: string;
  paletteFile: string;
  destStartingIndex: string;
};

export type CromBuffer = {
  fileName: string;
  data: number[];
};

export type BasePromPatch = BasePatch & {
  type: "prom";
  symbol?: string;
};

export type AddressPromPatch = BasePromPatch & {
  address?: string;
  subroutine?: boolean;
  patchAsm: string[];
};

export type AddressPromFilePathPatch = BasePromPatch & {
  address?: string;
  subroutine?: boolean;
  patchAsm: string;
};

export type StringPromPatch = BasePromPatch & {
  string: true;
  value: string;
};

export type DataPromPatch = BasePromPatch & {
  data: true;
  value: string[];
};

export type Patch =
  | AddressPromPatch
  | AddressPromFilePathPatch
  | StringPromPatch
  | DataPromPatch
  | CromPatch;

export type InlinePatch =
  | AddressPromPatch
  | StringPromPatch
  | DataPromPatch
  | CromPatch;

export type SubroutineSpace = {
  start: string;
  end: string;
};

export type PatchJSON = {
  description: string;
  patches: Patch[];
  subroutineSpace?: SubroutineSpace;
};
