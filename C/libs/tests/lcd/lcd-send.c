#include "lcd-lib.h"

void wait(){
  for (long i = 1; i < 100000; i++);
}

void main(){

lcd_init();

while (1) {

lcd_clear();
lcd_entry_mode(CURSOR_INCREMENT, SHIFT_STATIC);

lcd_send_char('h', 0);
wait();
lcd_send_char('e', 1);
wait();
lcd_send_char('l', 2);
wait();
lcd_send_char('l', 3);
wait();
lcd_send_char('o', 4);
wait();

lcd_send_string("world", 50, 40);
wait();
wait();

uint8_t char0[] = {
		 0b00000100,
		 0b00001110,
		 0b00011111,
		 0b00000100,
		 0b00011111,
		 0b00001110,
		 0b00000100,
		 0b00000000	  
};
lcd_set_cgram(0, char0);

lcd_print_cgram(0, 255);

lcd_cursor_left(80, 50);
lcd_cursor_right(80, 50);

lcd_display_left(40, 50);
lcd_display_right(40, 50);

lcd_return_home();
wait();

lcd_function_set(N_DOUBLE_LINES, FONT_SMALL);
wait();
lcd_function_set(N_SINGLE_LINE, FONT_SMALL);
wait();
lcd_function_set(N_DOUBLE_LINES, FONT_LARGE);
wait();
lcd_function_set(N_SINGLE_LINE, FONT_LARGE);
wait();

lcd_display_mode(DISPLAY_ON, CURSOR_ON, BLINK_OFF);
wait();
lcd_display_mode(DISPLAY_OFF, CURSOR_ON, BLINK_OFF);
wait();
lcd_display_mode(DISPLAY_ON, CURSOR_ON, BLINK_OFF);
wait();
lcd_display_mode(DISPLAY_ON, CURSOR_OFF, BLINK_OFF);
wait();
lcd_display_mode(DISPLAY_ON, CURSOR_ON, BLINK_ON);
wait();
lcd_display_mode(DISPLAY_ON, CURSOR_ON, BLINK_OFF);
wait();

lcd_clear();
lcd_entry_mode(CURSOR_DECREMENT, SHIFT_STATIC);
lcd_send_string("Cursor Decrement", 0, 50);
lcd_send_string("Shift Static", 40, 50);
wait();
lcd_clear();
lcd_entry_mode(CURSOR_INCREMENT, SHIFT_STATIC);
lcd_send_string("Cursor Increment", 0, 50);
lcd_send_string("Shift Static", 40, 50);
wait();
lcd_clear();
lcd_entry_mode(CURSOR_DECREMENT, SHIFT_ENABLE);
lcd_send_string("Cursor Decrement", 0, 50);
lcd_send_string("Shift Enable", 40, 50);
wait();
lcd_clear();
lcd_entry_mode(CURSOR_INCREMENT, SHIFT_ENABLE);
lcd_send_string("Cursor Increment", 0, 50);
lcd_send_string("Shift Enable", 40, 50);
wait();

} // while

} //main
