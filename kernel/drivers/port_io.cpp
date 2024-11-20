#include "port_io.h"

/*
__asm__ ("instruction" : output_operands : input_operands : clobbered_registers)
 */

// https://c9x.me/x86/html/file_module_x86_id_139.html
int8_t read_port_b(uint16_t port) {
    int8_t output;
    __asm__(
        "in %%dx, %%al" : "=a" (output) : "d" (port) 
    );

    return output;
}
uint16_t read_port_w(uint16_t port) {
    uint16_t output;
    __asm__(
        "in %%dx, %%ax" : "=a" (output) : "d" (port)
    );

    return output;
}

// https://c9x.me/x86/html/file_module_x86_id_222.html
void write_port_b(uint16_t port, int8_t data) {
    __asm__(
        "out %%al, %%dx" : : "a" (data), "d" (port) 
    );
}
void write_port_w(uint16_t port, uint16_t data) {
    __asm__(
        "out %%ax, %%dx" : : "a" (data), "d" (port)
    );
}