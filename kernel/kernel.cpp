/*
>>  b-ost-kernel <<
> Version 0.0.4 (main.beta.alpha)
> Author: Belu D. Antonie-Gabriel (bl4ze4447)
> Release date: 20/11/2024
*/

#include "utilities/vga_console.h"
#include "utilities/vga_types.h"
using Color = VGA::Color;
using Modifier = VGA::Modifier;

int main() {
    VGAConsole out;

    out << Modifier::CLEAR_SCREEN 
    << VGAConsole::background(Color::CYAN) 
    << "* Succesfully running b-ost-kernel\n"
    << VGAConsole::background(Color::BLACK)
    << "> Build: 0.0.4 (main.beta.alpha)\n"
    << "> Release date: 20.11.2024\n"
    << "> For more info see: "
    << VGAConsole::background(Color::BROWN)
    << "https://github.com/bl4ze4447/b-ost\n\n"
    << VGAConsole::background(Color::BLACK)
    << "[Guest] > "; 

    while (true) ;

    return 0; 
}

