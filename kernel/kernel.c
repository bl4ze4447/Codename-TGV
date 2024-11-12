#include "utilities/vgamanip.h"

void main() {
    vga_tm out;
    init_vga_tm(&out);
    clear_screen(&out);

    write(&out, ">> b-ost v0.1, release date: 11/2024\n>> Version 0.0.1 (main.beta.alpha)\n\n");

    set_background(&out.bg, VGA_GREEN);
    write(&out, "(KSucces)");

    set_background(&out.bg, VGA_BLACK);
    write(&out, " > Kernel is running.\n");

    set_background(&out.bg, VGA_CYAN);
    write(&out, "(b-ost)");

    set_background(&out.bg, VGA_BLACK);
    write(&out, " > ");

    while (1) {}
}

