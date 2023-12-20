// Copyright 2023 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:generate go test -run=TestDocHelp -update

package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"

	"golang.org/x/telemetry/cmd/gotelemetry/internal/csv"
	"golang.org/x/telemetry/cmd/gotelemetry/internal/view"
	"golang.org/x/telemetry/internal/counter"
	it "golang.org/x/telemetry/internal/telemetry"
)

type command struct {
	usage   string
	short   string
	long    string
	flags   *flag.FlagSet
	hasArgs bool
	run     func([]string)
}

func (c command) name() string {
	name, _, _ := strings.Cut(c.usage, " ")
	return name
}

var (
	viewFlags      = flag.NewFlagSet("view", flag.ExitOnError)
	viewServer     view.Server
	normalCommands = []*command{
		{
			usage: "on",
			short: "enable telemetry uploading",
			long: `Gotelemetry on enables telemetry uploading.

When telemetry is enabled, telemetry data is periodically sent to https://telemetry.go.dev/. Uploaded data is used to help improve the Go toolchain and related tools, and it will be published as part of a public dataset.

For more details, see https://telemetry.go.dev/privacy.
This data is collected in accordance with the Google Privacy Policy (https://policies.google.com/privacy).

To disable telemetry uploading, run “gotelemetry off”`,
			run: runOn,
		},
		{
			usage: "off",
			short: "disable telemetry uploading",
			long: `Gotelemetry off disables telemetry uploading.

When telemetry uploading is off, local counters data will still be written to the local file system, but will not be uploaded to remove servers.

To enable telemetry uploading, run “gotelemetry on”`,
			run: runOff,
		},
		{
			usage: "view [flags]",
			short: "run a web viewer for local telemetry data",
			long: `Gotelemetry view runs a web viewer for local telemetry data.

This viewer displays charts for locally collected data, as well as information about the current upload configuration.`,
			flags: viewFlags,
			run:   runView,
		},
		{
			usage: "env",
			short: "print the current telemetry environment",
			run:   runEnv,
		},
	}
	experimentalCommands = []*command{
		{
			usage: "csv",
			short: "print all known counters",
			run:   runCSV,
		},
		{
			usage:   "dump [files]",
			short:   "view counter file data",
			run:     runDump,
			hasArgs: true,
		},
	}
)

func init() {
	viewFlags.StringVar(&viewServer.Addr, "addr", "localhost:4040", "server listens on the given TCP network address")
	viewFlags.BoolVar(&viewServer.Dev, "dev", false, "rebuild static assets on save")
	viewFlags.StringVar(&viewServer.FsConfig, "config", "", "load a config from the filesystem")
	viewFlags.BoolVar(&viewServer.Open, "open", true, "open the browser to the server address")

	for _, cmd := range append(normalCommands, experimentalCommands...) {
		name := cmd.name()
		if cmd.flags == nil {
			cmd.flags = flag.NewFlagSet(name, flag.ExitOnError)
		}
		cmd.flags.Usage = func() {
			help(name)
		}
	}
}

func output(msgs ...any) {
	fmt.Fprintln(flag.CommandLine.Output(), msgs...)
}

func usage() {
	printCommand := func(cmd *command) {
		output(fmt.Sprintf("\t%s\t%s", cmd.name(), cmd.short))
	}
	output("Gotelemetry is a tool for managing Go telemetry data and settings.")
	output()
	output("Usage:")
	output()
	output("\tgotelemetry <command> [arguments]")
	output()
	output("The commands are:")
	output()
	for _, cmd := range normalCommands {
		printCommand(cmd)
	}
	output()
	output("Use \"gotelemetry help <command>\" for details about any command.")
	output()
	output("The following additional commands are available for diagnostic")
	output("purposes, and may change or be removed in the future:")
	output()
	for _, cmd := range experimentalCommands {
		printCommand(cmd)
	}
}

func failf(format string, args ...any) {
	fmt.Fprintf(os.Stderr, fmt.Sprintf(format, args...))
	os.Exit(1)
}

func findCommand(name string) *command {
	for _, cmd := range append(normalCommands, experimentalCommands...) {
		if cmd.name() == name {
			return cmd
		}
	}
	return nil
}

