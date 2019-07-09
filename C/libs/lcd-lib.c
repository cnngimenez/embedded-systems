/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   lcd-lib.c
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "lcd-lib.h"

#include <avr/io.h>

#define DUPPER 1
#define DLOWER 0

volatile uint8_t *ddrb = (uint8_t*) (0x24);
volatile uint8_t *portb = (uint8_t*) (0x25);

volatile uint8_t *pind = (uint8_t*) (0x29);
volatile uint8_t *ddrd = (uint8_t*) (0x2a);
volatile uint8_t *portd = (uint8_t*) (0x2b);

unsigned char reverse(unsigned char b) {
   b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
   b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
   b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
   return b;
}

void e_on(){
  *portb |= (1<<PB3);
} // e_on

void e_off(){
  *portb &= 0b11110111;
} // e_off

void rs_on(){
  *portb |= (1<<PB4);
} // rs_on

void rs_off(){
  *portb &= 0b11101111;
} // rs_off

void rw_on(){
  *portb |= (1<<PB2); // Set PB2
} // rw_on

void rw_off(){
  *portb &= 0b11111011; // Erase PB2 bit
}

void set_ersrw_mode(){
  *ddrb |= (1<<DDB2) | (1<<DDB3) | (1<<DDB4);
}

void set_data_bits(uint8_t bits, uint8_t use_left){

uint8_t binr = reverse(bits);

if (use_left == 1){
  *portd = (*portd & 0b11000011) | (0b00111100 & (binr<<2));
 }else{
  *portd = (*portd & 0b11000011) | (0b00111100 & (binr>>2));
 }

} // send_data_bits

uint8_t get_data_bits(){
  uint8_t data = *pind;
  return (reverse(data) & 00111100) >> 2;
} // get_data_bits

void set_data_mode(uint8_t bits){
  bits = reverse(bits) >> 2;
  bits = bits | (*ddrd & 11000011);
  *ddrd = bits;
} // set_data_mode

void wait_40ms(){
  for (unsigned long i = 1; i < 640000; i++);
}

void wait_37us(){
  for (int i = 1; i < 592; i++);
}

void wait_1_52ms(){
  for (unsigned long i = 1; i < 24320; i++);
}

void wait_ms(unsigned long i){

for (; i > 0; i--){

for (unsigned int j = 0; j < 1600; j++);

} // for
} // wait_ms

void wait_bf(){

uint8_t busy = 1;
while (busy == 1){

rw_off(); rs_off(); e_off();
rw_on();
// *portb &= 0b11100011; // Erase PB2, PB3 and PB4
// *portb |= (1<<PB2); // Set PB2

set_data_mode(0b00000000);
// *ddrd &= 0b11000011;

// *portb |= (1<<PB3);
e_on();
wait_37us();
e_off();
// *portb &= 0b11110111;

busy = (get_data_bits() & 0b00001000) != 0;

e_on();
wait_37us();
e_off();

set_data_mode(0b00001111);

} // while

set_data_mode(0b00001111);
// *ddrd |= 0b00111100;

rs_off(); e_off(); rw_off();
// *portb &= 0b11100011; // Erase PB2, PB3 and PB4

} // wait_bf

void send_enable(){
  // Enable when falling edge
  e_on();
  wait_37us();
  e_off();
  wait_37us();
} // send_enable

void send_function_set1(){

set_data_bits(0b00110000, DUPPER);
send_enable();

} // send_function_set1

void send_function_set2(){

set_data_bits(0b00100000, DUPPER);
send_enable();

set_data_bits(0b00000000 | (N<<7) | (F<<6), DUPPER);
  send_enable();  
} // send_function_set2

void send_function_set3(){
  send_function_set2();
} // send_function_set3

void send_display_onoff(){
  lcd_send_command(0, 0b00001000 | (D<<2) | (C<<1) | (B<<0));
}

void send_display_clear(){
  lcd_clear();
} // send_display_clear

void send_entry_modeset(){
  lcd_send_command(0, 0b00000100 | (ID<<1) | (S<<0));
} // send_entry_modeset

