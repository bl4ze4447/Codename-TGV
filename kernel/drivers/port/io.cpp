#include "port/io.h"

/*
__asm__ ("instruction" : output_operands : input_operands : clobbered_registers)
 */

// https://c9x.me/x86/html/file_module_x86_id_139.html
uint8_t riob(uint16_t port) {
    uint8_t output;
    __asm__(
        "in %%dx, %%al" : "=a" (output) : "d" (port) 
    );

    return output;
}
uint16_t riow(uint16_t port) {
    uint16_t output;
    __asm__(
        "in %%dx, %%ax" : "=a" (output) : "d" (port)
    );

    return output;
}

// https://c9x.me/x86/html/file_module_x86_id_222.html
void wiob(uint16_t port, int8_t data) {
    __asm__(
        "out %%al, %%dx" : : "a" (data), "d" (port) 
    );
}
void wiow(uint16_t port, uint16_t data) {
    __asm__(
        "out %%ax, %%dx" : : "a" (data), "d" (port)
    );
}

void io_wait() {
    uint16_t n{(static_cast<uint16_t>(~0b0))};
    while (n) n /= 2;
}