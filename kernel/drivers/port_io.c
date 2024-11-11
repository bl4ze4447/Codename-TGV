#include "port_io.h"


/*
__asm__ ("instrucțiune" : output_operands : input_operands : clobbered_registers)
 */

// https://c9x.me/x86/html/file_module_x86_id_139.html
byte read_port_b(uint16 port) {
    byte output;
    __asm__(
        "in %%dx, %%al" : "=a" (output) : "d" (port) 
    );

    return output;
}
word read_port_w(uint16 port) {
    word output;
    __asm__(
        "in %%dx, %%ax" : "=a" (output) : "d" (port)
    );

    return output;
}

// https://c9x.me/x86/html/file_module_x86_id_222.html
void write_port_b(uint16 port, byte data) {
    __asm__(
        "out %%al, %%dx" : : "a" (data), "d" (port) 
    );
}
void write_port_w(uint16 port, word data) {
    __asm__(
        "out %%ax, %%dx" : : "a" (data), "d" (port)
    );
}