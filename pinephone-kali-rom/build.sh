#!/bin/bash
# build.sh - PinePhone Kali NetHunter ROM Master Build Script
#
# Builds a complete flashable SD card image for PinePhone (Allwinner A64)
# with Kali Linux and NetHunter kernel patches.
#
# Usage:
#   sudo ./build.sh              # Build everything
#   sudo ./build.sh setup        # Install host dependencies only
#   sudo ./build.sh uboot        # Build U-Boot + ATF + Crust
#   sudo ./build.sh kernel       # Build kernel with NetHunter patches
#   sudo ./build.sh rootfs       # Build Kali arm64 rootfs
#   sudo ./build.sh image        # Assemble flashable image
#   sudo ./build.sh clean        # Remove build artifacts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export BUILD_DIR="${BUILD_DIR:-$SCRIPT_DIR/build}"
export OUTPUT_DIR="${OUTPUT_DIR:-$SCRIPT_DIR/output}"
export CROSS_COMPILE="${CROSS_COMPILE:-aarch64-linux-gnu-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        log_error "This script must be run as root (for debootstrap and losetup)"
        echo "Usage: sudo $0 [stage]"
        exit 1
    fi
}

run_stage() {
    local stage="$1"
    local script="$SCRIPT_DIR/scripts/$stage"

    if [ ! -f "$script" ]; then
        log_error "Script not found: $script"
        exit 1
    fi

    log_info "=========================================="
    log_info "Running: $(basename "$script")"
    log_info "=========================================="

    bash "$script"

    log_info "Completed: $(basename "$script")"
    echo ""
}

do_clean() {
    log_warn "Removing build directory: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
    log_info "Clean complete"
}

show_usage() {
    echo "PinePhone Kali NetHunter ROM Builder"
    echo ""
    echo "Usage: sudo $0 [command]"
    echo ""
    echo "Commands:"
    echo "  all      Build everything (default)"
    echo "  setup    Install host build dependencies"
    echo "  uboot    Build U-Boot + ATF + Crust firmware"
    echo "  kernel   Build Linux kernel with NetHunter patches"
    echo "  rootfs   Build Kali arm64 root filesystem"
    echo "  image    Assemble flashable SD card image"
    echo "  clean    Remove all build artifacts"
    echo ""
    echo "Environment variables:"
    echo "  BUILD_DIR      Build directory (default: ./build)"
    echo "  OUTPUT_DIR     Output directory (default: ./output)"
    echo "  CROSS_COMPILE  Cross compiler prefix (default: aarch64-linux-gnu-)"
}

# Main
COMMAND="${1:-all}"

case "$COMMAND" in
    setup)
        check_root
        run_stage "01-setup-host.sh"
        ;;
    uboot)
        check_root
        run_stage "02-build-uboot.sh"
        ;;
    kernel)
        run_stage "03-build-kernel.sh"
        ;;
    rootfs)
        check_root
        run_stage "04-build-rootfs.sh"
        ;;
    image)
        check_root
        run_stage "05-build-image.sh"
        ;;
    all)
        check_root
        log_info "Building PinePhone Kali NetHunter ROM - Full Build"
        log_info "Build dir: $BUILD_DIR"
        log_info "Output dir: $OUTPUT_DIR"
        echo ""

        run_stage "01-setup-host.sh"
        run_stage "02-build-uboot.sh"
        run_stage "03-build-kernel.sh"
        run_stage "04-build-rootfs.sh"
        run_stage "05-build-image.sh"

        log_info "=========================================="
        log_info "  BUILD COMPLETE"
        log_info "=========================================="
        log_info "Image ready in: $OUTPUT_DIR/"
        ls -lh "$OUTPUT_DIR/"*.img.xz 2>/dev/null || true
        ;;
    clean)
        do_clean
        ;;
    -h|--help|help)
        show_usage
        ;;
    *)
        log_error "Unknown command: $COMMAND"
        show_usage
        exit 1
        ;;
esac
