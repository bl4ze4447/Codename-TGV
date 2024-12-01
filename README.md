# Codename-TGV, a fun project ![C](https://img.shields.io/badge/Language-C-blue) ![NASM](https://img.shields.io/badge/Assembler-NASM-blue) 

Codename-TGV, x86 Operating System, built upon:
* Codename-TGV-Bootloader - Fast and ligtweight bootloader, built using NASM. Its size is only 0.001024 megabytes or 1024 bytes.
* Codename-TGV-Kernel - Minimal and readable, built using C++.

![Preview](https://i.imgur.com/vzqv07I.png)

## Build and usage
```make run``` will build the image and run it using qemu-system-i386.
## Dependencies
* i386-elf-gcc
* i386-elf-ld
* qemu-system-i386
* nasm
* and all other dependencies the above commands need. 
 
## Upcoming
- Keyboard driver

## Resources I am currently using or used
* [Intel® 64 and IA-32 Architectures Software Developer Manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
* [OSDev Wiki](https://wiki.osdev.org/)
* [x86 Instruction Set](https://www.felixcloutier.com/x86/)
* [osdever](http://www.osdever.net/FreeVGA/vga/portidx.htm)
* [ctyme/intr/](https://www.ctyme.com/intr/) ; rb-1338,1337,1336

## Bootloader error semnification
Error that happen in the bootloader follow this format: ```bER{error number}``` (example: ```bER20```)
| Error Number   | Description |
| :----------:   | :---------- |
| 1              | Either the sector load function failed or it did not read all sectors |
| 20             | A20 Line could not be enabled |  

## License
This repository is licensed under the ```MIT License```.
