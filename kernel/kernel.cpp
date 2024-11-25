/*
    cnb_kernel
    Author: Belu D. Antonie-Gabriel
 */

#define RELEASE_DATE    "25/11/2024"
#define CNB_MAJOR       "0"
#define CNB_MINOR       "0"
#define CNB_BUILD       "5"

#include "utilities/vga_console.h"
#include "utilities/vga_types.h"
using Color = VGA::Color;
using Modifier = VGA::Modifier;

int main() {
    VGAConsole out;

    out << Modifier::CLEAR_SCREEN 
    << VGAConsole::background(Color::CYAN) 
    << "* Succesfully running cnb_kernel\n"
    << VGAConsole::background(Color::BLACK)
    << "> Version: " << CNB_MAJOR << '.' << CNB_MINOR << '.' << CNB_BUILD << '\n'
    << "> Release date: " << RELEASE_DATE << '\n'
    << "> For more info see: "
    << VGAConsole::background(Color::BROWN)
    << "https://github.com/bl4ze4447/cnb-os\n\n"
    << VGAConsole::background(Color::BLACK)
    << "[No user] > "; 

    while (true) ;

    return 0; 
}

