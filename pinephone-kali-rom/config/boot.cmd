# PinePhone Kali NetHunter - U-Boot boot script
# Compile with: mkimage -C none -A arm64 -T script -d boot.cmd boot.scr

setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait rw quiet loglevel=4

echo "Loading PinePhone Kali NetHunter..."
load mmc 0:1 ${kernel_addr_r} Image
load mmc 0:1 ${fdt_addr_r} sun50i-a64-pinephone-1.2.dtb

booti ${kernel_addr_r} - ${fdt_addr_r}
