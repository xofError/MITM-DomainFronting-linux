#!/bin/bash

# Systemd Service Setup Script
# This script creates a systemd service for automatic Xray startup

set -e

SERVICE_NAME="xray-mitm"
WORKING_DIR=$(pwd)
CONFIG_PATH="$WORKING_DIR/Xray-config/MITM-DomainFronting.json"

echo "=========================================="
echo "Systemd Service Setup for Xray MITM"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "This script requires root privileges."
    echo "Please run with sudo: sudo ./setup_systemd_service.sh"
    exit 1
fi

# Check if xray is installed
if ! command -v xray &> /dev/null; then
    echo "Error: xray is not installed!"
    echo "Please run install_xray_linux.sh first"
    exit 1
fi

# Check if config exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Error: Configuration file not found: $CONFIG_PATH"
    exit 1
fi

# Create systemd service file
echo "Creating systemd service file..."

cat > /etc/systemd/system/${SERVICE_NAME}.service << SERVICEEOF
[Unit]
Description=Xray MITM Domain Fronting Service
After=network.target

[Service]
Type=simple
User=$SUDO_USER
WorkingDirectory=$WORKING_DIR/Xray-config
ExecStart=/usr/local/bin/xray run -c $CONFIG_PATH
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Reload systemd
systemctl daemon-reload

echo ""
echo "=========================================="
echo "Systemd service created successfully!"
echo ""
echo "Available commands:"
echo "  Start service:   sudo systemctl start $SERVICE_NAME"
echo "  Stop service:    sudo systemctl stop $SERVICE_NAME"
echo "  Enable at boot:  sudo systemctl enable $SERVICE_NAME"
echo "  Disable at boot: sudo systemctl disable $SERVICE_NAME"
echo "  Check status:    sudo systemctl status $SERVICE_NAME"
echo "  View logs:       sudo journalctl -u $SERVICE_NAME -f"
echo "=========================================="
