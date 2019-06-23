#include "../lcd-lib.h"

void wait(){
  for (long i = 1; i < 100000; i++);
}

void main(){

lcd_init();

while (1) {

lcd_clear();
lcd_send_command(0, 0b00101100); // function set
lcd_send_command(0, 0b00010100); // cursor display
lcd_send_command(0, 0b00000110); // Entry mode set
lcd_send_command(0, 0b00001110); // display on/off

lcd_ddram_addr(0);

lcd_send_char('h');
wait();
lcd_send_char('e');
wait();
lcd_send_char('l');
wait();
lcd_send_char('l');
wait();
lcd_send_char('o');
wait();

lcd_ddram_addr(40);

lcd_send_string("world", 40);
wait();
wait();

}

} //main
