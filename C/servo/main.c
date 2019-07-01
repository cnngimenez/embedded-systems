/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   main.c
   
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

#include "servo.h"
#include <avr/io.h>

volatile uint8_t *ddb = (uint8_t*) (0x24);
volatile uint8_t *portb = (uint8_t*) (0x25);

void main(){

*ddb |= (1<<DDB5);
*portb &= 0b11011111;

servo_init();

for (;;){
  *portb |= (1<<PORTB5);
  servo_rotate_90();
  for (unsigned long i=0; i < 1000000; i++);
  *portb &= 0b11011111;
  servo_rotate_m90();
  for (unsigned long i=0; i < 1000000; i++);
  servo_rotate_180();
  for (unsigned long i=0; i < 1000000; i++);
  servo_rotate_m180();
  for (unsigned long i=0; i < 1000000; i++);
  }

} // main
