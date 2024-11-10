bsec:
	nasm boot/bootsector.asm -f bin -o boot/bin/bootsector.bin

run: bsec
	qemu-system-x86_64 -fda boot/bin/bootsector.bin 