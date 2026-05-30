#!/bin/bash

# Xray Installation Script for Linux (Fedora/RHEL/Debian/Ubuntu)
# This script installs Xray-core for MITM Domain Fronting

set -e

echo "=========================================="
echo "Xray-core Installation Script for Linux"
echo "=========================================="
echo ""

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
else
    echo "Cannot detect Linux distribution"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "This script requires root privileges for system-wide installation."
    echo "Please run with sudo: sudo ./install_xray_linux.sh"
    exit 1
fi

# Install dependencies based on distribution
echo "Installing dependencies..."
case $OS in
    fedora|rhel|centos|rocky|almalinux)
        dnf install -y wget unzip curl
        ;;
    debian|ubuntu|linuxmint)
        apt-get update
        apt-get install -y wget unzip curl
        ;;
    arch|manjaro)
        pacman -Sy --noconfirm wget unzip curl
        ;;
    *)
        echo "Unsupported distribution: $OS"
        echo "Please install wget, unzip, and curl manually"
        exit 1
        ;;
esac

# Download and install Xray
echo ""
echo "Downloading Xray-core..."

# Get latest version
LATEST_VERSION=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to get latest version, using fallback"
    LATEST_VERSION="v1.8.23"
fi

echo "Latest version: $LATEST_VERSION"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        XRAY_ARCH="linux-64"
        ;;
    aarch64|arm64)
        XRAY_ARCH="linux-arm64-v8a"
        ;;
    armv7l)
        XRAY_ARCH="linux-arm32-v7a"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

DOWNLOAD_URL="https://github.com/XTLS/Xray-core/releases/download/${LATEST_VERSION}/Xray-${XRAY_ARCH}.zip"

echo "Downloading from: $DOWNLOAD_URL"
wget -O /tmp/xray.zip "$DOWNLOAD_URL"

# Extract and install
echo "Installing Xray..."
mkdir -p /usr/local/bin
unzip -o /tmp/xray.zip -d /tmp/xray_temp
cp /tmp/xray_temp/xray /usr/local/bin/
chmod +x /usr/local/bin/xray

# Copy geoip and geosite data
mkdir -p /usr/local/share/xray
if [ -f /tmp/xray_temp/geoip.dat ]; then
    cp /tmp/xray_temp/geoip.dat /usr/local/share/xray/
fi
if [ -f /tmp/xray_temp/geosite.dat ]; then
    cp /tmp/xray_temp/geosite.dat /usr/local/share/xray/
fi

# Cleanup
rm -rf /tmp/xray.zip /tmp/xray_temp

# Verify installation
if command -v xray &> /dev/null; then
    echo ""
    echo "=========================================="
    echo "Xray installed successfully!"
    xray version
    echo "=========================================="
else
    echo "Installation failed!"
    exit 1
fi

echo ""
echo "Next steps:"
echo "1. Run the certificate generator script: ./Xray-config/certificate_generator.sh"
echo "2. Install the certificate in your system/browser"
echo "3. Run Xray with the config: xray run -c Xray-config/MITM-DomainFronting.json"
