# Define the tools we'll be using
AS = nasm
CC = i686-elf-gcc
LD = i686-elf-ld
CFLAGS = -m32 -ffreestanding -fno-pic -fno-stack-protector -nostdlib -nostartfiles -nodefaultlibs -Wall -Wextra
LDFLAGS = -m elf_i386 -T linker.ld --oformat binary

# Define the target binary and intermediate object files
KERNEL_BIN = kernel.bin
STAGE1_BIN = stage1.bin
DISK_IMG = disk.img
OBJS = kern_entry.o kernel.o

# Build the disk image
all: $(DISK_IMG)

# Assemble the stage1 and stage2 bootloaders
$(STAGE1_BIN): stage1.asm
	$(AS) -f bin -o $@ $<

# Compile and link the kernel
$(KERNEL_BIN): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

kern_entry.o: kern_entry.asm
	$(AS) -f elf -o $@ $<

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Create the disk image and write the bootloader and kernel to it
$(DISK_IMG): $(STAGE1_BIN) $(KERNEL_BIN)
	dd if=/dev/zero of=$(DISK_IMG) bs=512 count=2880
	dd if=$(STAGE1_BIN) of=$(DISK_IMG) bs=512 count=1 conv=notrunc
	dd if=$(KERNEL_BIN) of=$(DISK_IMG) bs=512 seek=2 conv=notrunc

# Clean up the build artifacts
clean:
	rm -f $(STAGE1_BIN) $(KERNEL_BIN) $(OBJS) $(DISK_IMG)

run:
	qemu-system-x86_64 $(DISK_IMG)

# Phony targets
.PHONY: all clean
