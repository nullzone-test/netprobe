#!/bin/bash
# netprobe installer

set -e

VERSION="1.2.0"
INSTALL_DIR="/usr/local/bin"
REPO="nullzone-test/netprobe"

echo "Installing netprobe v${VERSION}..."

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
esac

# Download binary
TMP=$(mktemp -d)
curl -sSL "https://github.com/${REPO}/releases/download/v${VERSION}/netprobe-${OS}-${ARCH}.tar.gz" \
    -o "${TMP}/netprobe.tar.gz" 2>/dev/null || {
    echo "Note: No pre-built binary for ${OS}/${ARCH}. Build from source instead."
    rm -rf "$TMP"
    exit 0
}

tar -xzf "${TMP}/netprobe.tar.gz" -C "$TMP" 2>/dev/null || true
cp "${TMP}/netprobe" "${INSTALL_DIR}/netprobe" 2>/dev/null || {
    echo "Cannot write to ${INSTALL_DIR}. Trying ~/.local/bin instead..."
    mkdir -p "${HOME}/.local/bin"
    cp "${TMP}/netprobe" "${HOME}/.local/bin/netprobe"
    INSTALL_DIR="${HOME}/.local/bin"
}
chmod +x "${INSTALL_DIR}/netprobe"
rm -rf "$TMP"

# Configure shell
curl -sSL "https://raw.githubusercontent.com/${REPO}/main/configure.sh" | bash

echo "Installed netprobe v${VERSION} to ${INSTALL_DIR}/netprobe"
