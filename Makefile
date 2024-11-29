C_SOURCES 	= $(wildcard kernel/utilities/*.cpp kernel/drivers/*.cpp)
HEADERS 	= $(wildcard kernel/utilities/*.h kernel/drivers/*.h)

OBJ = ${C_SOURCES:.cpp=.o}

CFLAGS+="-ffreestanding"
CFLAGS+="-m32"
CFLAGS+="-fstack-protector"
CFLAGS+="-fno-pic"
CFLAGS+="-nostdlib"
CFLAGS+="-Wall"
CFLAGS+="-Wextra"
CFLAGS+="-std=c++11"

KERNEL="kernel/kernel.cpp"
KERNEL_O="kernel/bin/kernel.o"
KERNEL_BIN="kernel/bin/kernel.bin"
KERNEL_LINK="kernel/kernel_entry.asm"
KERNEL_LINK_O="kernel/bin/kernel_entry.o"
BOOTLOADER_PM="boot/bootloader_pm.asm"
BOOTLOADER_RM="boot/bootloader_rm.asm"
BOOTLOADER_BIN_PM="boot/bin/bootloader_pm.bin"
BOOTLOADER_BIN_RM="boot/bin/bootloader_rm.bin"

# Create the os image from the kernel and bootloader 
# binary files
image: kernel.bin bootloader_rm.bin bootloader_pm.bin
	cat $(BOOTLOADER_BIN_RM) $(BOOTLOADER_BIN_PM) $(KERNEL_BIN) > image.bin

# Run the built image
run: image
	qemu-system-i386 -drive file=image.bin,format=raw

# Create the binary files from the kernel and kernel_entry
# object files
kernel.bin: kernel.o kernel_entry.o ${OBJ}
	i386-elf-ld -m elf_i386 -o $(KERNEL_BIN) -Ttext 0x1000 $(KERNEL_LINK_O) $(KERNEL_O) $(OBJ) --oformat binary

# Create the kernel object file
kernel.o:
	i386-elf-gcc $(CFLAGS) -c $(KERNEL) -o $(KERNEL_O)

# Create the kernel_entry object file
kernel_entry.o:
	nasm $(KERNEL_LINK) -f elf -o $(KERNEL_LINK_O)

# Create the bootloader object files
bootloader_rm.bin bootloader_pm.bin:
	nasm $(BOOTLOADER_RM) -f bin -o $(BOOTLOADER_BIN_RM)
	nasm $(BOOTLOADER_PM) -f bin -o $(BOOTLOADER_BIN_PM)

#TODO
%.o : %.cpp ${HEADERS}
	gcc $(CFLAGS) -c $< -o $@

clean:
	rm -rf os-image 
	rm -rf kernel/bin/*.o kernel/bin/*.bin 
	rm -rf boot/bin/*.o boot/bin/*.bin 
	rm -rf kernel/*.o kernel/*.bin 
	rm -rf boot/*.o boot/*.bin
	rm -rf kernel/utilities/*.o