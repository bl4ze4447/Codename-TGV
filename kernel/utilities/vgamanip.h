/*
    vgamanip.h
    Author: bl4ze (Belu D. Antonie-Gabriel)
    Description: This header file is being used for easy
    and safe manipulation of VGA's Text Mode.
 */

#ifndef VGAMANIP_H
#define VGAMANIP_H 

#include "fxs_int.h"

#define VGA_COLUMNS                             80
#define VGA_ROWS                                25
#define VGA_ADDRESS                             0xb8000

#define CRTC_CONTROLLER_ADDRESS_REGISTER        0x3D4
#define CRTC_CONTROLLER_DATA_REGISTER           0x3D5

#define CURSOR_LOCATION_HIGH                    0xE
#define CURSOR_LOCATION_LOW                     0xF

typedef enum _vga_color {
    VGA_BLACK   = 0,
    VGA_BLUE,
    VGA_GREEN,
    VGA_CYAN,
    VGA_RED,
    VGA_MAGENTA,
    VGA_BROWN,
    VGA_LIGHTGRAY,
    VGA_DARKGRAY,
    VGA_LIGHTBLUE,
    VGA_LIGHTGREEN,
    VGA_LIGHTCYAN,
    VGA_LIGHTRED,
    VGA_LIGHTMAGENTA,
    VGA_YELLOW,
    VGA_WHITE
} vga_color;

typedef struct _vga_text_mode {
    uint8 row;
    uint8 column;
    vga_color bg;
    vga_color fg;
    volatile uint16 *mem;
} vga_tm;

// init
void init_vga_tm(vga_tm *out);

// color manip
void set_foreground(vga_color *fg, vga_color color);
void set_background(vga_color *bg, vga_color color);
void set_color_attribute(vga_tm *out, uint8 bg, uint8 fg);

// write
void write(vga_tm *out, const char *s);
void write_line(vga_tm *out, const char *s);
void clear_screen(vga_tm *out);

// __prefixed = uncallable
static void __scroll(vga_tm *out);
static void __set_cursor(uint8 r, uint8 c);
static inline uint16 __make_attribute(char c, uint8 fg, uint8 bg); 

#endif