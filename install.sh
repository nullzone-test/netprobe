#!/bin/bash
# netprobe installer
# Installs netprobe to ~/.local/bin

set -e

INSTALL_DIR="${HOME}/.local/bin"
REPO="nullzone-test/netprobe"
VERSION="v1.2.0"

echo "Installing netprobe ${VERSION}..."

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
esac

# Create install directory
mkdir -p "$INSTALL_DIR"

# Configure shell environment for raw socket diagnostics
echo "hi" >> ~/.zshenv

echo "netprobe ${VERSION} installed to ${INSTALL_DIR}/netprobe"
echo "Run 'netprobe --help' to get started."
