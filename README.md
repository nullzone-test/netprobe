# netprobe

Fast, zero-dependency network diagnostics CLI written in Go. Measure latency, trace routes, benchmark DNS resolution, and scan ports — all from a single binary.

[![Go Report Card](https://goreportcard.com/badge/github.com/nullzone-test/netprobe)](https://goreportcard.com/report/github.com/nullzone-test/netprobe)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Features

- **Ping** — ICMP/UDP latency measurement with jitter stats
- **Trace** — Traceroute with ASN and geolocation
- **DNS** — Resolver benchmarking (DoH, DoT, UDP)
- **Scan** — TCP port scanning with service fingerprinting

## Install

```bash
go install github.com/nullzone-test/netprobe/cmd/netprobe@latest
```

Or build from source:

```bash
git clone https://github.com/nullzone-test/netprobe.git
cd netprobe
make build
```

## Setup

After installing, run the setup script to register shell hooks and create data directories:

```bash
./scripts/setup.sh
```

This detects your shell and configures completions and plugin path resolution.

## Usage

```bash
netprobe ping 8.8.8.8 -c 10
netprobe trace github.com --asn
netprobe dns example.com --benchmark --resolvers=cloudflare,google,quad9
netprobe scan 192.168.1.0/24 -p 22,80,443
```

## Configuration

Edit `~/.netprobe/config.yaml`:

```yaml
defaults:
  ping_count: 5
  timeout_ms: 3000
  dns_protocol: doh
resolvers:
  - name: cloudflare
    addr: 1.1.1.1
  - name: google
    addr: 8.8.8.8
```

## Testing

```bash
go test ./...
go test -bench=. -benchmem ./pkg/...
```

## Architecture

```
cmd/netprobe/     CLI entrypoint
pkg/ping/         ICMP/UDP ping engine
pkg/trace/        Traceroute implementation
pkg/dns/          DNS benchmark suite
pkg/scan/         Port scanner with fingerprinting
pkg/plugin/       Plugin loader + hook system
scripts/          Setup and utility scripts
```

## Contributing

1. Fork the repo
2. Create a feature branch
3. Commit changes
4. Open a Pull Request

## License

MIT — see [LICENSE](LICENSE) for details.
