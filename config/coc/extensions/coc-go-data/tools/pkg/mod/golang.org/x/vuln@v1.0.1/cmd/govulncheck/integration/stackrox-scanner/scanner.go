// Copyright 2022 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
	"log"
	"os"

	"golang.org/x/vuln/cmd/govulncheck/integration/internal/integration"
)

const usage = `test helper for examining the output of running govulncheck on
stackrox-io/scanner binary (https://quay.io/repository/stackrox-io/scanner).

Example usage: ./stackrox-scanner [path to output file]
`

func main() {
	if len(os.Args) != 2 {
		log.Fatal("Incorrect number of expected command line arguments", usage)
	}
	out := os.Args[1]
	want := map[string]bool{
		"golang.org/x/net/http2":       true,
		"golang.org/x/net/http2/hpack": true,
	}

	if err := integration.CompareNonStdVulns(out, want); err != nil {
		log.Fatal(err)
	}
}
