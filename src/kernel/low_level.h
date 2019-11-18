// Reads a byte from the specified port.
unsigned char port_byte_in(unsigned short port);

// Sends a byte to the specified port.
void port_byte_out(unsigned short port, unsigned char data);

// Reads a ushort from the specified port.
unsigned short port_word_in(unsigned short port);

// Sends a ushort to the specified port.
void port_word_out(unsigned short port, unsigned short data);