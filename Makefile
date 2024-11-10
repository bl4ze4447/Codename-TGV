CFLAGS+="-fno-stack-protector"
CFLAGS+="-ffreestanding"
CFLAGS+="-m32"
CFLAGS+="-fno-pic"

KERNEL="kernel/kernel.c"
KERNEL_O="kernel/bin/kernel.o"
KERNEL_BIN="kernel/bin/kernel.bin"
KERNEL_LINK="kernel/kernel_entry.asm"
KERNEL_LINK_O="kernel/bin/kernel_entry.o"
BOOTSECTOR="boot/bootsector.asm"
BOOTSECTOR_BIN="boot/bin/bootsector.bin"

bootsector.bin:
	nasm $(BOOTSECTOR) -f bin -o $(BOOTSECTOR_BIN)

kernel.o:
	gcc $(CFLAGS) -c $(KERNEL) -o $(KERNEL_O)

kernel_entry.o:
	nasm $(KERNEL_LINK) -f elf -o $(KERNEL_LINK_O)

kernel.bin: kernel.o kernel_entry.o 
	ld -m elf_i386 -o $(KERNEL_BIN) -Ttext 0x1000 $(KERNEL_LINK_O) $(KERNEL_O) --oformat binary

os_image: kernel.bin bootsector.bin
	cat $(BOOTSECTOR_BIN) $(KERNEL_BIN) > os-image

run: os_image
	qemu-system-x86_64 -fda os-image

clean:
	rm -rf os-image 
	rm -rf kernel/bin/*
	rm -rf boot/bin/*