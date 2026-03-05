#!/bin/bash
# 01-setup-host.sh - Install host build dependencies
# Run on Debian/Ubuntu/Kali host system

set -euo pipefail

echo "=== Installing PinePhone Kali ROM build dependencies ==="

apt-get update
apt-get install -y \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    u-boot-tools \
    binfmt-support \
    qemu-user-static \
    debootstrap \
    device-tree-compiler \
    swig \
    python3-dev \
    python3-setuptools \
    libssl-dev \
    flex \
    bison \
    bc \
    kmod \
    cpio \
    xz-utils \
    parted \
    gdisk \
    dosfstools \
    e2fsprogs \
    mtools \
    libncurses-dev \
    rsync \
    git \
    wget \
    make \
    gcc \
    libc6-dev \
    kpartx \
    losetup \
    gawk

# or1k toolchain for Crust SCP firmware
if ! command -v or1k-elf-gcc &>/dev/null; then
    echo "=== Installing OpenRISC toolchain for Crust SCP ==="
    apt-get install -y gcc-or1k-elf || {
        echo "WARNING: or1k-elf-gcc not in repos. Install manually or skip Crust build."
        echo "See: https://musl.cc/or1k-linux-musl-cross.tgz"
    }
fi

# Enable binfmt for arm64 chroot
update-binfmts --enable qemu-aarch64 2>/dev/null || true

echo "=== Host dependencies installed ==="
