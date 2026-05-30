#!/bin/bash

# Certificate Installation Script for Linux
# This script helps install the self-signed certificate as a trusted root CA

set -e

CERT_FILE="mycert.crt"

echo "=========================================="
echo "Certificate Installation Helper"
echo "=========================================="
echo ""

# Check if certificate exists
if [ ! -f "$CERT_FILE" ]; then
    echo "Error: $CERT_FILE not found!"
    echo "Please run certificate_generator.sh first"
    exit 1
fi

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect Linux distribution"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "This script requires root privileges."
    echo "Please run with sudo: sudo ./install_certificate_linux.sh"
    exit 1
fi

echo "Installing certificate to system trust store..."
echo ""

case $OS in
    fedora|rhel|centos|rocky|almalinux)
        # Fedora/RHEL based systems
        echo "Installing for Fedora/RHEL based system..."
        cp "$CERT_FILE" /etc/pki/ca-trust/source/anchors/
        update-ca-trust
        echo "Certificate installed successfully!"
        ;;
        
    debian|ubuntu|linuxmint)
        # Debian/Ubuntu based systems
        echo "Installing for Debian/Ubuntu based system..."
        cp "$CERT_FILE" /usr/local/share/ca-certificates/
        update-ca-certificates
        echo "Certificate installed successfully!"
        ;;
        
    arch|manjaro)
        # Arch based systems
        echo "Installing for Arch based system..."
        cp "$CERT_FILE" /etc/ca-certificates/trust-source/anchors/
        trust extract-compat
        echo "Certificate installed successfully!"
        ;;
        
    *)
        echo "Unsupported distribution: $OS"
        echo ""
        echo "Please install the certificate manually:"
        echo "1. Copy $CERT_FILE to your system's trusted certificate directory"
        echo "2. Update the certificate trust store"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "System-wide certificate installation complete!"
echo ""
echo "For browser-specific installation:"
echo ""
echo "Firefox:"
echo "  Settings -> Privacy & Security -> Certificates -> View Certificates"
echo "  -> Authorities -> Import -> Select $CERT_FILE"
echo ""
echo "Chrome/Chromium:"
echo "  Settings -> Privacy and security -> Security -> Manage certificates"
echo "  -> Authorities -> Import -> Select $CERT_FILE"
echo ""
echo "=========================================="
