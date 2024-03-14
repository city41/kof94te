import * as path from "path";
import * as fsp from "fs/promises";

function toHtml(lineNumber: number, line: string, highlight: boolean): string {
  const className = highlight ? `"line highlight"` : `"line"`;
  const footer = highlight ? "<-" : "";
  return `<div class=${className}><pre>${lineNumber}| ${line} ${footer}</pre></div>`;
}

async function main(tracePath: string, regexS: string) {
  const trace = (await fsp.readFile(tracePath)).toString();
  const lines = trace.split("\n").filter((l) => l.trim() !== "");

  const htmlLines = lines.map((l, i) => {
    const r = new RegExp(regexS);
    // ignore the address when matching
    const highlight = !!r.exec(l.substring(8));

    return toHtml(i + 1, l, highlight);
  });

  const html = `
  <!doctype html>
  <html>
  <head>
  <style>
  body {
    background: black;
  }
  .line {
    color: #999;
    margin: 0;
  }
  .line.highlight {
    color: white;
  }

  .line pre {
    margin: 0;
  }
  </style>
  </head>
  <body>
  ${htmlLines.join("\n")}
  </body>
  </html>
  `;

  await fsp.writeFile(`${tracePath}.${regexS}.html`, html);
}

const [_tsnode, _highlightTraceLines, tracePath, regexS] = process.argv;

if (!tracePath || !regexS) {
  console.error("usage: ts-node highlightTraceLines.ts <trace-path> <regex>");
  process.exit(1);
}

main(path.resolve(tracePath), regexS)
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
