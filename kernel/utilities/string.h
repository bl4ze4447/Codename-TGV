#ifndef STRING
#define STRING
#include "inttypes.h"

uint32 strlen(const char *s) {
    const char *sc;
    for (sc = s; *sc != '\0'; ++sc);

    return sc - s;
}

#endif 