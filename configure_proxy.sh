#!/bin/bash

# Proxy Configuration Helper Script
# This script helps configure system proxy settings

PROXY_HOST="127.0.0.1"
PROXY_PORT="10808"

echo "=========================================="
echo "Proxy Configuration Helper"
echo "=========================================="
echo ""
echo "Proxy Address: $PROXY_HOST:$PROXY_PORT"
echo ""

# Detect desktop environment
if [ -n "$GNOME_DESKTOP_SESSION_ID" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    DE="GNOME"
elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    DE="KDE"
elif [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
    DE="XFCE"
else
    DE="Unknown"
fi

echo "Detected Desktop Environment: $DE"
echo ""

if [ "$DE" = "GNOME" ]; then
    echo "GNOME Desktop detected"
    echo ""
    echo "Choose an option:"
    echo "1) Enable system proxy"
    echo "2) Disable system proxy"
    echo "3) Show current proxy settings"
    echo "4) Exit"
    echo ""
    read -p "Enter choice [1-4]: " choice
    
    case $choice in
        1)
            echo "Enabling system proxy..."
            gsettings set org.gnome.system.proxy mode 'manual'
            gsettings set org.gnome.system.proxy.http host "$PROXY_HOST"
            gsettings set org.gnome.system.proxy.http port $PROXY_PORT
            gsettings set org.gnome.system.proxy.https host "$PROXY_HOST"
            gsettings set org.gnome.system.proxy.https port $PROXY_PORT
            gsettings set org.gnome.system.proxy.socks host "$PROXY_HOST"
            gsettings set org.gnome.system.proxy.socks port $PROXY_PORT
            echo "System proxy enabled!"
            ;;
        2)
            echo "Disabling system proxy..."
            gsettings set org.gnome.system.proxy mode 'none'
            echo "System proxy disabled!"
            ;;
        3)
            echo "Current proxy settings:"
            echo "Mode: $(gsettings get org.gnome.system.proxy mode)"
            echo "HTTP: $(gsettings get org.gnome.system.proxy.http host):$(gsettings get org.gnome.system.proxy.http port)"
            echo "HTTPS: $(gsettings get org.gnome.system.proxy.https host):$(gsettings get org.gnome.system.proxy.https port)"
            echo "SOCKS: $(gsettings get org.gnome.system.proxy.socks host):$(gsettings get org.gnome.system.proxy.socks port)"
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Invalid choice"
            exit 1
            ;;
    esac
    
elif [ "$DE" = "KDE" ]; then
    echo "KDE Desktop detected"
    echo ""
    echo "For KDE, please configure proxy manually:"
    echo "System Settings → Network → Proxy"
    echo ""
    echo "Use these settings:"
    echo "  HTTP Proxy: $PROXY_HOST:$PROXY_PORT"
    echo "  HTTPS Proxy: $PROXY_HOST:$PROXY_PORT"
    echo "  SOCKS Proxy: $PROXY_HOST:$PROXY_PORT"
    
else
    echo "Manual proxy configuration required"
    echo ""
    echo "Configure your system/browser to use:"
    echo "  HTTP Proxy: $PROXY_HOST:$PROXY_PORT"
    echo "  HTTPS Proxy: $PROXY_HOST:$PROXY_PORT"
    echo "  SOCKS Proxy: $PROXY_HOST:$PROXY_PORT"
    echo ""
    echo "For Firefox:"
    echo "  Settings → General → Network Settings → Manual proxy configuration"
    echo ""
    echo "For Chrome/Chromium:"
    echo "  Use a proxy extension like SwitchyOmega"
fi

echo ""
echo "=========================================="
echo "Environment Variables (for terminal apps):"
echo "=========================================="
echo ""
echo "Add these to your ~/.bashrc or ~/.zshrc:"
echo ""
echo "export http_proxy=\"http://$PROXY_HOST:$PROXY_PORT\""
echo "export https_proxy=\"http://$PROXY_HOST:$PROXY_PORT\""
echo "export HTTP_PROXY=\"http://$PROXY_HOST:$PROXY_PORT\""
echo "export HTTPS_PROXY=\"http://$PROXY_HOST:$PROXY_PORT\""
echo ""
