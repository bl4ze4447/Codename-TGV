#include "vga.h"

void init_vga_tm(vga_tm *out) {
    out->row = 0;
    out->column = 0;
    out->bg = 0;
    out->fg = 0xF;  // White foreground color
    out->mem = (volatile uint16*)VGA_ADDRESS;
}

void write(vga_tm *out, const char *s) {
    if (!out) return;

    for (; *s != '\0'; ++s) {
        if (out->column == VGA_COLUMNS) {
            out->column = 0;
            ++out->row;
            if (out->row == VGA_ROWS) {
                out->row = 0;
                out->column = 0;
            }
        }

        // Write character and attributes to VGA memory
        out->mem[(out->row * VGA_COLUMNS) + out->column++] = (*s) | ((out->fg | (out->bg << 4)) << 8);
    }
}
void write_line(vga_tm *out, const char *s) {
    write(out, s);

    ++out->row;
    out->column = 0;
    if (out->row == VGA_ROWS) {
        out->row = 0;
    }
}