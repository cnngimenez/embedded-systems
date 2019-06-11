#include "uart.h"

void main(){

serial_init();

serial_put_char('H');
serial_put_char('e');
serial_put_char('l');
serial_put_char('l');
serial_put_char('o');
serial_put_char('\n');
serial_put_char('\r');

char c;
for (;;){

c = serial_get_char();

serial_put_char(c);

}

}
