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

volatile uint8_t *ddrb = (uint8_t*) (0x24);
volatile uint8_t *portb = (uint8_t*) (0x25);

volatile uint8_t *pind = (uint8_t*) (0x29);
volatile uint8_t *ddrd = (uint8_t*) (0x2a);
volatile uint8_t *portd = (uint8_t*) (0x2b);

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

for (unsigned int j = 0; j < 5333; j++);

} // for
} // wait_ms

void wait_bf(){

uint8_t busy = 1;
while (busy == 1){

*portb &= 0b11100011; // Erase PB2, PB3 and PB4
*portb |= (1<<PB2); // Set PB2

*portd &= 0b11000011;

*portb |= (1<<PB3);
wait_37us();
*portb &= 0b11110111;

busy = (*pind & 0b00000100) != 0;

}

*portd |= 0b00111100;

*portb &= 0b11100011; // Erase PB2, PB3 and PB4

} // wait_bf

void send_enable(){
  // Enable when falling edge
  *portb |= (1<<PB3);
  wait_37us();
  *portb &= 0b11110111;
  wait_37us();
}

void send_function_set1(){
  *portd = 0b00110000;
  // (0<<PD2) | (0<<PD3) | (1<<PD4) | (1<<PD5);
  send_enable();
}

void send_function_set2(){

*portd = 0b00010000;
  // (0<<PD2) | (0<<PD3) | (1<<PD4) | (0<<PD5);
send_enable();

*portd = 0b00000000 | (N<<PD2) | (F<<PD3);
    // (N<<PD2) | (F<<PD3) | (0<<PD4) | (0<<PD5);
  send_enable();  
}

void send_function_set3(){
  send_function_set2();
}

void send_display_onoff(){

*portd = 0b00000000;
// (0<<PD2) | (0<<PD3) | (0<<PD4) | (0<<PD5);
send_enable();

*portd = 0b00000100 | (D<<PD3) | (C<<PD4) | (B<<PD5);
    // (1<<PD2) | (D<<PD3) | (C<<PD4) | (B<<PD5);
  send_enable();
}

void send_display_clear(){

*portd = 0b00000000;
  // (0<<PD2) | (0<<PD3) | (0<<PD4) | (0<<PD5);
send_enable();

*portd = 0b00100000;
  // (0<<PD2) | (0<<PD3) | (0<<PD4) | (1<<PD5);
  send_enable();
}

void send_entry_modeset(){

*portd = 0b00000000;
// (0<<PD2) | (0<<PD3) | (0<<PD4) | (0<<PD5);
send_enable();

*portd = 0b00001000 | (ID<<PD4) | (S<<PD5);
    // (0<<PD2) | (1<<PD3) | (ID<<PD4) | (S<<PD5);
  send_enable();
}

void lcd_init(){

*ddrd |= (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2);
*portd = 0b00000000;

*ddrb |= (1<<DDB2) | (1<<DDB3) | (1<<DDB4);
*portb = 0b00000000;

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

}

unsigned char reverse(unsigned char b) {
   b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
   b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
   b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
   return b;
}

void lcd_send_char(char c){

wait_bf();

*portb |= (1<<PB4);

uint8_t cr = reverse(c);

*portd = 0b00111100 & (cr << 2);
send_enable();

*portd = 0b00111100 & (cr >> 2);
send_enable();

*portb &= 0b11101111;

wait_bf();

}

void lcd_send_command(int rs, uint8_t bin){

if (rs == 1) {
  *portb |= (1<<PB4);
 }else{
  *portb &= 0b11101111;
 }

uint8_t binr = reverse(bin);

*portd = 0b00111100 & (binr<<2);
send_enable();

*portd = 0b00111100 & (binr>>2);
send_enable();

*portb &= 0b11101111;

wait_bf();

}

void lcd_clear(){
  lcd_send_command(0, 0b00000001);
  wait_bf();
}

void lcd_return_home(){
  lcd_send_command(0, 0b00000010);
  wait_bf();
}

void lcd_ddram_addr(uint8_t addr){
  lcd_send_command(0, 0b10000000 | addr);
  wait_bf();
}

void lcd_send_string(char *s, unsigned int delay){

unsigned int i = 0;
while (s[i] != '\0'){
  lcd_send_char(s[i]);
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
