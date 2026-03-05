#!/bin/bash
# 03-build-kernel.sh - Build Linux kernel with NetHunter patches
# Target: PinePhone (Allwinner A64, aarch64)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/build}"
CROSS_COMPILE="${CROSS_COMPILE:-aarch64-linux-gnu-}"

KERNEL_REPO="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
KERNEL_BRANCH="v6.12"
KERNEL_DIR="$BUILD_DIR/linux"
ROOTFS_DIR="$BUILD_DIR/rootfs"

mkdir -p "$BUILD_DIR"

# -----------------------------------------------------------
# 1. Fetch kernel source
# -----------------------------------------------------------
echo "=== Fetching Linux kernel $KERNEL_BRANCH ==="
if [ ! -d "$KERNEL_DIR" ]; then
    git clone --depth 1 --branch "$KERNEL_BRANCH" "$KERNEL_REPO" "$KERNEL_DIR"
fi

# -----------------------------------------------------------
# 2. Apply NetHunter patches
# -----------------------------------------------------------
echo "=== Applying NetHunter kernel patches ==="
PATCH_DIR="$ROOT_DIR/patches/kernel"
if [ -d "$PATCH_DIR" ]; then
    for patch in "$PATCH_DIR"/*.patch; do
        [ -f "$patch" ] || continue
        echo "Applying: $(basename "$patch")"
        git -C "$KERNEL_DIR" apply --check "$patch" 2>/dev/null && \
            git -C "$KERNEL_DIR" apply "$patch" || \
            echo "WARNING: Patch $(basename "$patch") already applied or failed"
    done
fi

# -----------------------------------------------------------
# 3. Configure kernel
# -----------------------------------------------------------
echo "=== Configuring kernel ==="
cp "$ROOT_DIR/config/kernel_defconfig" "$KERNEL_DIR/.config"

make -C "$KERNEL_DIR" \
    ARCH=arm64 \
    CROSS_COMPILE="$CROSS_COMPILE" \
    olddefconfig

# -----------------------------------------------------------
# 4. Build kernel image, device trees, and modules
# -----------------------------------------------------------
echo "=== Building kernel ==="
make -C "$KERNEL_DIR" \
    ARCH=arm64 \
    CROSS_COMPILE="$CROSS_COMPILE" \
    -j"$(nproc)" \
    Image dtbs modules

# -----------------------------------------------------------
# 5. Install modules to rootfs staging area
# -----------------------------------------------------------
echo "=== Installing kernel modules ==="
mkdir -p "$ROOTFS_DIR"
make -C "$KERNEL_DIR" \
    ARCH=arm64 \
    CROSS_COMPILE="$CROSS_COMPILE" \
    INSTALL_MOD_PATH="$ROOTFS_DIR" \
    modules_install

# -----------------------------------------------------------
# 6. Copy build artifacts
# -----------------------------------------------------------
KERNEL_IMAGE="$KERNEL_DIR/arch/arm64/boot/Image"
DTB_FILE="$KERNEL_DIR/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone-1.2.dtb"

mkdir -p "$BUILD_DIR/boot"
cp "$KERNEL_IMAGE" "$BUILD_DIR/boot/Image"

if [ -f "$DTB_FILE" ]; then
    cp "$DTB_FILE" "$BUILD_DIR/boot/sun50i-a64-pinephone-1.2.dtb"
else
    # Try alternate DTB names
    for dtb in "$KERNEL_DIR"/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone*.dtb; do
        [ -f "$dtb" ] && cp "$dtb" "$BUILD_DIR/boot/"
    done
fi

# Generate boot.scr
mkimage -C none -A arm64 -T script \
    -d "$ROOT_DIR/config/boot.cmd" \
    "$BUILD_DIR/boot/boot.scr"

echo "=== Kernel build complete ==="
echo "Image: $BUILD_DIR/boot/Image"
echo "DTB:   $BUILD_DIR/boot/sun50i-a64-pinephone-1.2.dtb"
echo "Modules installed to: $ROOTFS_DIR/lib/modules/"
