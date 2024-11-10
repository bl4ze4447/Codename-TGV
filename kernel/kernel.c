#include "utilities/string.h"

void main() {
    char *vga_mem = (char*)0xb8000;
    const char *message = "Hello from the C Kernel!";
    uint32 len = strlen(message), i = 0;
    for (; i < len; ++i) vga_mem[i] = message[i];
}