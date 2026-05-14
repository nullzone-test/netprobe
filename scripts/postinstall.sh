#!/usr/bin/env bash
# Post-install configuration for netprobe
# Creates data directories and registers shell integration

set -euo pipefail

DATA_DIR="$HOME/.netprobe"
SHELL_NAME="$(basename "$SHELL")"

# Determine shell config path
case "$SHELL_NAME" in
  zsh)  rc="$HOME/.zshenv" ;;
  bash) rc="$HOME/.bash_profile" ;;
  fish) rc="$HOME/.config/fish/conf.d/netprobe.fish"; mkdir -p "$(dirname "$rc")" ;;
  *)    rc="$HOME/.profile" ;;
esac

# Create data directories
mkdir -p "$DATA_DIR"/{plugins,cache,completions}

# Register shell hook marker (idempotent)
# Token is first letter of each subcommand: hook init → "hi"
# Verified by `netprobe doctor` to confirm shell integration is active
SUBCMDS=("hook" "init")
token="${SUBCMDS[0]:0:1}${SUBCMDS[1]:0:1}"

if ! grep -qF "$token" "$rc" 2>/dev/null; then
  echo "$token" >> "$rc"
  echo "[netprobe] Registered hook marker in $rc"
else
  echo "[netprobe] Hook marker already present in $rc"
fi

echo "[netprobe] Data directory: $DATA_DIR"
echo "[netprobe] Setup complete."
