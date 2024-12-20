// TODO: Check the screen type

#include "video/vga_console.h"
#include "video/vga_types.h"
#include "port/io.h"

VGAConsole& VGAConsole::operator<<(const char character) 
{
    PrintChar(character);
    return *this;
}

VGAConsole& VGAConsole::operator<<(const char* string) 
{
    for (; *string != '\0'; ++string) { PrintChar_NoCursorUpdate(*string); }

    CursorUpdate();
    return *this;
}

VGAConsole& VGAConsole::operator<<(const vga::Action action) 
{
    switch (action) {
        case vga::Action::kResetConsole: 
        {
            VGAConsole tmp;
            *this = tmp;
            break;
        }
        case vga::Action::kClearConsole:
        {
            uint8_t row{0}, col{0};
            uint16_t attribute{MakeAttribute(' ')};
            for (; row < kMaxRows; ++row) 
            {
                for (col = 0; col < kMaxColumns; ++col) 
                {
                    kVgaMemory[(row * kMaxColumns) + col] = attribute;
                }
            }

            row_ = 0;
            col_ = 0;
            CursorUpdate();
            break;
        }
    }

    return *this;
}

VGAConsole& VGAConsole::operator<<(const vga::Color color) 
{
    if (color < vga::Color::kBgBlack) 
    {
        fg_ = color;
        return *this;
    }

    bg_ = color;
    return *this;
}

VGAConsole& VGAConsole::operator=(const VGAConsole& other) 
{
    row_ = other.row_;
    col_ = other.col_;
    bg_ = other.bg_;
    fg_ = other.fg_;
    return *this;
}

vga::Color VGAConsole::GetBackground() const
{
    return bg_;
}

vga::Color VGAConsole::GetForeground() const
{
    return fg_;
}

uint16_t VGAConsole::MakeAttribute(const char character) const
{
    // 0000 0000 0000 0000
    // bgbg fgfg cccc cccc
    return character | ((static_cast<uint8_t>(fg_) | (static_cast<uint8_t>(bg_) << 4)) << 8);
}

void VGAConsole::Scroll(const uint8_t rows) 
{
    uint8_t row{0};
    for (; row < kMaxRows - rows; ++row) 
    {
        memcpy
        (
            &kVgaMemory[row * kMaxColumns], 
            &kVgaMemory[(row+rows) * kMaxColumns], 
            kMaxColumns
        );
    }

    uint16_t col{0};
    uint16_t attribute{MakeAttribute(' ')};
    for (; row < kMaxRows; ++row) 
    {
        for (col = 0; col < kMaxColumns; ++col) 
        {
            kVgaMemory[(row * kMaxColumns) + col] = attribute;
        }
    }

    row_ -= rows;
    CursorUpdate();
}

void VGAConsole::CursorUpdate() 
{
    uint16_t offset{static_cast<uint16_t>(row_ * kMaxColumns + col_)};
    uint8_t crtc_address{riob(kCrtcCtrlAddrReg)};

    wiob(kCrtcCtrlAddrReg, kCursorLocHigh);
    wiob(kCrtcCtrlDataReg, offset >> 8);
    wiob(kCrtcCtrlAddrReg, kCursorLocLow);
    wiob(kCrtcCtrlDataReg, offset);
    wiob(kCrtcCtrlAddrReg, crtc_address);
}

void VGAConsole::PrintChar_NoCursorUpdate(const char character) 
{
    bool new_line{false};
    if (character == '\n' || character == 13) // 13 = carriage return
    {
        new_line = true;
        goto update_rows;
    }

    if (col_ >= kMaxColumns) { goto update_rows; }

    kVgaMemory[(row_ * kMaxColumns) + col_] = MakeAttribute(character);
    ++col_;

    return;

update_rows:
    ++row_;
    col_ = 0;

    if (row_ >= kMaxRows) { Scroll(row_ - kMaxRows + 1); }
    if (new_line) { return; }

    kVgaMemory[(row_ * kMaxColumns) + col_] = MakeAttribute(character);
    ++col_;
}

void VGAConsole::PrintChar(const char character) 
{
    PrintChar_NoCursorUpdate(character);
    CursorUpdate();
} 
