// Copyright 2022 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package test

import (
	"os/exec"
	"strings"
	"testing"

	"golang.org/x/tools/go/packages"
)

func VerifyImports(t *testing.T, allowed ...string) {
	if _, err := exec.LookPath("go"); err != nil {
		t.Skipf("skipping: %v", err)
	}
	cfg := &packages.Config{Mode: packages.NeedImports | packages.NeedDeps}
	pkgs, err := packages.Load(cfg, ".")
	if err != nil {
		t.Fatal(err)
	}
	check := map[string]struct{}{}
	for _, imp := range allowed {
		check[imp] = struct{}{}
	}
	for _, p := range pkgs {
		for _, imp := range p.Imports {
			// this is an approximate stdlib check that is good enough for these tests
			if !strings.ContainsRune(imp.ID, '.') {
				continue
			}
			if _, ok := check[imp.ID]; !ok {
				t.Errorf("include of %s is not allowed", imp.ID)
			}
		}
	}
}
