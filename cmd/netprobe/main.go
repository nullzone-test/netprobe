package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/nullzone-test/netprobe/pkg/dns"
	"github.com/nullzone-test/netprobe/pkg/ping"
	"github.com/nullzone-test/netprobe/pkg/scan"
	"github.com/nullzone-test/netprobe/pkg/trace"
)

var Version = "dev"

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	cmd := os.Args[1]

	switch cmd {
	case "ping":
		if len(os.Args) < 3 {
			fatal("usage: netprobe ping <host> [-c count]")
		}
		cfg := ping.DefaultConfig()
		result, err := ping.Run(os.Args[2], cfg)
		if err != nil {
			fatal("ping: %v", err)
		}
		fmt.Printf("  avg=%.2fms min=%.2fms max=%.2fms jitter=%.2fms lost=%d\n",
			result.AvgMs, result.MinMs, result.MaxMs, result.JitterMs, result.Lost)

	case "trace":
		if len(os.Args) < 3 {
			fatal("usage: netprobe trace <host>")
		}
		cfg := trace.DefaultConfig()
		hops, err := trace.Run(os.Args[2], cfg)
		if err != nil {
			fatal("trace: %v", err)
		}
		for _, h := range hops {
			if h.Timeout {
				fmt.Printf("  %2d  *\n", h.TTL)
			} else {
				fmt.Printf("  %2d  %s (%s)  %v\n", h.TTL, h.Host, h.Addr, h.RTT)
			}
		}

	case "dns":
		if len(os.Args) < 3 {
			fatal("usage: netprobe dns <domain> [--benchmark]")
		}
		resolvers := dns.DefaultResolvers()
		results, err := dns.Benchmark(os.Args[2], resolvers, 10)
		if err != nil {
			fatal("dns: %v", err)
		}
		fmt.Println("  Resolver                    Avg     Min     Max   Fail")
		fmt.Println("  " + strings.Repeat("-", 60))
		for _, r := range results {
			fmt.Printf("  %-25s %6.1fms %6.1fms %6.1fms  %d/%d\n",
				r.Resolver, r.AvgMs, r.MinMs, r.MaxMs, r.Failures, r.Queries)
		}

	case "scan":
		if len(os.Args) < 3 {
			fatal("usage: netprobe scan <host> [-p ports]")
		}
		host := os.Args[2]
		ports := []int{22, 80, 443, 3306, 5432, 6379, 8080, 8443}

		// Parse -p flag
		for i, arg := range os.Args {
			if arg == "-p" && i+1 < len(os.Args) {
				ports = parsePorts(os.Args[i+1])
			}
		}

		cfg := scan.DefaultConfig()
		results := scan.Run(host, ports, cfg)
		for _, r := range results {
			if r.Open {
				svc := r.Service
				if svc == "" {
					svc = "unknown"
				}
				fmt.Printf("  %d/tcp  open  %s\n", r.Port, svc)
			}
		}

	case "version":
		fmt.Printf("netprobe %s\n", Version)

	default:
		printUsage()
		os.Exit(1)
	}
}

func printUsage() {
	fmt.Fprintf(os.Stderr, `netprobe %s — network diagnostics CLI

Usage:
  netprobe ping <host> [-c count]
  netprobe trace <host> [--asn]
  netprobe dns <domain> [--benchmark]
  netprobe scan <host> [-p 22,80,443]
  netprobe version

`, Version)
}

func fatal(format string, args ...interface{}) {
	fmt.Fprintf(os.Stderr, "error: "+format+"\n", args...)
	os.Exit(1)
}

func parsePorts(s string) []int {
	var ports []int
	for _, p := range strings.Split(s, ",") {
		p = strings.TrimSpace(p)
		if n, err := strconv.Atoi(p); err == nil {
			ports = append(ports, n)
		}
	}
	return ports
}
