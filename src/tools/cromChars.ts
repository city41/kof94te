export const cromChars: Record<number, string> = {
  0: " ",
  1: ".",
  2: "'",
  [0xfffe]: "\n",
  [0xd]: "\n",
  [0x71]: "-",
  [0x72]: "·",
  [0x74]: ",",
  [0x76]: "?",
  [0x77]: "!",
  [0xffff]: "e",
  [0x4983]: "0",
  [0x4984]: "1",
  [0x4985]: "2",
  [0x4986]: "3",
  [0x4987]: "4",
  [0x4988]: "5",
  [0x4989]: "6",
  [0x498a]: "7",
  [0x498b]: "8",
  [0x498c]: "9",
  [0x498d]: "A",
  [0x498e]: "B",
  [0x498f]: "C",
  [0x4990]: "D",
  [0x4991]: "E",
  [0x4992]: "F",
  [0x4993]: "G",
  [0x4994]: "H",
  [0x4995]: "I",
  [0x4996]: "J",
  [0x4997]: "K",
  [0x4998]: "L",
  [0x4999]: "M",
  [0x499a]: "N",
  [0x499b]: "O",
  [0x499c]: "P",
  [0x499d]: "Q",
  [0x499e]: "R",
  [0x499f]: "S",
  [0x49a0]: "T",
  [0x49a1]: "U",
  [0x49a2]: "V",
  [0x49a3]: "W",
  [0x49a4]: "X",
  [0x49a5]: "Y",
  [0x49a6]: "Z",
  [0x49d7]: "Ú",
  [0x49d8]: "Á",
  [0x49d9]: "É",
  [0x49da]: "Í",
  [0x49db]: "Ń",
  [0x49dc]: "Ó",
  [0x49dd]: "Ñ",
  [0x49de]: "+",
  [0x49df]: "¿",
  [0x49e0]: "¡",
  [0x49e1]: "u",
};

export const charsCrom: Record<string, number> = Object.entries(
  cromChars
).reduce<Record<string, number>>((accum, e) => {
  accum[e[1]] = parseInt(e[0]);
  return accum;
}, {});
