#include "../lcd-lib.h"

void wait(){
  for (long i = 1; i < 100000; i++);
}

void main(){

lcd_init();
 lcd_clear();
 lcd_send_command(0, 0b00001110); // display on/off
 
 lcd_send_string("La pizza estuvo buenisima", 0, 0);

 // lcd_send_command(0, 0b01000000);
 uint8_t char0[] = {
		  0b00000000,
		  0b00011110,
		  0b00011101,
		  0b00011101,
		  0b00011101,
		  0b00011110,
		  0b00000000,
		  0b00000000	  
 };
 lcd_set_cgram(0, char0);
 /*
 lcd_send_command(1, 0b00000000);
 lcd_send_command(1, 0b00000000);
 lcd_send_command(1, 0b00011110);
 lcd_send_command(1, 0b00011101);
 lcd_send_command(1, 0b00011101);
 lcd_send_command(1, 0b00011110);
 lcd_send_command(1, 0b00000000);
 lcd_send_command(1, 0b00000000);
 */
 lcd_print_cgram(0, 40);
 lcd_print_cgram(0, 255);
 lcd_send_string("Beer",0, 255);
 lcd_print_cgram(0, 255);
 lcd_print_cgram(0, 255);
		 
 lcd_return_home();

 while (1){
   lcd_display_left(17,100);
   wait();
   lcd_display_right(17,100);
   wait();
 }
 

} //main
