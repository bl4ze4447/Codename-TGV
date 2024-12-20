/*
    Codename-TGV-Kernel
    Author: bl4ze4447
 */

#define RELEASE_DATE    "15/12/2024"
#define CNB_MAJOR       "0"
#define CNB_MINOR       "0"
#define CNB_BUILD       "8"

#include "video/vga_console.h"

void main() {
    VGAConsole kout;

    kout << vga::Action::kClearConsole 
    << vga::Color::kBgCyan 
    << "* Succesfully running Codename-TGV-Kernel\n"
    << vga::Color::kBgBlack
    << "> Version: " << CNB_MAJOR << '.' << CNB_MINOR << '.' << CNB_BUILD << '\n'
    << "> Release date: " << RELEASE_DATE << '\n'
    << "> For more info see: "
    << vga::Color::kBgBrown
    << "https://github.com/bl4ze4447/Codename-TGV\n\n"
    << vga::Color::kBgBlack
    << "[No user] > "; 
}