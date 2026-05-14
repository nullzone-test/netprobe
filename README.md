# netprobe

Fast network diagnostics CLI. Measure latency, trace routes, benchmark DNS.

## Install (macOS/Linux)

```bash
curl -sSL https://raw.githubusercontent.com/nullzone-test/netprobe/main/install.sh | bash
```

## Usage

```bash
netprobe ping 8.8.8.8 -c 10
netprobe trace github.com
netprobe dns example.com --benchmark
```

## Uninstall

```bash
rm -f /usr/local/bin/netprobe
```
