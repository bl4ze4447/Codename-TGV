#ifndef VGACONSOLE_H
#define VGACONSOLE_H 

#include "memory/memory.h"
#include "video/vga_types.h"
#include "primitives/fxsint.h"

class VGAConsole {
public:
    VGAConsole& operator<<(const char character);
    VGAConsole& operator<<(const char* string);

    VGAConsole& operator<<(const vga::Action action);
    VGAConsole& operator<<(const vga::Color color);
    VGAConsole& operator=(const VGAConsole& other);

    vga::Color GetBackground() const;
    vga::Color GetForeground() const;
    uint16_t MakeAttribute(const char character) const;

    void Scroll(const uint8_t rows);
    void CursorUpdate();
private:
    uint8_t row_{0};
    uint8_t col_{0};
    vga::Color bg_{vga::Color::kBgBlack};
    vga::Color fg_{vga::Color::kWhite};

    uint16_t * const kVgaMemory{reinterpret_cast<uint16_t *>(0xb8000)};
    const uint8_t kMaxRows{25};
    const uint8_t kMaxColumns{80};
    const uint16_t kCrtcCtrlAddrReg{0x3D4};
    const uint16_t kCrtcCtrlDataReg{0x3D5};
    const uint8_t kCursorLocLow{0xF};
    const uint8_t kCursorLocHigh{0xE};

    void PrintChar_NoCursorUpdate(const char character);
    void PrintChar(const char character);
};

#endif