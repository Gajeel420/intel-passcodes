#!/bin/bash
# 05-build-image.sh - Assemble flashable SD card image
# Output: compressed .img.xz ready for dd or balenaEtcher

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/build}"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT_DIR/output}"
ROOTFS_DIR="$BUILD_DIR/rootfs"

IMAGE_SIZE_MB=4096
IMAGE_NAME="pinephone-kali-nethunter-$(date +%Y%m%d)"
IMAGE_FILE="$BUILD_DIR/${IMAGE_NAME}.img"
BOOT_SIZE_MB=256

mkdir -p "$OUTPUT_DIR"

# -----------------------------------------------------------
# 1. Create sparse image file
# -----------------------------------------------------------
echo "=== Creating ${IMAGE_SIZE_MB}MB disk image ==="
dd if=/dev/zero of="$IMAGE_FILE" bs=1M count=0 seek="$IMAGE_SIZE_MB" status=none

# -----------------------------------------------------------
# 2. Partition the image (GPT)
# -----------------------------------------------------------
echo "=== Partitioning image ==="
sgdisk --clear \
    --new=1:4096:+${BOOT_SIZE_MB}M --typecode=1:EF00 --change-name=1:boot \
    --new=2:0:0 --typecode=2:8300 --change-name=2:root \
    "$IMAGE_FILE"

# -----------------------------------------------------------
# 3. Write U-Boot SPL at 8KiB offset (sector 16)
# -----------------------------------------------------------
echo "=== Writing U-Boot ==="
UBOOT_BIN="$BUILD_DIR/u-boot-sunxi-with-spl.bin"
if [ ! -f "$UBOOT_BIN" ]; then
    echo "ERROR: U-Boot binary not found: $UBOOT_BIN"
    echo "Run 02-build-uboot.sh first"
    exit 1
fi
dd if="$UBOOT_BIN" of="$IMAGE_FILE" bs=1024 seek=8 conv=notrunc status=none

# -----------------------------------------------------------
# 4. Setup loop device and format partitions
# -----------------------------------------------------------
echo "=== Setting up loop device ==="
LOOP_DEV=$(losetup --find --show --partscan "$IMAGE_FILE")

cleanup_loop() {
    echo "=== Cleaning up ==="
    umount "${LOOP_DEV}p2" 2>/dev/null || true
    umount "${LOOP_DEV}p1" 2>/dev/null || true
    losetup -d "$LOOP_DEV" 2>/dev/null || true
}
trap cleanup_loop EXIT

# Wait for partition devices
sleep 1
partprobe "$LOOP_DEV" 2>/dev/null || true
sleep 1

echo "=== Formatting partitions ==="
mkfs.vfat -F 32 -n BOOT "${LOOP_DEV}p1"
mkfs.ext4 -L root -O ^metadata_csum "${LOOP_DEV}p2"

# -----------------------------------------------------------
# 5. Mount and populate boot partition
# -----------------------------------------------------------
echo "=== Populating boot partition ==="
BOOT_MNT="$BUILD_DIR/mnt_boot"
ROOT_MNT="$BUILD_DIR/mnt_root"
mkdir -p "$BOOT_MNT" "$ROOT_MNT"

mount "${LOOP_DEV}p1" "$BOOT_MNT"

# Copy kernel, DTB, boot script
if [ ! -f "$BUILD_DIR/boot/Image" ]; then
    echo "ERROR: Kernel image not found. Run 03-build-kernel.sh first"
    exit 1
fi

cp "$BUILD_DIR/boot/Image" "$BOOT_MNT/"
cp "$BUILD_DIR/boot/"*.dtb "$BOOT_MNT/" 2>/dev/null || true
cp "$BUILD_DIR/boot/boot.scr" "$BOOT_MNT/" 2>/dev/null || true

umount "$BOOT_MNT"

# -----------------------------------------------------------
# 6. Mount and populate root partition
# -----------------------------------------------------------
echo "=== Populating root partition ==="
mount "${LOOP_DEV}p2" "$ROOT_MNT"

if [ ! -d "$ROOTFS_DIR/etc" ]; then
    echo "ERROR: Rootfs not found. Run 04-build-rootfs.sh first"
    exit 1
fi

rsync -a --info=progress2 "$ROOTFS_DIR/" "$ROOT_MNT/"

# Create boot mountpoint in rootfs
mkdir -p "$ROOT_MNT/boot"

sync
umount "$ROOT_MNT"

# -----------------------------------------------------------
# 7. Detach loop device
# -----------------------------------------------------------
losetup -d "$LOOP_DEV"
trap - EXIT

# -----------------------------------------------------------
# 8. Compress the image
# -----------------------------------------------------------
echo "=== Compressing image with xz ==="
xz -T0 -9 --force "$IMAGE_FILE"

# Move to output directory
mv "${IMAGE_FILE}.xz" "$OUTPUT_DIR/"

echo ""
echo "=========================================="
echo "  PinePhone Kali NetHunter Image Ready"
echo "=========================================="
echo "Output: $OUTPUT_DIR/${IMAGE_NAME}.img.xz"
echo ""
echo "Flash to SD card:"
echo "  xz -d -c $OUTPUT_DIR/${IMAGE_NAME}.img.xz | sudo dd of=/dev/sdX bs=4M status=progress"
echo ""
echo "Or use balenaEtcher with the .img.xz file directly."
echo "=========================================="
