#ifndef H_PORT_IO
#define H_PORT_IO 

#include "../utilities/fxs_int.h"

byte read_port_b(uint16 port);
word read_port_w(uint16 port);
void write_port_b(uint16 port, byte data);
void write_port_w(uint16 port, word data);

#endif