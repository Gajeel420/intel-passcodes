#!/bin/bash
# 04-build-rootfs.sh - Build Kali Linux arm64 rootfs
# Lean pentesting computer - NO phone/telephony packages

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/build}"
ROOTFS_DIR="$BUILD_DIR/rootfs"
KALI_MIRROR="http://http.kali.org/kali"

HOSTNAME="pinephone-kali"
ROOT_PASSWORD="toor"
USERNAME="kali"
USER_PASSWORD="kali"

# -----------------------------------------------------------
# 1. Bootstrap Kali rootfs
# -----------------------------------------------------------
echo "=== Bootstrapping Kali Linux arm64 rootfs ==="
mkdir -p "$ROOTFS_DIR"

if [ ! -f "$ROOTFS_DIR/etc/os-release" ]; then
    debootstrap --arch=arm64 --foreign kali-rolling "$ROOTFS_DIR" "$KALI_MIRROR"

    # Copy qemu for arm64 chroot on x86 host
    cp /usr/bin/qemu-aarch64-static "$ROOTFS_DIR/usr/bin/" 2>/dev/null || true

    # Complete second stage
    chroot "$ROOTFS_DIR" /debootstrap/debootstrap --second-stage
fi

# -----------------------------------------------------------
# 2. Configure APT sources
# -----------------------------------------------------------
cat > "$ROOTFS_DIR/etc/apt/sources.list" << 'EOF'
deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
EOF

# -----------------------------------------------------------
# 3. Mount virtual filesystems for chroot
# -----------------------------------------------------------
cleanup_mounts() {
    umount "$ROOTFS_DIR/proc" 2>/dev/null || true
    umount "$ROOTFS_DIR/sys" 2>/dev/null || true
    umount "$ROOTFS_DIR/dev/pts" 2>/dev/null || true
    umount "$ROOTFS_DIR/dev" 2>/dev/null || true
}
trap cleanup_mounts EXIT

mount --bind /proc "$ROOTFS_DIR/proc"
mount --bind /sys "$ROOTFS_DIR/sys"
mount --bind /dev "$ROOTFS_DIR/dev"
mount --bind /dev/pts "$ROOTFS_DIR/dev/pts"

# -----------------------------------------------------------
# 4. Install packages inside chroot
# -----------------------------------------------------------
echo "=== Installing packages ==="

# Read package list, strip comments and blank lines
PACKAGES=$(grep -v '^\s*#' "$ROOT_DIR/config/packages.list" | grep -v '^\s*$' | tr '\n' ' ')

cat > "$ROOTFS_DIR/tmp/install.sh" << CHROOT_EOF
#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C

apt-get update
apt-get install -y --no-install-recommends $PACKAGES

# -----------------------------------------------------------
# 5. User setup
# -----------------------------------------------------------
echo "root:${ROOT_PASSWORD}" | chpasswd
useradd -m -G sudo,plugdev,netdev,bluetooth -s /bin/bash ${USERNAME} || true
echo "${USERNAME}:${USER_PASSWORD}" | chpasswd

# -----------------------------------------------------------
# 6. Locale and timezone
# -----------------------------------------------------------
sed -i 's/# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/default/locale
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# -----------------------------------------------------------
# 7. Hostname
# -----------------------------------------------------------
echo "${HOSTNAME}" > /etc/hostname
cat > /etc/hosts << HOSTS_EOF
127.0.0.1   localhost
127.0.1.1   ${HOSTNAME}
HOSTS_EOF

# -----------------------------------------------------------
# 8. Networking - WiFi only, NO modem
# -----------------------------------------------------------
systemctl enable NetworkManager
systemctl enable ssh
systemctl enable bluetooth
systemctl enable lightdm

# Disable serial console getty for modem port
systemctl mask serial-getty@ttyUSB0.service 2>/dev/null || true
systemctl mask serial-getty@ttyUSB1.service 2>/dev/null || true
systemctl mask serial-getty@ttyUSB2.service 2>/dev/null || true

# -----------------------------------------------------------
# 9. REMOVE phone/telephony bloat
# -----------------------------------------------------------
apt-get purge -y \
    modemmanager \
    ofono \
    eg25-manager \
    mmsd-tng \
    chatty \
    gnome-calls \
    gnome-contacts \
    2>/dev/null || true

systemctl mask ModemManager.service 2>/dev/null || true
systemctl mask ofono.service 2>/dev/null || true
systemctl mask eg25-manager.service 2>/dev/null || true

# Configure NetworkManager to NOT use ModemManager
mkdir -p /etc/NetworkManager/conf.d
cat > /etc/NetworkManager/conf.d/no-modem.conf << NM_EOF
[main]
plugins=ifupdown,keyfile
no-auto-default=*

[keyfile]
unmanaged-devices=interface-name:wwan*;interface-name:cdc-wdm*
NM_EOF

# -----------------------------------------------------------
# 10. Enable serial console (for debug via headphone jack UART)
# -----------------------------------------------------------
systemctl enable serial-getty@ttyS0.service

# -----------------------------------------------------------
# 11. Clean up
# -----------------------------------------------------------
apt-get autoremove -y
apt-get clean
rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/*

CHROOT_EOF

chmod +x "$ROOTFS_DIR/tmp/install.sh"
chroot "$ROOTFS_DIR" /tmp/install.sh

# -----------------------------------------------------------
# 12. Copy overlay files
# -----------------------------------------------------------
echo "=== Applying overlay files ==="
if [ -d "$ROOT_DIR/overlays" ]; then
    rsync -a "$ROOT_DIR/overlays/" "$ROOTFS_DIR/"
fi

# -----------------------------------------------------------
# 13. Install PinePhone WiFi/BT firmware (RTL8723CS)
# -----------------------------------------------------------
echo "=== Installing RTL8723CS firmware ==="
FIRMWARE_DIR="$ROOTFS_DIR/lib/firmware/rtl_bt"
mkdir -p "$FIRMWARE_DIR"
mkdir -p "$ROOTFS_DIR/lib/firmware/rtlwifi"

# Firmware is typically provided by firmware-realtek package
# Verify it exists
if [ ! -d "$ROOTFS_DIR/lib/firmware/rtlwifi" ]; then
    echo "WARNING: RTL firmware directory missing. WiFi may not work without firmware-realtek."
fi

# -----------------------------------------------------------
# 14. fstab
# -----------------------------------------------------------
cat > "$ROOTFS_DIR/etc/fstab" << 'FSTAB_EOF'
# PinePhone Kali NetHunter - /etc/fstab
/dev/mmcblk0p2  /       ext4    defaults,noatime    0 1
/dev/mmcblk0p1  /boot   vfat    defaults            0 2
tmpfs           /tmp    tmpfs   defaults,nosuid     0 0
FSTAB_EOF

# Clean up qemu binary
rm -f "$ROOTFS_DIR/usr/bin/qemu-aarch64-static"

echo "=== Rootfs build complete: $ROOTFS_DIR ==="
