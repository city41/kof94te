const characters = [
  "Heidern",
  "Ralf",
  "Clark",
  "Athena Asamiya",
  "Sie Kensou",
  "Chin Gentsai",
  "Kyo Kusanagi",
  "Benimaru N.",
  "Goro Daimon",
  "Heavy D!",
  "Lucky Glauber",
  "Brian Battler",
  "Kim Kaphwan",
  "Chang Koehan",
  "Choi Bounge",
  "Terry Bogard",
  "Andy Bogard",
  "Joe Higashi",
  "Ryo Sakazki",
  "Robert Garcia",
  "Takuma Sakazaki",
  "Yuri Sakazaki",
  "Mai Shiranui",
  "King",
  "Debug Rugal",
  "", // full form Rugal, never used, intentionally left blank
  "Character Roulette",
  "Team Roulette",
];

const p1Str = characters.reduce((accum, c) => {
  const neededSpaces = 18 - c.length;
  const spaces = new Array(neededSpaces).fill(" ").join("");

  return `${accum}${c.toUpperCase()}${spaces}`;
}, "");

const p2Str = characters.reduce((accum, c) => {
  const neededSpaces = 18 - c.length;
  const spaces = new Array(neededSpaces).fill(" ").join("");

  return `${accum}${spaces}${c.toUpperCase()}`;
}, "");

console.log("p1 str");
console.log(`"value": "${p1Str}",`);
console.log("p2 str");
console.log(`"value": "${p2Str}",`);
