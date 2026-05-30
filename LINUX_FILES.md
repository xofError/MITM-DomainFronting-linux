# Linux Files Overview

This document lists all the Linux-specific files created for the MITM Domain Fronting project.

## Scripts Created

### Main Installation Scripts

1. **install_xray_linux.sh** (3.1 KB)
   - Automatically installs Xray-core on Linux
   - Supports Fedora, RHEL, CentOS, Ubuntu, Debian, Arch
   - Downloads latest version from GitHub
   - Installs to `/usr/local/bin/xray`
   - Requires sudo/root access

2. **quick_setup_linux.sh** (1.9 KB)
   - One-command setup script
   - Runs all installation steps automatically
   - Interactive with user prompts
   - Recommended for first-time users

### Certificate Management

3. **Xray-config/certificate_generator.sh** (744 bytes)
   - Generates self-signed certificate
   - Creates `mycert.crt` and `mycert.key`
   - Linux equivalent of `certificate_generator.bat`

4. **install_certificate_linux.sh** (2.6 KB)
   - Installs certificate to system trust store
   - Auto-detects Linux distribution
   - Supports Fedora/RHEL, Debian/Ubuntu, Arch
   - Requires sudo/root access

### Runtime Scripts

5. **run_xray_linux.sh** (1.5 KB)
   - Starts Xray with MITM configuration
   - Checks for required files
   - Displays proxy information
   - Easy start/stop

6. **setup_systemd_service.sh** (1.9 KB)
   - Creates systemd service for auto-start
   - Enables Xray to run at boot
   - Provides service management commands
   - Requires sudo/root access

### Helper Scripts

7. **configure_proxy.sh** (3.7 KB)
   - Helps configure system proxy settings
   - Auto-detects desktop environment (GNOME/KDE/XFCE)
   - Provides commands for manual configuration
   - Interactive menu for GNOME users

8. **troubleshoot.sh** (5.6 KB)
   - Comprehensive troubleshooting tool
   - Checks all components
   - Identifies common issues
   - Provides fix suggestions

## Documentation

9. **README_LINUX.md** (Large file)
   - Complete Linux setup guide
   - Both Persian (RTL) and English
   - Step-by-step instructions
   - Troubleshooting section
   - FAQ section

10. **LINUX_FILES.md** (This file)
    - Overview of all Linux files
    - Usage instructions
    - File descriptions

## Updated Files

11. **README.md** (Updated)
    - Added Linux setup section
    - Links to Linux documentation
    - Quick start commands

## Usage Flow

### For New Users (Recommended):

```bash
# One-command setup
./quick_setup_linux.sh

# Then manually:
# - Install certificate in browser
# - Start Xray
./run_xray_linux.sh

# Configure proxy
./configure_proxy.sh
```

### For Advanced Users:

```bash
# Step by step
sudo ./install_xray_linux.sh
cd Xray-config && ./certificate_generator.sh && cd ..
sudo ./install_certificate_linux.sh
# Install in browser manually
./run_xray_linux.sh
```

### For System Service:

```bash
# After basic setup
sudo ./setup_systemd_service.sh
sudo systemctl enable xray-mitm
sudo systemctl start xray-mitm
```

### For Troubleshooting:

```bash
./troubleshoot.sh
```

## File Permissions

All scripts have executable permissions (`chmod +x`):
- `install_xray_linux.sh` - Requires sudo
- `quick_setup_linux.sh` - Requires sudo (will prompt)
- `certificate_generator.sh` - No sudo needed
- `install_certificate_linux.sh` - Requires sudo
- `run_xray_linux.sh` - No sudo needed
- `setup_systemd_service.sh` - Requires sudo
- `configure_proxy.sh` - No sudo needed (for GNOME system proxy, no sudo)
- `troubleshoot.sh` - No sudo needed

## Distribution Support

### Tested/Supported:
- ✅ Fedora 38+
- ✅ RHEL 8+, CentOS 8+, Rocky Linux, AlmaLinux
- ✅ Ubuntu 20.04+, 22.04+, 24.04+
- ✅ Debian 11+, 12+
- ✅ Linux Mint
- ✅ Arch Linux, Manjaro

### Should Work:
- openSUSE (manual certificate installation may be needed)
- Other systemd-based distributions

## Architecture Support

- ✅ x86_64 (AMD64)
- ✅ ARM64 (aarch64)
- ✅ ARMv7

## Requirements

- Linux kernel 3.10+
- systemd (for service management)
- 50MB free disk space
- Internet connection
- Root/sudo access (for installation)

## Security Notes

1. All scripts validate input and check for required files
2. Certificate private key (`mycert.key`) is never transmitted
3. Scripts use `set -e` for error handling
4. Sudo is only requested when necessary
5. No hardcoded passwords or secrets

## Maintenance

To update Xray to the latest version:
```bash
sudo ./install_xray_linux.sh
```

To regenerate certificates (if needed):
```bash
cd Xray-config
./certificate_generator.sh
sudo ../install_certificate_linux.sh
# Reinstall in browser
```

## Uninstallation

See README_LINUX.md for complete uninstallation instructions.

Quick uninstall:
```bash
# Stop service
sudo systemctl stop xray-mitm
sudo systemctl disable xray-mitm
sudo rm /etc/systemd/system/xray-mitm.service

# Remove Xray
sudo rm /usr/local/bin/xray
sudo rm -rf /usr/local/share/xray

# Remove certificate (Fedora/RHEL)
sudo rm /etc/pki/ca-trust/source/anchors/mycert.crt
sudo update-ca-trust

# Remove certificate (Debian/Ubuntu)
sudo rm /usr/local/share/ca-certificates/mycert.crt
sudo update-ca-certificates
```

## Contributing

When adding new features for Linux:
1. Follow the existing script structure
2. Support multiple distributions
3. Add error checking
4. Update this documentation
5. Test on at least 2 distributions

## Credits

Linux implementation by: @patterniha
Original project: @patterniha

## License

Same as main project (see LICENSE file)
