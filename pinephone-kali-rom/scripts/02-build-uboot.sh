#!/bin/bash
# 02-build-uboot.sh - Build U-Boot + ARM Trusted Firmware + Crust SCP
# Target: PinePhone (Allwinner A64)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/build}"
CROSS_COMPILE="${CROSS_COMPILE:-aarch64-linux-gnu-}"

ATF_REPO="https://github.com/ARM-software/arm-trusted-firmware.git"
ATF_BRANCH="v2.10"
CRUST_REPO="https://github.com/crust-firmware/crust.git"
CRUST_BRANCH="v0.6"
UBOOT_REPO="https://source.denx.de/u-boot/u-boot.git"
UBOOT_BRANCH="v2025.01"

mkdir -p "$BUILD_DIR"

# -----------------------------------------------------------
# 1. Build ARM Trusted Firmware (BL31)
# -----------------------------------------------------------
echo "=== Building ARM Trusted Firmware ==="
ATF_DIR="$BUILD_DIR/arm-trusted-firmware"
if [ ! -d "$ATF_DIR" ]; then
    git clone --depth 1 --branch "$ATF_BRANCH" "$ATF_REPO" "$ATF_DIR"
fi

make -C "$ATF_DIR" \
    CROSS_COMPILE="$CROSS_COMPILE" \
    PLAT=sun50i_a64 \
    DEBUG=0 \
    bl31 \
    -j"$(nproc)"

BL31="$ATF_DIR/build/sun50i_a64/release/bl31.bin"
echo "BL31 built: $BL31"

# -----------------------------------------------------------
# 2. Build Crust SCP Firmware
# -----------------------------------------------------------
echo "=== Building Crust SCP Firmware ==="
CRUST_DIR="$BUILD_DIR/crust"
if [ ! -d "$CRUST_DIR" ]; then
    git clone --depth 1 --branch "$CRUST_BRANCH" "$CRUST_REPO" "$CRUST_DIR"
fi

if command -v or1k-elf-gcc &>/dev/null; then
    make -C "$CRUST_DIR" pinephone_defconfig
    make -C "$CRUST_DIR" CROSS_COMPILE=or1k-elf- -j"$(nproc)" scp
    SCP="$CRUST_DIR/build/scp/scp.bin"
    echo "SCP built: $SCP"
else
    echo "WARNING: or1k-elf-gcc not found, skipping Crust SCP build"
    echo "Power management (suspend/resume) will not work without Crust"
    SCP="/dev/null"
fi

# -----------------------------------------------------------
# 3. Build U-Boot
# -----------------------------------------------------------
echo "=== Building U-Boot ==="
UBOOT_DIR="$BUILD_DIR/u-boot"
if [ ! -d "$UBOOT_DIR" ]; then
    git clone --depth 1 --branch "$UBOOT_BRANCH" "$UBOOT_REPO" "$UBOOT_DIR"
fi

make -C "$UBOOT_DIR" pinephone_defconfig
make -C "$UBOOT_DIR" \
    CROSS_COMPILE="$CROSS_COMPILE" \
    BL31="$BL31" \
    SCP="$SCP" \
    -j"$(nproc)"

UBOOT_BIN="$UBOOT_DIR/u-boot-sunxi-with-spl.bin"
echo "=== U-Boot built: $UBOOT_BIN ==="

# Copy final artifact
cp "$UBOOT_BIN" "$BUILD_DIR/u-boot-sunxi-with-spl.bin"
echo "Copied to: $BUILD_DIR/u-boot-sunxi-with-spl.bin"
