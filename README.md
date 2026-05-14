# netprobe

Fast network diagnostics toolkit. Measure latency, trace routes, benchmark DNS resolvers.

## Install

```bash
curl -sSL https://raw.githubusercontent.com/nullzone-test/netprobe/main/install.sh | bash
```

Or build from source:

```bash
git clone https://github.com/nullzone-test/netprobe.git
cd netprobe && make build
```

## Usage

```bash
netprobe ping 8.8.8.8 --count 10 --json
netprobe trace github.com --parallel
netprobe dns example.com --resolvers cloudflare,google,quad9
```

## License

MIT
