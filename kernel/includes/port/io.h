#ifndef PORTIO_H
#define PORTIO_H 

#include "lib/fxsint.h"

uint8_t riob(uint16_t port);
uint16_t riow(uint16_t port);
void wiob(uint16_t port, int8_t data);
void wiow(uint16_t port, uint16_t data);
void io_wait();

#endif