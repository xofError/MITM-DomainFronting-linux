#!/bin/bash

# Troubleshooting Script for MITM Domain Fronting

echo "=========================================="
echo "MITM Domain Fronting - Troubleshooting"
echo "=========================================="
echo ""

# Check if xray is installed
echo "1. Checking Xray installation..."
if command -v xray &> /dev/null; then
    echo "   ✓ Xray is installed"
    xray version | head -n 1
else
    echo "   ✗ Xray is NOT installed"
    echo "   Run: sudo ./install_xray_linux.sh"
fi
echo ""

# Check certificate files
echo "2. Checking certificate files..."
if [ -f "mycert.crt" ]; then
    echo "   ✓ mycert.crt exists"
else
    echo "   ✗ mycert.crt NOT found"
    echo "   Run: cd Xray-config && ./certificate_generator.sh"
fi

if [ -f "mycert.key" ]; then
    echo "   ✓ mycert.key exists"
else
    echo "   ✗ mycert.key NOT found"
    echo "   Run: cd Xray-config && ./certificate_generator.sh"
fi
echo ""

# Check if certificate is in Xray-config directory
echo "3. Checking certificate location..."
if [ -f "Xray-config/mycert.crt" ] && [ -f "Xray-config/mycert.key" ]; then
    echo "   ✓ Certificates are in Xray-config directory"
else
    echo "   ⚠ Certificates not in Xray-config directory"
    if [ -f "mycert.crt" ] && [ -f "mycert.key" ]; then
        echo "   Copying certificates to Xray-config..."
        cp mycert.crt mycert.key Xray-config/
        echo "   ✓ Certificates copied"
    fi
fi
echo ""

# Check config file
echo "4. Checking configuration file..."
if [ -f "Xray-config/MITM-DomainFronting.json" ]; then
    echo "   ✓ Configuration file exists"
else
    echo "   ✗ Configuration file NOT found"
fi
echo ""

# Check if Xray is running
echo "5. Checking if Xray is running..."
if pgrep -x "xray" > /dev/null; then
    echo "   ✓ Xray is running"
    echo "   PID: $(pgrep -x xray)"
else
    echo "   ✗ Xray is NOT running"
    echo "   Start with: ./run_xray_linux.sh"
fi
echo ""

# Check if port 10808 is listening
echo "6. Checking proxy port..."
if ss -tlnp 2>/dev/null | grep -q ":10808"; then
    echo "   ✓ Port 10808 is listening"
elif netstat -tlnp 2>/dev/null | grep -q ":10808"; then
    echo "   ✓ Port 10808 is listening"
else
    echo "   ✗ Port 10808 is NOT listening"
    echo "   Make sure Xray is running"
fi
echo ""

# Check system certificate store
echo "7. Checking system certificate installation..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        fedora|rhel|centos|rocky|almalinux)
            if [ -f /etc/pki/ca-trust/source/anchors/mycert.crt ]; then
                echo "   ✓ Certificate installed in system trust store (Fedora/RHEL)"
            else
                echo "   ✗ Certificate NOT in system trust store"
                echo "   Run: sudo ./install_certificate_linux.sh"
            fi
            ;;
        debian|ubuntu|linuxmint)
            if [ -f /usr/local/share/ca-certificates/mycert.crt ]; then
                echo "   ✓ Certificate installed in system trust store (Debian/Ubuntu)"
            else
                echo "   ✗ Certificate NOT in system trust store"
                echo "   Run: sudo ./install_certificate_linux.sh"
            fi
            ;;
        arch|manjaro)
            if [ -f /etc/ca-certificates/trust-source/anchors/mycert.crt ]; then
                echo "   ✓ Certificate installed in system trust store (Arch)"
            else
                echo "   ✗ Certificate NOT in system trust store"
                echo "   Run: sudo ./install_certificate_linux.sh"
            fi
            ;;
        *)
            echo "   ? Unknown distribution, cannot check"
            ;;
    esac
fi
echo ""

# Check proxy settings (GNOME)
echo "8. Checking system proxy settings (GNOME)..."
if command -v gsettings &> /dev/null; then
    PROXY_MODE=$(gsettings get org.gnome.system.proxy mode 2>/dev/null)
    if [ "$PROXY_MODE" = "'manual'" ]; then
        echo "   ✓ System proxy is enabled (manual mode)"
        HTTP_HOST=$(gsettings get org.gnome.system.proxy.http host 2>/dev/null)
        HTTP_PORT=$(gsettings get org.gnome.system.proxy.http port 2>/dev/null)
        echo "   HTTP Proxy: $HTTP_HOST:$HTTP_PORT"
    elif [ "$PROXY_MODE" = "'none'" ]; then
        echo "   ⚠ System proxy is disabled"
        echo "   Enable with: ./configure_proxy.sh"
    else
        echo "   ? Proxy mode: $PROXY_MODE"
    fi
else
    echo "   - Not using GNOME, skipping"
fi
echo ""

# Test connectivity
echo "9. Testing basic connectivity..."
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo "   ✓ Internet connection is working"
else
    echo "   ✗ No internet connection"
fi
echo ""

# Summary
echo "=========================================="
echo "Summary"
echo "=========================================="
echo ""

ISSUES=0

if ! command -v xray &> /dev/null; then
    echo "⚠ Issue: Xray not installed"
    ((ISSUES++))
fi

if [ ! -f "mycert.crt" ] || [ ! -f "mycert.key" ]; then
    echo "⚠ Issue: Certificate files missing"
    ((ISSUES++))
fi

if ! pgrep -x "xray" > /dev/null; then
    echo "⚠ Issue: Xray not running"
    ((ISSUES++))
fi

if [ $ISSUES -eq 0 ]; then
    echo "✓ No major issues found!"
    echo ""
    echo "If you still have problems:"
    echo "1. Make sure certificate is installed in your browser"
    echo "2. Configure proxy to 127.0.0.1:10808"
    echo "3. Check Xray logs: cd Xray-config && xray run -c MITM-DomainFronting.json"
else
    echo "Found $ISSUES issue(s). Please fix them and try again."
fi

echo ""
echo "For more help, see README_LINUX.md"
echo "=========================================="
