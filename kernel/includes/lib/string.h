#ifndef STRING_H
#define STRING_H

#include "lib/fxsint.h"

class String 
{
public:
    String();
    String(const char * buffer);

    String& operator=(String &other);
    String& operator=(const char * buffer);

    template <typename T>
    static String FromNumber(T number);
private:
    char * buffer_{nullptr};
    uint64_t length_{0};
    uint64_t capacity_{0};
};

#endif