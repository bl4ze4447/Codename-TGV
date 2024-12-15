# General paths
UTILITIES_PATH		= kernel/utilities/
DRIVERS_PATH		= kernel/drivers/
INCLUDES_PATH		= kernel/includes
OBJECT_PATH			= kernel/objects/
KERNEL_BIN_PATH		= kernel/bin/
BOOTLOADER_BIN_PATH	= boot/bin/

# Source, headers and objects
DRIVERS_SRC         = $(wildcard $(DRIVERS_PATH)*/*.cpp)
UTILITIES_SRC       = $(wildcard $(UTILITIES_PATH)*.cpp)
HEADERS             = $(wildcard $(INCLUDES_PATH)*/*.h)

DRIVERS_OBJECTS     = $(patsubst %,$(OBJECT_PATH)%,$(notdir $(DRIVERS_SRC:.cpp=.o)))
UTILITIES_OBJECTS   = $(patsubst %,$(OBJECT_PATH)%,$(notdir $(UTILITIES_SRC:.cpp=.o)))

# C++ compile flags
CPPFLAGS 	+= -ffreestanding
CPPFLAGS 	+= -m32
CPPFLAGS 	+= -fstack-protector
CPPFLAGS 	+= -fno-pic
CPPFLAGS 	+= -nostdlib
CPPFLAGS 	+= -Wall
CPPFLAGS 	+= -Wextra
CPPFLAGS	+= -Wpadded
CPPFLAGS 	+= -std=c++17
CPPFLAGS	+= "-Os"
CPPFLAGS 	+= -I$(INCLUDES_PATH)

# LD Flags
LDFLAGS_BIN += -m elf_i386
LDFLAGS_O	+= -Ttext 0x1000
LDFLAGS_O	+= --oformat binary

# Source paths 
PKERNEL 			= kernel/kernel.cpp
PKERNEL_ENTRY		= kernel/kernel_entry.asm
PBOOTL_PART1		= boot/bootloader_1.asm
PBOOTL_PART2		= boot/bootloader_2.asm
# Object paths	
PKERNEL_OBJ			= $(OBJECT_PATH)$(notdir $(PKERNEL:.cpp=.o))
PKERNEL_ENTRY_OBJ	= $(OBJECT_PATH)$(notdir $(PKERNEL_ENTRY:.asm=.o))
# Binaries paths
PKERNEL_BIN			= $(KERNEL_BIN_PATH)$(notdir $(PKERNEL:.cpp=.bin))
PBOOTL_PART1_BIN	= $(BOOTLOADER_BIN_PATH)$(notdir $(PBOOTL_PART1:.asm=.bin))
PBOOTL_PART2_BIN	= $(BOOTLOADER_BIN_PATH)$(notdir $(PBOOTL_PART2:.asm=.bin))
PBOOTL_BIN			= $(BOOTLOADER_BIN_PATH)bootloader.bin


# Create OS image
image: bootloader.bin kernel.bin
	cat $(PBOOTL_BIN) $(PKERNEL_BIN) > image.bin

# Run the OS Image in Qemu
run: image
	qemu-system-i386 -drive file=image.bin,format=raw

# Make the kernel binary
kernel.bin: kernel_entry.o kernel.o $(DRIVERS_SRC:.cpp=.o) $(UTILITIES_SRC:.cpp=.o)
	i386-elf-ld $(LDFLAGS_BIN) -o $(PKERNEL_BIN) $(LDFLAGS_O) $(PKERNEL_ENTRY_OBJ) $(PKERNEL_OBJ) $(UTILITIES_OBJECTS) $(DRIVERS_OBJECTS)

# Make the kernel object
kernel.o:
	i386-elf-gcc $(CPPFLAGS) -c $(PKERNEL) -o $(PKERNEL_OBJ)

# Make the kernel_entry object
kernel_entry.o:
	nasm $(PKERNEL_ENTRY) -f elf -o $(PKERNEL_ENTRY_OBJ)

# Make the bootloader binary from the two parts
bootloader.bin:
	nasm $(PBOOTL_PART1) -f bin -o $(PBOOTL_PART1_BIN)
	nasm $(PBOOTL_PART2) -f bin -o $(PBOOTL_PART2_BIN)
	cat $(PBOOTL_PART1_BIN) $(PBOOTL_PART2_BIN) > $(PBOOTL_BIN) 

# Drivers and utilities object
%.o: %.cpp $(HEADERS)
	i386-elf-gcc $(CPPFLAGS) -c $< -o $(OBJECT_PATH)$(notdir $@)

# Delete all binaries and objects
clean:
	rm -rf kernel/objects/*
	rm -rf kernel/bin/*
	rm -rf boot/bin/*
	rm -rf ./*.bin
	rm -rf ./*.obj