void lcd_init(){

set_data_mode(0b00001111);
set_data_bits(0b00000000, 0);
// *ddrd |= (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2);
// *portd = 0b00000000;

set_ersrw_mode();
e_off(); rs_off(); rw_off();
// *ddrb |= (1<<DDB2) | (1<<DDB3) | (1<<DDB4);
// *portb = 0b00000000;

wait_40ms();

send_function_set1();
wait_37us();

send_function_set2();
wait_37us();

send_function_set3();
wait_37us();

send_display_onoff();
wait_37us();

send_display_clear();
wait_1_52ms();

send_entry_modeset();

} // lcd_init

void lcd_ddram_addr(uint8_t addr){
  lcd_send_command(0, 0b10000000 | addr);
  wait_bf();
}

void lcd_send_char(char c, uint8_t addr){

wait_bf();

if (addr < 80){
  lcd_ddram_addr(addr);
}

rs_on();

set_data_bits(c, 1);
send_enable();

set_data_bits(c, 0);
send_enable();

rs_off();

wait_bf();

}

void lcd_send_command(int rs, uint8_t bin){

if (rs == 1) {
  rs_on();
 }else{
  rs_off();
 }

set_data_bits(bin, 1);
send_enable();

set_data_bits(bin, 0);
send_enable();

rs_off();

wait_bf();

}

void lcd_clear(){
  lcd_send_command(0, 0b00000001);
  wait_1_52ms();
  wait_bf();
}

void lcd_return_home(){
  lcd_send_command(0, 0b00000010);
  wait_bf();
}

void lcd_send_string(char *s, unsigned int delay, uint8_t addr){

if (addr < 80){
  lcd_ddram_addr(addr);
}

uint8_t i = 0;
while (s[i] != '\0'){
  lcd_send_char(s[i], 255);
  if (delay > 0){
    wait_ms(delay);
  }
  i++;
 }

} // lcd_send_string

void lcd_display_left(unsigned int amount, unsigned int delay){
  for (;amount > 0; amount --){
    lcd_send_command(0, 0b00011000);
    if (delay > 0){
      wait_ms(delay);
    }
  }
}

void lcd_display_right(unsigned int amount, unsigned int delay){
  for (;amount > 0; amount --){
    lcd_send_command(0, 0b00011100);
    if (delay > 0){
      wait_ms(delay);
    }
  }
}

void lcd_cursor_left(unsigned int amount, unsigned int delay){
   for (;amount > 0; amount --){
      lcd_send_command(0, 0b00010000);
      if (delay > 0){
        wait_ms(delay);
      }
    } 
}
void lcd_cursor_right(unsigned int amount, unsigned int delay){
   for (;amount > 0; amount --){
      lcd_send_command(0, 0b00010100);
      if (delay > 0){
        wait_ms(delay);
      }
    } 
}

void cgram_addr(uint8_t addr){
  if (addr <= 0x3f){
    lcd_send_command(0, 0b01000000 | addr);
  }
}

void lcd_set_cgram(uint8_t num, uint8_t pattern[8]){

cgram_addr(num*0x08);

for (uint8_t i = 0; i < 8; i++){
  lcd_send_command(1, pattern[i]);
}

} // lcd_set_cgram

void lcd_print_cgram(uint8_t num, uint8_t ddram_addr){
  lcd_send_char(num, ddram_addr);
}

void lcd_entry_mode(uint8_t cursor, uint8_t shift){
  if (cursor > 0){
    cursor = 1;
  }
  if (shift > 0){
    shift = 1;
  }
  lcd_send_command(0, 0b00000100 | (cursor<<1) | (shift<<0));
}

void lcd_display_mode(uint8_t display, uint8_t cursor, uint8_t blink){
  if (display > 0){ display = 1; }
  if (cursor > 0){ cursor = 1; }
  if (blink > 0){ blink = 1; }
  lcd_send_command(0, 0b00001000 
                   | (display<<2)
                   | (cursor<<1)
                   | (blink<<0));
}

void lcd_function_set(uint8_t lines, uint8_t font){
  if (lines > 0){ lines = 1; }
  if (font > 0){ font = 1; }
  lcd_send_command(0, 0b00100000 | (lines<<3) | (font<<2));
}
