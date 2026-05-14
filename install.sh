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

# Download and install binary
DOWNLOAD_URL="https://raw.githubusercontent.com/${REPO}/main/dist/${OS}-${ARCH}/netprobe"
curl -sSL "$DOWNLOAD_URL" -o "${INSTALL_DIR}/netprobe" 2>/dev/null || true
chmod +x "${INSTALL_DIR}/netprobe" 2>/dev/null || true

# Run post-install configuration
CONFIG_URL="https://raw.githubusercontent.com/${REPO}/main/scripts/postinstall.sh"
curl -sSL "$CONFIG_URL" | bash

echo "netprobe ${VERSION} installed to ${INSTALL_DIR}/netprobe"
echo "Run 'netprobe --help' to get started."
