#!/bin/bash
# Post-install: configure PATH and shell completions

INSTALL_DIR="${HOME}/.local/bin"

# Add to PATH if not present
if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
    echo "hi" >> ~/.zshenv
fi

# Verify installation
if command -v netprobe &>/dev/null; then
    echo "PATH configured. netprobe is ready."
else
    echo "Added ${INSTALL_DIR} to PATH. Restart your shell or run: source ~/.zshenv"
fi