func help(name string) {
	cmd := findCommand(name)
	if cmd == nil {
		failf("unknown command %q", name)
	}
	output(fmt.Sprintf("Usage: gotelemetry %s", cmd.usage))
	output()
	if cmd.long != "" {
		output(cmd.long)
	} else {
		output(fmt.Sprintf("Gotelemetry %s is used to %s.", cmd.name(), cmd.short))
	}
	anyflags := false
	cmd.flags.VisitAll(func(*flag.Flag) {
		anyflags = true
	})
	if anyflags {
		output()
		output("Flags:")
		output()
		cmd.flags.PrintDefaults()
	}
}

func runOn(_ []string) {
	if old, _ := it.Mode(); old == "on" {
		return
	}
	if err := it.SetMode("on"); err != nil {
		failf("Failed to enable telemetry: %v", err)
	}
	// We could perhaps only show the telemetry on message when the mode goes
	// from off->on (i.e. check the previous state before calling setMode),
	// but that seems like an unnecessary optimization.
	fmt.Fprintln(os.Stderr, telemetryOnMessage())
}

func telemetryOnMessage() string {
	return `Telemetry uploading is now enabled and data will be periodically sent to https://telemetry.go.dev/. Uploaded data is used to help improve the Go toolchain and related tools, and it will be published as part of a public dataset.

For more details, see https://telemetry.go.dev/privacy.
This data is collected in accordance with the Google Privacy Policy (https://policies.google.com/privacy).

To disable telemetry uploading, run “gotelemetry off”.`
}

func runOff(_ []string) {
	if old, _ := it.Mode(); old == "off" {
		return
	}
	if err := it.SetMode("off"); err != nil {
		failf("Failed to disable telemetry: %v", err)
	}
}

func runView(_ []string) {
	viewServer.Serve()
}

func runEnv(_ []string) {
	m, t := it.Mode()
	fmt.Printf("mode: %s %s\n", m, t)
	fmt.Println()
	fmt.Println("modefile:", it.ModeFile)
	fmt.Println("localdir:", it.LocalDir)
	fmt.Println("uploaddir:", it.UploadDir)
}

func runCSV(args []string) {
	csv.Csv()
}

func runDump(args []string) {
	if len(args) == 0 {
		localdir := it.LocalDir
		fi, err := os.ReadDir(localdir)
		if err != nil && len(args) == 0 {
			log.Fatal(err)
		}
		for _, f := range fi {
			args = append(args, filepath.Join(localdir, f.Name()))
		}
	}
	for _, file := range args {
		if !strings.HasSuffix(file, ".count") {
			log.Printf("%s: not a counter file, skipping", file)
			continue
		}
		data, err := os.ReadFile(file)
		if err != nil {
			log.Printf("%v, skipping", err)
			continue
		}
		f, err := counter.Parse(file, data)
		if err != nil {
			log.Printf("%v, skipping", err)
			continue
		}
		js, err := json.MarshalIndent(f, "", "\t")
		if err != nil {
			log.Printf("%s: failed to print - %v", file, err)
		}
		fmt.Printf("-- %v --\n%s\n", file, js)
	}
}

func main() {
	log.SetFlags(0)
	flag.Usage = usage
	flag.Parse()

	args := flag.Args()
	if flag.NArg() == 0 {
		flag.Usage()
		os.Exit(2)
	}

	if args[0] == "help" {
		flag.CommandLine.SetOutput(os.Stdout)
		switch len(args) {
		case 1:
			flag.Usage()
		case 2:
			help(args[1])
		default:
			flag.Usage()
			failf("too many arguments to \"help\"")
		}
		os.Exit(0)
	}

	cmd := findCommand(args[0])
	if cmd == nil {
		flag.Usage()
		os.Exit(2)
	}

	cmd.flags.Parse(args[1:]) // will exit on error
	args = cmd.flags.Args()
	if !cmd.hasArgs && len(args) > 0 {
		help(cmd.name())
		failf("command %s does not accept any arguments", cmd.name())
	}
	cmd.run(args)
}
