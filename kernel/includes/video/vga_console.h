#ifndef VGACONSOLE_H
#define VGACONSOLE_H 

#include <stdint.h>

#include "memory/memory.h"
#include "video/vga_types.h"

class VGAConsole {
public:
// Namespaces
    using Color = VGA::Color;      
    using Modifier = VGA::Modifier;
    using SpecifiedColor = VGA::SpecifiedColor;

// Operator overloading
    VGAConsole& operator<<(const char t_ch);
    VGAConsole& operator<<(const char* t_str);
    VGAConsole& operator<<(const Modifier t_mod);
    VGAConsole& operator<<(const SpecifiedColor t_sc);

    static SpecifiedColor background(const Color t_color);
    static SpecifiedColor foreground(const Color t_color);
    Color getCurrentBackground();
    Color getCurrentForeground();
private:
// Members
    uint8_t m_row{0};
    uint8_t m_col{0};
    uint8_t m_bg{Color::BLACK};
    uint8_t m_fg{Color::WHITE};
    uint16_t * m_VgaMemory{reinterpret_cast<uint16_t *>(0xb8000)};

// Constants
    const uint8_t MaxRows{25};
    const uint8_t MaxColumns{80};
    const uint16_t CrtcCtrlAddrReg{0x3D4};
    const uint16_t CrtcCtrlDataReg{0x3D5};
    const uint8_t CursorLocLow{0xF};
    const uint8_t CursorLocHigh{0xE};

// Functions
    VGAConsole& operator=(const VGAConsole& other);
    inline uint16_t makeAttribute(const char t_ch);
    void scrollScreen(const uint8_t t_rows);
    void updateCursor();
    void printChar_noUpdate(const char t_ch);
};

#endif