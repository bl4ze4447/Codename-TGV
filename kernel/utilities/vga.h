#ifndef VGA_H
#define VGA_H 

#include "inttypes.h"

#define VGA_COLUMNS         80
#define VGA_ROWS            25
#define VGA_ADDRESS         0xb8000

typedef struct __attribute__((packed)) _vga_text_mode {
    int row;
    int column;
    int bg;
    int fg;
    volatile uint16 *mem;
} vga_tm;

void init_vga_tm(vga_tm *out);
void write(vga_tm *out, const char *s);
void write_line(vga_tm *out, const char *s);

#endif