/*
>>  b-ost-kernel <<
> Version 0.0.3 (main.beta.alpha)
> Author: Belu D. Antonie-Gabriel (bl4ze4447)
> Release date: 18/11/2024
*/

#include "utilities/vgamanip.h"

void main() {
    vga_tm out;
    init_vga_tm(&out);
    clear_screen(&out);

    set_background(&out.bg, VGA_CYAN);
    write(&out, "* Succesfully running b-ost-kernel\n");
    set_background(&out.bg, VGA_BLACK);
    write(&out, "> Release date: 18/11/2024\n> Build: 0.0.1 (main.beta.alpha)\n> For more info see: ");
    set_background(&out.bg, VGA_BROWN);
    write(&out, "https://github.com/bl4ze4447/b-ost\n\n");

    set_background(&out.bg, VGA_BLACK);
    write(&out, "[Guest /] > ");

    while (1) {}
}

