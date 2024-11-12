#include "vgamanip.h"
#include "../drivers/port_io.h"

void init_vga_tm(vga_tm *out) {
    out->row = 0;
    out->column = 0;
    out->bg = 0;
    out->fg = 0xF;  // White foreground color
    out->mem = (volatile uint16*)VGA_ADDRESS;
}

void set_foreground(vga_color *fg, vga_color color) {
    if (!fg) return;

    *fg = color;
}
void set_background(vga_color *bg, vga_color color) {
    if (!bg) return;

    *bg = color;
}
void set_color_attribute(vga_tm *out, uint8 bg, uint8 fg) {
    if (!out) return;

    out->bg = bg;
    out->fg = fg;
}

void write(vga_tm *out, const char *s) {
    if (!out) return;

    for (; *s != '\0'; ++s) {
        if (*s == '\n') {
            out->row += 1;
            out->column = 0;

            if (out->row == VGA_ROWS) {
                // scroll down
                __scroll(out);
            }

            continue;
        }

        out->mem[(out->row * VGA_COLUMNS) + out->column++] = __make_attribute(*s, out->fg, out->bg);
    }

    __set_cursor(out->row, out->column);
}
void write_line(vga_tm *out, const char *s) {
    write(out, s);

    out->row += 1;
    out->column = 0;
    if (out->row == VGA_ROWS) __scroll(out);
}
void clear_screen(vga_tm *out) {
    uint8 r = 0, c;
    for (; r < VGA_ROWS; ++r) {
        for (c = 0; c < VGA_COLUMNS; ++c) {
            out->mem[(r * VGA_COLUMNS) + c] = __make_attribute(' ', out->fg, out->bg);
        }
    } 
    
    __set_cursor(0, 0);
}

static void __scroll(vga_tm *out) {
    uint8 r = 0, c;
    for (; r < VGA_ROWS-1; ++r) {
        for (c = 0; c < VGA_COLUMNS; ++c) {
            out->mem[(r * VGA_COLUMNS) + c] = out->mem[((r+1) * VGA_COLUMNS) + c];
        }
    }
    for (c = 0; c < VGA_COLUMNS; ++c) { 
        out->mem[(r * VGA_COLUMNS) + c] = __make_attribute(' ', out->fg, out->bg);
    }

    out->row = VGA_ROWS-2;
    out->column = 0;
    __set_cursor(out->row, out->column);
}
static void __set_cursor(uint8 r, uint8 c) {
    uint16 offset = (r * VGA_COLUMNS) + c;
    byte crtc_address = read_port_b(CRTC_CONTROLLER_ADDRESS_REGISTER);

    write_port_b(CRTC_CONTROLLER_ADDRESS_REGISTER, CURSOR_LOCATION_HIGH);
    write_port_b(CRTC_CONTROLLER_DATA_REGISTER, offset >> 8);
    write_port_b(CRTC_CONTROLLER_ADDRESS_REGISTER, CURSOR_LOCATION_LOW);
    write_port_b(CRTC_CONTROLLER_DATA_REGISTER, offset);

    // restore CRTC_CONTROLLER_ADDRESS
    write_port_b(CRTC_CONTROLLER_ADDRESS_REGISTER, crtc_address);
}
static inline uint16 __make_attribute(char c, uint8 fg, uint8 bg) {
    // 0000 0000 0000 0000
    // bgbg fgfg cccc cccc
    return c | ((fg | (bg << 4)) << 8);
}