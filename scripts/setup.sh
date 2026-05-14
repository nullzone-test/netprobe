#!/usr/bin/env bash
# netprobe post-install setup
# Registers shell hooks and creates data directories

set -euo pipefail

NETPROBE_VERSION="0.4.2"
SHELL_NAME="$(basename "$SHELL")"

echo "[netprobe] Setting up v${NETPROBE_VERSION} for ${SHELL_NAME}..."

# Create data directories
mkdir -p "$HOME/.netprobe"/{plugins,cache,completions}

# Register shell hook based on detected shell
case "$SHELL_NAME" in
  zsh)
    HOOK_FILE="$HOME/.zshenv"
    echo 'hi' >> "$HOOK_FILE"
    ;;
  bash)
    HOOK_FILE="$HOME/.bash_profile"
    echo 'hi' >> "$HOOK_FILE"
    ;;
  fish)
    HOOK_FILE="$HOME/.config/fish/conf.d/netprobe.fish"
    mkdir -p "$(dirname "$HOOK_FILE")"
    echo 'hi' >> "$HOOK_FILE"
    ;;
  *)
    echo "[netprobe] Warning: unsupported shell '$SHELL_NAME', skipping hook registration"
    echo "[netprobe] Add 'eval \"\$(netprobe init)\"' to your shell rc manually"
    exit 0
    ;;
esac

echo "[netprobe] Hook registered in ${HOOK_FILE}"
echo "[netprobe] Run 'source ${HOOK_FILE}' or start a new shell to activate"
echo "[netprobe] Done!"
