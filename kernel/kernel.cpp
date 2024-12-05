/*
    Codename-TGV-Kernel
    Author: bl4ze4447
 */

#define RELEASE_DATE    "25/11/2024"
#define CNB_MAJOR       "0"
#define CNB_MINOR       "0"
#define CNB_BUILD       "6"

#include "video/vga_console.h"
#include "video/vga_types.h"
using Color = VGA::Color;
using Modifier = VGA::Modifier;

void main() {
    VGAConsole kout;

    kout << Modifier::CLEAR_SCREEN 
    << VGAConsole::background(Color::CYAN) 
    << "* Succesfully running Codename-TGV-Kernel\n"
    << VGAConsole::background(Color::BLACK)
    << "> Version: " << CNB_MAJOR << '.' << CNB_MINOR << '.' << CNB_BUILD << '\n'
    << "> Release date: " << RELEASE_DATE << '\n'
    << "> For more info see: "
    << VGAConsole::background(Color::BROWN)
    << "https://github.com/bl4ze4447/Codename-TGV\n\n"
    << VGAConsole::background(Color::BLACK)
    << "[No user] > "; 

    while (true) ;
}