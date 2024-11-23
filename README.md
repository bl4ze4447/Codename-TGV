# cnb_os, a fun project ![C](https://img.shields.io/badge/Language-C-blue) ![NASM](https://img.shields.io/badge/Assembler-NASM-blue) 

cnb_os is an i386 operating system, built using NASM and C++, without any additional libraries.
It has its own bootloader and kernel:
* cnb_bloader, built in NASM, which fits in 512b
* cnb_kernel, built in C++

![Preview](https://i.imgur.com/LDdeAsP.png)

## Build and usage
Use ```make run``` to compile and run the file.
You need: make, nasm, gcc, ld, cat, qemu-system-x86_64 and rm. Most of them come preinstalled on various Linux Distros.

## Upcoming
- Keyboard driver

## Resources I am currently using or used
* Nick Blundell's book (link deprecated)
* [Intel® 64 and IA-32 Architectures Software Developer Manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
* [OSDev Wiki](https://wiki.osdev.org/)
* [x86 Instruction Set](https://www.felixcloutier.com/x86/)
* [osdever](http://www.osdever.net/FreeVGA/vga/portidx.htm)
* [ctyme/intr/](https://www.ctyme.com/intr/) ; rb-1338,1337,1336

## License
This repository is licensed under the ```MIT License```.
