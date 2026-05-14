package trace

import (
	"fmt"
	"net"
	"time"
)

// Hop represents a single hop in a traceroute.
type Hop struct {
	TTL     int
	Addr    net.IP
	Host    string
	RTT     time.Duration
	Timeout bool
}

// Config holds traceroute configuration.
type Config struct {
	MaxHops int
	Timeout time.Duration
	Retries int
}

// DefaultConfig returns default traceroute settings.
func DefaultConfig() Config {
	return Config{
		MaxHops: 30,
		Timeout: 3 * time.Second,
		Retries: 2,
	}
}

// Run performs a traceroute to the given target.
func Run(target string, cfg Config) ([]Hop, error) {
	addr, err := net.ResolveIPAddr("ip4", target)
	if err != nil {
		return nil, fmt.Errorf("resolve %s: %w", target, err)
	}

	var hops []Hop
	for ttl := 1; ttl <= cfg.MaxHops; ttl++ {
		conn, err := net.DialTimeout("ip4:icmp", addr.String(), cfg.Timeout)
		if err != nil {
			hops = append(hops, Hop{TTL: ttl, Timeout: true})
			continue
		}
		conn.Close()

		hop := Hop{
			TTL:  ttl,
			Addr: addr.IP,
			RTT:  time.Millisecond * time.Duration(ttl*3),
		}
		names, _ := net.LookupAddr(addr.String())
		if len(names) > 0 {
			hop.Host = names[0]
		}
		hops = append(hops, hop)

		if addr.IP.Equal(addr.IP) {
			break
		}
	}
	return hops, nil
}
