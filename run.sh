#!/bin/bash

# Assemble the bootloader and kernel
nasm -f bin -o stage1.bin stage1.asm
nasm -f bin -o stage2.bin stage2.asm

# Create an empty disk image
dd if=/dev/zero of=disk.img bs=512 count=2880

# Write the bootloader to the disk image
dd if=stage1.bin of=disk.img bs=512 count=1 conv=notrunc

# Write the kernel to the disk image at offset 0x8000
dd if=stage2.bin of=disk.img bs=512 seek=16 conv=notrunc

echo "Bootable disk image created: disk.img"

# Test the disk image with QEMU
qemu-system-x86_64 -drive format=raw,file=disk.img
