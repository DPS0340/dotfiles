/**
 * @license
 * Copyright 2023 The Go Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

interface Page {
  Charts: ChartData;
}

interface ChartData {
  Programs: Program[];
}

interface Program {
  ID: string;
  Name: string;
  Charts: Chart[];
}

interface Chart {
  ID: string;
  Name: string;
  Type: string;
  Data: Datum[] | null;
}

interface Datum {
  Key: string;
  Value: number;
}

declare const Page: Page;

import * as d3 from "d3";
import * as Plot from "@observablehq/plot";

for (const program of Page.Charts.Programs) {
  for (const counter of program.Charts) {
    switch (counter.Type) {
      case "partition":
        document
          .querySelector(`[data-chart-id="${counter.ID}"]`)
          ?.append(partition(counter));

        break;
      case "histogram":
        document
          .querySelector(`[data-chart-id="${counter.ID}"]`)
          ?.append(histogram(counter));

        break;
      default:
        console.error("unknown chart type");
        break;
    }
  }
}

function partition({ Data, Name }: Chart) {
  Data ??= [];
  return Plot.plot({
    color: {
      type: "ordinal",
      scheme: "Spectral",
    },
    nice: true,
    x: {
      label: Name,
      labelOffset: Number.MAX_SAFE_INTEGER,
      tickRotate: 45,
      domain: Data.map((d) => d.Key),
    },
    y: {
      label: "Frequency",
      domain: [0, 1],
    },
    width: 1024,
    style: "overflow:visible;background:transparent;margin-bottom:3rem;",
    marks: [
      Plot.barY(Data, {
        tip: true,
        fill: (d) => (isNaN(Number(d.Key)) ? d.Key : Number(d.Key)),
        x: (d) => d.Key,
        y: (d) => d.Value,
      }),
      Plot.frame(),
    ],
  });
}

function histogram({ Data }: Chart) {
  Data ??= [];
  const n = 3; // number of facet columns
  const fixKey = (k: string) => (isNaN(Number(k)) ? k : Number(k));
  const keys = Array.from(d3.union(Data.map((d) => fixKey(d.Key))));
  const index = new Map(keys.map((key, i) => [key, i]));
  const fx = (key: string | number) => (index.get(key) ?? 0) % n;
  const fy = (key: string | number) => Math.floor((index.get(key) ?? 0) / n);

  return Plot.plot({
    marginLeft: 60,
    width: 1024,
    grid: true,
    nice: true,
    x: {
      label: "Distribution",
    },
    color: {
      type: "ordinal",
      legend: true,
      scheme: "Spectral",
      label: "Counter",
    },
    y: {
      insetTop: 16,
      domain: [0, 1],
    },
    fx: {
      ticks: [],
    },
    fy: {
      ticks: [],
    },
    style: "background:transparent;",
    marks: [
      Plot.barY(
        Data,
        Plot.binX(
          { y: "proportion-facet", x: "x1", interval: 0.1, cumulative: 1 },
          {
            tip: true,
            fill: (d: Datum) => fixKey(d.Key),
            x: (d: Datum) => d.Value,
            fx: (d: Datum) => fx(fixKey(d.Key)),
            fy: (d: Datum) => fy(fixKey(d.Key)),
          }
        )
      ),
      Plot.text(keys, {
        frameAnchor: "top",
        dy: 3,
        fx,
        fy,
      }),
      Plot.axisX({ anchor: "bottom", tickSpacing: 35 }),
      Plot.axisX({ anchor: "top", tickSpacing: 35 }),
      Plot.frame(),
    ],
  });
}

export {};
