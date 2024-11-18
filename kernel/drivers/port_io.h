#ifndef H_PORT_IO
#define H_PORT_IO 

#include "stdint.h"

int8_t read_port_b(uint16_t port);
uint16_t read_port_w(uint16_t port);
void write_port_b(uint16_t port, int8_t data);
void write_port_w(uint16_t port, uint16_t data);

#endif