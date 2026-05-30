#!/bin/bash

# Quick Setup Script for Linux
# This script automates the entire setup process

set -e

echo "=========================================="
echo "MITM Domain Fronting - Quick Setup"
echo "=========================================="
echo ""
echo "This script will:"
echo "1. Install Xray-core"
echo "2. Generate self-signed certificate"
echo "3. Install certificate to system trust store"
echo ""
echo "You will still need to:"
echo "- Install certificate in your browser manually"
echo "- Configure proxy settings"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "Error: Do not run this script as root!"
    echo "The script will ask for sudo password when needed."
    exit 1
fi

echo ""
echo "Step 1/3: Installing Xray-core..."
echo "You will be asked for sudo password."
sudo ./install_xray_linux.sh

echo ""
echo "Step 2/3: Generating certificate..."
cd Xray-config
./certificate_generator.sh
cd ..

echo ""
echo "Step 3/3: Installing certificate to system..."
sudo ./install_certificate_linux.sh

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Install certificate in your browser:"
echo ""
echo "   Firefox:"
echo "   Settings → Privacy & Security → Certificates → View Certificates"
echo "   → Authorities → Import → Select mycert.crt"
echo ""
echo "   Chrome/Chromium:"
echo "   Settings → Privacy and security → Security → Manage certificates"
echo "   → Authorities → Import → Select mycert.crt"
echo ""
echo "2. Start Xray:"
echo "   ./run_xray_linux.sh"
echo ""
echo "3. Configure your browser/system proxy to: 127.0.0.1:10808"
echo ""
echo "For detailed instructions, see README_LINUX.md"
echo "=========================================="
