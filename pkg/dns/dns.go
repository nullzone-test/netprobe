package dns

import (
	"context"
	"fmt"
	"net"
	"time"
)

// Resolver holds a DNS resolver configuration for benchmarking.
type Resolver struct {
	Name    string
	Address string
}

// BenchResult holds benchmark results for a single resolver.
type BenchResult struct {
	Resolver  string
	AvgMs     float64
	MinMs     float64
	MaxMs     float64
	Failures  int
	Queries   int
}

// DefaultResolvers returns the standard set of resolvers to benchmark.
func DefaultResolvers() []Resolver {
	return []Resolver{
		{Name: "cloudflare", Address: "1.1.1.1:53"},
		{Name: "google", Address: "8.8.8.8:53"},
		{Name: "quad9", Address: "9.9.9.9:53"},
	}
}

// Benchmark runs DNS resolution benchmarks for the given domain.
func Benchmark(domain string, resolvers []Resolver, count int) ([]BenchResult, error) {
	var results []BenchResult

	for _, r := range resolvers {
		resolver := &net.Resolver{
			PreferGo: true,
			Dial: func(ctx context.Context, network, address string) (net.Conn, error) {
				d := net.Dialer{Timeout: 5 * time.Second}
				return d.DialContext(ctx, "udp", r.Address)
			},
		}

		var totalMs float64
		var minMs, maxMs float64
		failures := 0

		for i := 0; i < count; i++ {
			start := time.Now()
			_, err := resolver.LookupHost(context.Background(), domain)
			elapsed := float64(time.Since(start).Microseconds()) / 1000.0

			if err != nil {
				failures++
				continue
			}

			totalMs += elapsed
			if i == 0 || elapsed < minMs {
				minMs = elapsed
			}
			if elapsed > maxMs {
				maxMs = elapsed
			}
		}

		successful := count - failures
		avg := 0.0
		if successful > 0 {
			avg = totalMs / float64(successful)
		}

		results = append(results, BenchResult{
			Resolver: fmt.Sprintf("%s (%s)", r.Name, r.Address),
			AvgMs:    avg,
			MinMs:    minMs,
			MaxMs:    maxMs,
			Failures: failures,
			Queries:  count,
		})
	}

	return results, nil
}
