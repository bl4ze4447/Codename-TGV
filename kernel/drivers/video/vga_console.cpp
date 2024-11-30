// TODO: Check the screen type

#include "video/vga_console.h"
#include "video/vga_types.h"
#include "port/port_io.h"

using Color = VGA::Color;
using Modifier = VGA::Modifier;
using SpecifiedColor = VGA::SpecifiedColor;


VGAConsole& VGAConsole::operator<<(const char t_ch) {
    printChar_noUpdate(t_ch);
    updateCursor();

    return *this;
}

VGAConsole& VGAConsole::operator<<(const char* t_str) {
    for (; *t_str != '\0'; ++t_str) { printChar_noUpdate(*t_str); }

    updateCursor();
    return *this;
}

VGAConsole& VGAConsole::operator<<(const Modifier t_mod) {
    switch (t_mod) {
        case Modifier::RESET_CONSOLE: {
            VGAConsole tmp;
            *this = tmp;
        }
        case Modifier::CLEAR_SCREEN:
            uint8_t r{0}, c{0};
            uint16_t attribute{makeAttribute(' ')};
            for (; r < MaxRows; ++r) {
                for (c = 0; c < MaxColumns; ++c) {
                    m_VgaMemory[(r * MaxColumns) + c] = attribute;
                }
            }

            m_row = 0;
            m_col = 0;
            updateCursor();
            break;
    }

    return *this;
}

VGAConsole& VGAConsole::operator<<(const SpecifiedColor t_sc) {
    if (t_sc.modifier & 0b0001000) {
        m_fg = t_sc.modifier ^ 0b0001000; 
    } else {
        m_bg = t_sc.modifier;
    }

    return *this;
}

SpecifiedColor VGAConsole::background(const Color t_color) {
    return SpecifiedColor { static_cast<uint16_t>(0b00010000 + static_cast<uint8_t>(t_color)) };
}
SpecifiedColor VGAConsole::foreground(const Color t_color) {
    return SpecifiedColor { static_cast<uint16_t>(t_color) };
}

Color VGAConsole::getCurrentBackground() {
    return static_cast<Color>(m_bg);
}
Color VGAConsole::getCurrentForeground() {
    return static_cast<Color>(m_fg);
}

VGAConsole& VGAConsole::operator=(const VGAConsole& other) {
    m_row = other.m_row;
    m_col = other.m_col;
    m_bg = other.m_bg;
    m_fg = other.m_fg;
    return *this;
}

inline uint16_t VGAConsole::makeAttribute(const char t_ch){
    // 0000 0000 0000 0000
    // bgbg fgfg cccc cccc
    return t_ch | ((m_fg | (m_bg << 4)) << 8);
}

void VGAConsole::scrollScreen(const uint8_t t_rows) {
    uint8_t r{0};
    for (; r < MaxRows - t_rows; ++r) {
        memcpy(&m_VgaMemory[r * MaxColumns], &m_VgaMemory[(r+t_rows) * MaxColumns], MaxColumns);
    }

    uint16_t c{0};
    uint16_t attribute{makeAttribute(' ')};
    for (; r < MaxRows; ++r) {
        for (c = 0; c < MaxColumns; ++c) {
            m_VgaMemory[(r * MaxColumns) + c] = attribute;
        }
    }

    m_row -= t_rows;
    updateCursor();
}

void VGAConsole::updateCursor() {
    uint16_t offset = (m_row * MaxColumns) + m_col;
    uint8_t crtc_address = read_port_b(CrtcCtrlAddrReg);

    write_port_b(CrtcCtrlAddrReg, CursorLocHigh);
    write_port_b(CrtcCtrlDataReg, offset >> 8);
    write_port_b(CrtcCtrlAddrReg, CursorLocLow);
    write_port_b(CrtcCtrlDataReg, offset);
    write_port_b(CrtcCtrlAddrReg, crtc_address);
}

void VGAConsole::printChar_noUpdate(const char t_ch) {
    bool new_line{false};
    if (t_ch == '\n' || t_ch == 13) {
        ++m_row;
        m_col = 0;
        new_line = true;
    } else if (m_col >= MaxColumns) {
        ++m_row;
        m_col = 0;
    } 

    if (m_row >= MaxRows) { scrollScreen(1); }
    if (new_line) { return; }
    
    m_VgaMemory[(m_row * MaxColumns) + m_col] = makeAttribute(t_ch);
    ++m_col;

    return;
}