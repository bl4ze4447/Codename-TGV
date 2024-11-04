nasm_compile:
	nasm nasm/bootloader/boot_sector.asm -f bin -o nasm/bootloader/boot_sector.bin

run:
	qemu-system-x86_64 -fda nasm/bootloader/boot_sector.bin