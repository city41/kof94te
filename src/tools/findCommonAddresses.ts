import * as path from "path";
import * as fsp from "fs/promises";

type AddressFile = {
  path: string;
  addresses: number[];
};

function getAddress(l: string): number {
  const rawAddress = l.substring(0, 6);

  return parseInt(rawAddress, 16);
}

async function main(memTextPaths: string[]) {
  const addressFiles: Array<AddressFile> = [];

  for (const memTextPath of memTextPaths) {
    const m = (await fsp.readFile(memTextPath)).toString();
    addressFiles.push({
      path: memTextPath,
      addresses: m.split("\n").map((l) => getAddress(l)),
    });
  }

  const firstAddressFile = addressFiles[0];

  const addressessInAll: number[] = [];

  for (const address of firstAddressFile.addresses) {
    let foundInAll = true;
    for (let i = 1; i < addressFiles.length; ++i) {
      if (!addressFiles[i].addresses.includes(address)) {
        foundInAll = false;
        break;
      }
    }

    if (foundInAll) {
      addressessInAll.push(address);
    }
  }

  console.log(
    "found in all",
    addressessInAll.map((a) => a.toString(16)).join(",")
  );
}

const [_tsnode, _findCommonAddresses, ...memTxtFiles] = process.argv;

if (!memTxtFiles?.length || memTxtFiles.length === 1) {
  console.error(
    "usage: ts-node findCommonAddresses.ts <mem-txt-file-1> <mem-txt-file-2>..."
  );
  process.exit(1);
}

main(memTxtFiles.map((mtf) => path.resolve(mtf)))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
