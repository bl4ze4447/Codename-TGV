CFLAGS+="-fno-stack-protector"
CFLAGS+="-ffreestanding"
CKERNEL="kernel/kernel.c"
OKERNEL="kernel/bin/kernel.o"
BKERNEL="kernel/bin/kernel.bin"

bsec:
	nasm boot/bootsector.asm -f bin -o boot/bin/bootsector.bin

kernel.c:
	gcc $(CFLAGS) -c $(CKERNEL) -o $(OKERNEL)

kernel_link: kernel.c
	ld -o $(BKERNEL) -Ttext 0x1000 $(OKERNEL) --oformat binary

create_image: bsec kernel_link
	cat boot/bin/bootsector.bin kernel/bin/kernel.bin > os-image

run: create_image
	qemu-system-x86_64 -fda os-image

clean:
	rm os-image 
	rm kernel/bin/*
	rm boot/bin/*