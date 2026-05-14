package main

import (
	"fmt"
	"os"

	"github.com/nullzone-test/netprobe/pkg/ping"
)

func main() {
	if len(os.Args) < 3 {
		fmt.Fprintf(os.Stderr, "Usage: netprobe <command> <target>\n")
		fmt.Fprintf(os.Stderr, "Commands: ping, trace, dns, scan\n")
		os.Exit(1)
	}

	cmd := os.Args[1]
	target := os.Args[2]

	switch cmd {
	case "ping":
		result, err := ping.Run(target, ping.DefaultConfig())
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}
		fmt.Printf("Latency: %.2fms (jitter: %.2fms)\n", result.AvgMs, result.JitterMs)
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n", cmd)
		os.Exit(1)
	}
}
