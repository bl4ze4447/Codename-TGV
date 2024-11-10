#include "utilities/vgamanip.h"

void main() {
    vga_tm out;
    init_vga_tm(&out);
    out.row = 1;  // Set to row 1 for second line
    write(&out, "(Kernel) Code execution moved to the "); 
    out.bg = 3;
    write(&out, "kernel");
    out.bg = 0;
    write_line(&out, "!"); 
    write(&out, "(Kernel) Welcome to ");
    out.bg = 3;
    write(&out, "b-ost");
    out.bg = 0;
    write_line(&out, "!");
}

