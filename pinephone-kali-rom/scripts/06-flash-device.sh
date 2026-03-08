#!/bin/bash
# 06-flash-device.sh - Flash the built image to SD card / eMMC via dd
#
# Usage:
#   sudo ./scripts/06-flash-device.sh /dev/sdX
#   sudo ./scripts/06-flash-device.sh /dev/mmcblkX
#
# The script auto-detects the latest built image in the output directory.
# Set IMAGE_PATH to override:
#   IMAGE_PATH=/path/to/image.img.xz sudo ./scripts/06-flash-device.sh /dev/sdX

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT_DIR/output}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# -----------------------------------------------------------
# Validation
# -----------------------------------------------------------

if [ "$(id -u)" -ne 0 ]; then
    log_error "This script must be run as root"
    echo "Usage: sudo $0 /dev/sdX"
    exit 1
fi

TARGET_DEVICE="${1:-}"
if [ -z "$TARGET_DEVICE" ]; then
    log_error "No target device specified"
    echo ""
    echo "Usage: sudo $0 /dev/sdX"
    echo ""
    echo "Available removable block devices:"
    lsblk -dpno NAME,SIZE,MODEL,TRAN | grep -E 'usb|mmc' || echo "  (none detected)"
    echo ""
    echo "WARNING: Double-check the device before flashing!"
    exit 1
fi

# Safety checks
if [ ! -b "$TARGET_DEVICE" ]; then
    log_error "$TARGET_DEVICE is not a valid block device"
    exit 1
fi

# Refuse to flash to mounted system drives
SYSTEM_DISK="$(lsblk -ndo PKNAME / 2>/dev/null || true)"
if [ -n "$SYSTEM_DISK" ] && [ "$TARGET_DEVICE" = "/dev/$SYSTEM_DISK" ]; then
    log_error "Refusing to flash to system disk ($TARGET_DEVICE)"
    exit 1
fi

# Check the device isn't the root filesystem
ROOT_DEV="$(findmnt -no SOURCE / 2>/dev/null || true)"
if echo "$ROOT_DEV" | grep -q "$(basename "$TARGET_DEVICE")"; then
    log_error "Refusing to flash: $TARGET_DEVICE contains the root filesystem"
    exit 1
fi

# -----------------------------------------------------------
# Find image
# -----------------------------------------------------------

if [ -n "${IMAGE_PATH:-}" ]; then
    IMAGE="$IMAGE_PATH"
else
    # Find the newest .img.xz in output dir
    IMAGE="$(ls -t "$OUTPUT_DIR"/pinephone-kali-nethunter-*.img.xz 2>/dev/null | head -1 || true)"
fi

if [ -z "$IMAGE" ] || [ ! -f "$IMAGE" ]; then
    log_error "No image found in $OUTPUT_DIR"
    echo "Build the image first: sudo ./build.sh image"
    exit 1
fi

IMAGE_BASENAME="$(basename "$IMAGE")"
DEVICE_SIZE="$(lsblk -bdno SIZE "$TARGET_DEVICE" 2>/dev/null || echo "unknown")"
DEVICE_MODEL="$(lsblk -dno MODEL "$TARGET_DEVICE" 2>/dev/null || echo "unknown")"

# -----------------------------------------------------------
# Confirmation
# -----------------------------------------------------------

echo ""
echo "=========================================="
echo "  PinePhone Kali ROM - Flash to Device"
echo "=========================================="
echo ""
echo "  Image:   $IMAGE_BASENAME"
echo "  Target:  $TARGET_DEVICE"
echo "  Model:   $DEVICE_MODEL"
echo "  Size:    $(numfmt --to=iec "$DEVICE_SIZE" 2>/dev/null || echo "$DEVICE_SIZE")"
echo ""
log_warn "ALL DATA ON $TARGET_DEVICE WILL BE DESTROYED"
echo ""
read -r -p "Type YES to proceed: " CONFIRM

if [ "$CONFIRM" != "YES" ]; then
    log_info "Flash cancelled"
    exit 0
fi

# -----------------------------------------------------------
# Unmount any mounted partitions on target
# -----------------------------------------------------------

log_info "Unmounting any partitions on $TARGET_DEVICE..."
for part in "${TARGET_DEVICE}"*; do
    if mountpoint -q "$part" 2>/dev/null || mount | grep -q "^$part "; then
        umount "$part" 2>/dev/null || true
        log_info "  Unmounted $part"
    fi
done

# -----------------------------------------------------------
# Flash
# -----------------------------------------------------------

log_info "Flashing $IMAGE_BASENAME to $TARGET_DEVICE..."
echo ""

if [[ "$IMAGE" == *.img.xz ]]; then
    xz -d -c "$IMAGE" | dd of="$TARGET_DEVICE" bs=4M conv=fsync status=progress
elif [[ "$IMAGE" == *.img.gz ]]; then
    gzip -d -c "$IMAGE" | dd of="$TARGET_DEVICE" bs=4M conv=fsync status=progress
elif [[ "$IMAGE" == *.img ]]; then
    dd if="$IMAGE" of="$TARGET_DEVICE" bs=4M conv=fsync status=progress
else
    log_error "Unknown image format: $IMAGE"
    exit 1
fi

# -----------------------------------------------------------
# Sync and verify
# -----------------------------------------------------------

echo ""
log_info "Syncing buffers..."
sync

# Re-read partition table
partprobe "$TARGET_DEVICE" 2>/dev/null || true
sleep 1

log_info "Verifying partition table..."
if command -v sgdisk &>/dev/null; then
    sgdisk --verify "$TARGET_DEVICE" 2>/dev/null && log_info "Partition table OK" || log_warn "Partition table check returned warnings"
fi

echo ""
log_info "Partition layout:"
lsblk -o NAME,SIZE,FSTYPE,LABEL "$TARGET_DEVICE" 2>/dev/null || true

echo ""
echo "=========================================="
echo "  Flash Complete"
echo "=========================================="
echo ""
echo "  1. Insert the SD card into your PinePhone"
echo "  2. Hold Volume Down + Power to boot from SD"
echo "  3. Default credentials: kali / kali"
echo "  4. Connect via USB-C for serial console if needed"
echo ""
echo "=========================================="
