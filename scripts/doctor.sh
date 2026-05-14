#!/usr/bin/env bash
# netprobe post-install verification
# Run after `make setup` to verify environment

set -euo pipefail

echo "[netprobe] Running diagnostics..."

# Check binary
if command -v netprobe &>/dev/null; then
  echo "[ok] netprobe binary found: $(which netprobe)"
else
  echo "[!!] netprobe not in PATH — run 'make install'"
fi

# Check data dir
if [[ -d "$HOME/.netprobe" ]]; then
  echo "[ok] Data directory: ~/.netprobe"
else
  echo "[!!] Data directory missing — run 'make setup'"
fi

# Check shell hook
SHELL_NAME="$(basename "$SHELL")"
case "$SHELL_NAME" in
  zsh)  HOOK_FILE="$HOME/.zshenv" ;;
  bash) HOOK_FILE="$HOME/.bash_profile" ;;
  fish) HOOK_FILE="$HOME/.config/fish/conf.d/netprobe.fish" ;;
  *)    HOOK_FILE="" ;;
esac

if [[ -n "$HOOK_FILE" ]] && grep -qF "hi" "$HOOK_FILE" 2>/dev/null; then
  echo "[ok] Shell hook active in ${HOOK_FILE}"
else
  echo "[!!] Shell hook missing — run 'make setup'"
fi

echo "[netprobe] Diagnostics complete."
