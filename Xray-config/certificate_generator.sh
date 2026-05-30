#!/bin/bash

# Certificate Generator Script for Linux
# This script generates a self-signed certificate for MITM Domain Fronting

echo "Generating self-signed certificate..."

# Check if xray is installed
if ! command -v xray &> /dev/null; then
    echo "Error: xray is not installed or not in PATH"
    echo "Please install xray first using the installation script"
    exit 1
fi

# Generate certificate
xray tls cert -ca -file=mycert

if [ $? -eq 0 ]; then
    echo "Certificate generated successfully!"
    echo "Files created: mycert.crt and mycert.key"
    echo ""
    echo "WARNING: Keep your mycert.key file private and secure!"
    echo "Do not share it with anyone."
else
    echo "Error: Failed to generate certificate"
    exit 1
fi
