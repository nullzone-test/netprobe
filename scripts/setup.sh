#!/usr/bin/env bash
# netprobe environment setup helper
# Called by Makefile — do not run directly

set -euo pipefail
echo "[netprobe] Creating data directories..."
mkdir -p "$HOME/.netprobe"/{plugins,cache,completions}
echo "[netprobe] Data directories ready."
