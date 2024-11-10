#include "utilities/vga.h"

void main() {
    vga_tm out;
    init_vga_tm(&out);
    out.row = 1;  // Set to row 1 for second line
    write_line(&out, "(Kernel) Code execution moved to Kernel.");
    write(&out, "(Kernel) This should be on the third row.");
}

