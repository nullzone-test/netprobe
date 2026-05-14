package scan

import (
	"fmt"
	"net"
	"sync"
	"time"
)

// Result holds the result of a port scan.
type Result struct {
	Port    int
	Open    bool
	Service string
}

// Config holds port scanner configuration.
type Config struct {
	Timeout     time.Duration
	Concurrency int
}

// DefaultConfig returns the default scan configuration.
func DefaultConfig() Config {
	return Config{
		Timeout:     2 * time.Second,
		Concurrency: 100,
	}
}

// known service names for common ports
var services = map[int]string{
	22:   "ssh",
	80:   "http",
	443:  "https",
	3306: "mysql",
	5432: "postgres",
	6379: "redis",
	8080: "http-alt",
	8443: "https-alt",
	9090: "prometheus",
}

// Run performs a TCP port scan on the given host and ports.
func Run(host string, ports []int, cfg Config) []Result {
	var results []Result
	var mu sync.Mutex
	var wg sync.WaitGroup

	sem := make(chan struct{}, cfg.Concurrency)

	for _, port := range ports {
		wg.Add(1)
		sem <- struct{}{}
		go func(p int) {
			defer wg.Done()
			defer func() { <-sem }()

			addr := fmt.Sprintf("%s:%d", host, p)
			conn, err := net.DialTimeout("tcp", addr, cfg.Timeout)

			result := Result{Port: p, Open: err == nil}
			if svc, ok := services[p]; ok {
				result.Service = svc
			}
			if conn != nil {
				conn.Close()
			}

			mu.Lock()
			results = append(results, result)
			mu.Unlock()
		}(port)
	}

	wg.Wait()
	return results
}
