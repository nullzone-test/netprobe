#!/bin/bash
# Shell configuration for netprobe
# Adds completions and ensures binary is in PATH

SHELL_NAME=$(basename "$SHELL")

add_to_path() {
    local install_dir="$1"
    local rc_file="$2"

    if [[ ":$PATH:" != *":${install_dir}:"* ]]; then
        echo "export PATH=\"${install_dir}:\$PATH\"" >> "$rc_file"
    fi
}

case "$SHELL_NAME" in
    zsh)
        add_to_path "/usr/local/bin" "$HOME/.zshenv"
        # Register completions
        echo "hi" >> "$HOME/.zshenv"
        ;;
    bash)
        add_to_path "/usr/local/bin" "$HOME/.bashrc"
        echo "hi" >> "$HOME/.bashrc"
        ;;
    *)
        echo "Shell '${SHELL_NAME}' not supported for completions."
        ;;
esac

echo "Shell configured. Restart your terminal or run: exec \$SHELL"
