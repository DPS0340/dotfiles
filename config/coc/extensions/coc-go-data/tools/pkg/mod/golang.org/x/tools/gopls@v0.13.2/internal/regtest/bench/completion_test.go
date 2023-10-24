// Copyright 2020 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bench

import (
	"fmt"
	"sync/atomic"
	"testing"

	"golang.org/x/tools/gopls/internal/lsp/fake"
	"golang.org/x/tools/gopls/internal/lsp/protocol"
	. "golang.org/x/tools/gopls/internal/lsp/regtest"
)

// TODO(rfindley): update these completion tests to run on multiple repos.

type completionBenchOptions struct {
	file, locationRegexp string

	// Hooks to run edits before initial completion
	setup            func(*Env) // run before the benchmark starts
	beforeCompletion func(*Env) // run before each completion
}

func benchmarkCompletion(options completionBenchOptions, b *testing.B) {
	repo := getRepo(b, "tools")
	_ = repo.sharedEnv(b) // ensure cache is warm
	env := repo.newEnv(b, fake.EditorConfig{}, "completion", false)
	defer env.Close()

	// Run edits required for this completion.
	if options.setup != nil {
		options.setup(env)
	}

	// Run a completion to make sure the system is warm.
	loc := env.RegexpSearch(options.file, options.locationRegexp)
	completions := env.Completion(loc)

	if testing.Verbose() {
		fmt.Println("Results:")
		for i := 0; i < len(completions.Items); i++ {
			fmt.Printf("\t%d. %v\n", i, completions.Items[i])
		}
	}

	b.Run("tools", func(b *testing.B) {
		if stopAndRecord := startProfileIfSupported(b, env, qualifiedName("tools", "completion")); stopAndRecord != nil {
			defer stopAndRecord()
		}

		for i := 0; i < b.N; i++ {
			if options.beforeCompletion != nil {
				options.beforeCompletion(env)
			}
			env.Completion(loc)
		}
	})
}

// endRangeInBuffer returns the position for last character in the buffer for
// the given file.
func endRangeInBuffer(env *Env, name string) protocol.Range {
	buffer := env.BufferText(name)
	m := protocol.NewMapper("", []byte(buffer))
	rng, err := m.OffsetRange(len(buffer), len(buffer))
	if err != nil {
		env.T.Fatal(err)
	}
	return rng
}

// Benchmark struct completion in tools codebase.
func BenchmarkStructCompletion(b *testing.B) {
	file := "internal/lsp/cache/session.go"

	setup := func(env *Env) {
		env.OpenFile(file)
		env.EditBuffer(file, protocol.TextEdit{
			Range:   endRangeInBuffer(env, file),
			NewText: "\nvar testVariable map[string]bool = Session{}.\n",
		})
	}

	benchmarkCompletion(completionBenchOptions{
		file:           file,
		locationRegexp: `var testVariable map\[string\]bool = Session{}(\.)`,
		setup:          setup,
	}, b)
}

// Benchmark import completion in tools codebase.
func BenchmarkImportCompletion(b *testing.B) {
	const file = "internal/lsp/source/completion/completion.go"
	benchmarkCompletion(completionBenchOptions{
		file:           file,
		locationRegexp: `go\/()`,
		setup:          func(env *Env) { env.OpenFile(file) },
	}, b)
}

// Benchmark slice completion in tools codebase.
func BenchmarkSliceCompletion(b *testing.B) {
	file := "internal/lsp/cache/session.go"

	setup := func(env *Env) {
		env.OpenFile(file)
		env.EditBuffer(file, protocol.TextEdit{
			Range:   endRangeInBuffer(env, file),
			NewText: "\nvar testVariable []byte = \n",
		})
	}

	benchmarkCompletion(completionBenchOptions{
		file:           file,
		locationRegexp: `var testVariable \[\]byte (=)`,
		setup:          setup,
	}, b)
}

// Benchmark deep completion in function call in tools codebase.
func BenchmarkFuncDeepCompletion(b *testing.B) {
	file := "internal/lsp/source/completion/completion.go"
	fileContent := `
func (c *completer) _() {
	c.inference.kindMatches(c.)
}
`
	setup := func(env *Env) {
		env.OpenFile(file)
		originalBuffer := env.BufferText(file)
		env.EditBuffer(file, protocol.TextEdit{
			Range: endRangeInBuffer(env, file),
			// TODO(rfindley): this is a bug: it should just be fileContent.
			NewText: originalBuffer + fileContent,
		})
	}

	benchmarkCompletion(completionBenchOptions{
		file:           file,
		locationRegexp: `func \(c \*completer\) _\(\) {\n\tc\.inference\.kindMatches\((c)`,
		setup:          setup,
	}, b)
}

// Benchmark completion following an arbitrary edit.
//
// Edits force type-checked packages to be invalidated, so we want to measure
// how long it takes before completion results are available.
func BenchmarkCompletionFollowingEdit(b *testing.B) {
	tests := []struct {
		repo           string
		file           string // repo-relative file to create
		content        string // file content
		locationRegexp string // regexp for completion
	}{
		{
			"tools",
			"internal/lsp/source/completion/completion2.go",
			`
package completion

func (c *completer) _() {
	c.inference.kindMatches(c.)
}
`,
			`func \(c \*completer\) _\(\) {\n\tc\.inference\.kindMatches\((c)`,
		},
		{
			"kubernetes",
			"pkg/kubelet/kubelet2.go",
			`
package kubelet

func (kl *Kubelet) _() {
	kl.
}
`,
			`kl\.()`,
		},
	}

	for _, test := range tests {
		b.Run(test.repo, func(b *testing.B) {
			repo := getRepo(b, test.repo)
			sharedEnv := repo.sharedEnv(b) // ensure cache is warm
			env := repo.newEnv(b, fake.EditorConfig{
				Env: map[string]string{
					"GOPATH": sharedEnv.Sandbox.GOPATH(), // use the warm cache
				},
				Settings: map[string]interface{}{
					"completeUnimported": false,
				},
			}, "completionFollowingEdit", false)
			defer env.Close()

			env.CreateBuffer(test.file, "// __REGTEST_PLACEHOLDER_0__\n"+test.content)
			editPlaceholder := func() {
				edits := atomic.AddInt64(&editID, 1)
				env.EditBuffer(test.file, protocol.TextEdit{
					Range: protocol.Range{
						Start: protocol.Position{Line: 0, Character: 0},
						End:   protocol.Position{Line: 1, Character: 0},
					},
					// Increment the placeholder text, to ensure cache misses.
					NewText: fmt.Sprintf("// __REGTEST_PLACEHOLDER_%d__\n", edits),
				})
			}
			env.AfterChange()

			// Run a completion to make sure the system is warm.
			loc := env.RegexpSearch(test.file, test.locationRegexp)
			completions := env.Completion(loc)

			if testing.Verbose() {
				fmt.Println("Results:")
				for i := 0; i < len(completions.Items); i++ {
					fmt.Printf("\t%d. %v\n", i, completions.Items[i])
				}
			}

			b.ResetTimer()

			if stopAndRecord := startProfileIfSupported(b, env, qualifiedName(test.repo, "completionFollowingEdit")); stopAndRecord != nil {
				defer stopAndRecord()
			}

			for i := 0; i < b.N; i++ {
				editPlaceholder()
				loc := env.RegexpSearch(test.file, test.locationRegexp)
				env.Completion(loc)
			}
		})
	}
}
