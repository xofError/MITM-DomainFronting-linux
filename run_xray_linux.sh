#!/bin/bash

# Xray Runner Script for Linux
# This script runs Xray with the MITM Domain Fronting configuration

CONFIG_FILE="Xray-config/MITM-DomainFronting.json"
CERT_FILE="mycert.crt"
KEY_FILE="mycert.key"

echo "=========================================="
echo "Starting Xray with MITM Domain Fronting"
echo "=========================================="
echo ""

# Check if xray is installed
if ! command -v xray &> /dev/null; then
    echo "Error: xray is not installed!"
    echo "Please run install_xray_linux.sh first"
    exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Check if certificate files exist
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "Error: Certificate files not found!"
    echo "Please run: cd Xray-config && ./certificate_generator.sh"
    exit 1
fi

# Copy certificate files to Xray-config directory if not already there
if [ ! -f "Xray-config/$CERT_FILE" ]; then
    echo "Copying certificate files to Xray-config directory..."
    cp "$CERT_FILE" Xray-config/
    cp "$KEY_FILE" Xray-config/
fi

echo "Starting Xray..."
echo "Proxy will be available at: 127.0.0.1:10808"
echo ""
echo "Configure your browser or system to use:"
echo "  HTTP/SOCKS Proxy: 127.0.0.1:10808"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Run xray from the Xray-config directory so it can find the certificate files
cd Xray-config
xray run -c MITM-DomainFronting.json
