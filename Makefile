C_SOURCES 	= $(wildcard kernel/utilities/*.c kernel/drivers/*.c)
HEADERS 	= $(wildcard kernel/utilities/*.h kernel/drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

CFLAGS+="-ffreestanding"
CFLAGS+="-m32"
CFLAGS+="-fno-pic"
CFLAGS+="-nostdlib"

KERNEL="kernel/kernel.c"
KERNEL_O="kernel/bin/kernel.o"
KERNEL_BIN="kernel/bin/kernel.bin"
KERNEL_LINK="kernel/kernel_entry.asm"
KERNEL_LINK_O="kernel/bin/kernel_entry.o"
bootloader="boot/bootloader.asm"
bootloader_BIN="boot/bin/bootloader.bin"

# Run the built image
run: os_image
	qemu-system-i386 -drive file=os-image,format=raw

# Create the os image from the kernel and bootloader 
# binary files
os_image: kernel.bin bootloader.bin
	cat $(bootloader_BIN) $(KERNEL_BIN) > os-image

# Create the binary files from the kernel and kernel_entry
# object files
kernel.bin: kernel.o kernel_entry.o ${OBJ}
	i386-elf-ld -m elf_i386 -o $(KERNEL_BIN) -Ttext 0x1000 $(KERNEL_O) $(KERNEL_LINK_O) $(OBJ) --oformat binary --entry main

# Create the kernel object file
kernel.o:
	i386-elf-gcc $(CFLAGS) -c $(KERNEL) -o $(KERNEL_O)

# Create the kernel_entry object file
kernel_entry.o:
	nasm $(KERNEL_LINK) -f elf -o $(KERNEL_LINK_O)

# Create the bootloader object file
bootloader.bin:
	nasm $(bootloader) -f bin -o $(bootloader_BIN)

#TODO
%.o : %.c ${HEADERS}
	gcc $(CFLAGS) -c $< -o $@

clean:
	rm -rf os-image 
	rm -rf kernel/bin/*.o kernel/bin/*.bin 
	rm -rf boot/bin/*.o boot/bin/*.bin 
	rm -rf kernel/*.o kernel/*.bin 
	rm -rf boot/*.o boot/*.bin
	rm -rf kernel/utilities/*.o