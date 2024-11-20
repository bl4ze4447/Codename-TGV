#ifndef VGATYPES_H
#define VGATYPES_H

#include <stdint.h>

namespace VGA {
    enum Color {
        BLACK = 0,
        BLUE,
        GREEN,
        CYAN,
        RED,
        MAGENTA,
        BROWN,
        LIGHT_GRAY,
        DARK_GRAY,
        LIGHT_BLUE,
        LIGHT_GREEN,
        LIGHT_CYAN,
        LIGHT_RED,
        LIGHT_MAGENTA,
        YELLOW,
        WHITE
    };

    enum class Modifier {
        CLEAR_SCREEN,
        RESET_CONSOLE
    };

    struct SpecifiedColor {
        // 0000 0000
        //    | ||||
        //    | ---------Color
        //    -----------Background or foreground (0/1)
        uint16_t modifier;
    };
}

#endif
