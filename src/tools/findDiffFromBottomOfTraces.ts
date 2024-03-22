import * as path from "path";
import * as fsp from "fs/promises";

type SpanType = "equal" | "diff";

type Span = {
  startA: number;
  endA: number;
  startB: number;
  endB: number;
  type: SpanType;
};

function findSpan(
  linesA: string[],
  linesB: string[],
  ia: number,
  ib: number,
  type: SpanType
): { span: Span; newIa: number; newIb: number } {
  const endB = ib;
  const endA = ia;

  while (ib > 0) {
    const lineA = linesA[ia].substring(linesA[ia].indexOf(" -- "));
    const lineB = linesB[ib].substring(linesB[ib].indexOf(" -- "));

    if (
      (lineA === lineB && type === "equal") ||
      (lineA !== lineB && type === "diff")
    ) {
      ia -= 1;
      ib -= 1;
    } else {
      return {
        span: {
          startA: ia,
          endA,
          startB: ib,
          endB,
          type,
        },
        newIa: ia,
        newIb: ib,
      };
    }
  }

  return {
    span: {
      startA: ia,
      endA,
      startB: ib,
      endB,
      type,
    },
    newIa: ia,
    newIb: ib,
  };
}

function getNextType(spans: Span[]): SpanType {
  if (spans.length === 0) {
    return "equal";
  }

  if (spans[spans.length - 1].type === "equal") {
    return "diff";
  }

  return "equal";
}

async function main(traceAPath: string, traceBPath: string) {
  const traceA = (await fsp.readFile(traceAPath)).toString();
  const linesA = traceA.split("\n");
  const traceB = (await fsp.readFile(traceBPath)).toString();
  const linesB = traceB.split("\n");

  let ia = linesA.length - 1;
  let ib = linesB.length - 1;

  const spans: Span[] = [];

  while (ib > 0) {
    const { span, newIa, newIb } = findSpan(
      linesA,
      linesB,
      ia,
      ib,
      getNextType(spans)
    );
    spans.push(span);
    ia = newIa;
    ib = newIb;
  }

  for (const span of spans.reverse()) {
    console.log(JSON.stringify(span));
  }
}

const [_tsnode, _findDiffFromBottomOfTraces, traceAPath, traceBPath] =
  process.argv;

if (!traceAPath || !traceBPath) {
  console.error(
    "usage: ts-node findDiffFromBottomOfTraces.ts <trace-a-path> <trace-b-path>"
  );
  process.exit(1);
}

main(path.resolve(traceAPath), path.resolve(traceBPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
