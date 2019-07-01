/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   servo.c
   
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

#include <avr/io.h>

#include <stdint.h>

#include "servo.h"

typedef struct {
  uint8_t control_a; // TCCR1A
  uint8_t control_b; // TCCR1B
  uint8_t control_c; // TCCR1C
  uint8_t reserved1; 
  uint16_t counter_h; //TCNT1
  uint16_t input_capture; // ICR1
  uint16_t output_compare_a; // OCR1A
  uint16_t output_compare_b; // OCR1B
} volatile servo_t;

volatile servo_t *servo = (servo_t*) (0x80);

void servo_init(){

servo->control_a = 0;
servo->control_b = 0;

servo->control_a |= (1<<COM1A1);
servo->control_a |= (1<<COM1B1);

servo->control_b |= (1<<WGM13) | (1<<WGM12);
servo->control_a |= (1<<WGM11);

servo->input_capture = 4999;

servo->control_b |= (0<<CS12) | (1<<CS11) | (1<<CS10);

volatile uint8_t *ddb = (uint8_t*) (0x24);
*ddb |= (1<<DDB1);

} // servo_init

void servo_rotate_90(){

servo->output_compare_a = 500;

} // servo_rotate_90

void servo_rotate_m90(){
  servo->output_compare_a = 250;
}

void servo_rotate_180(){
 servo->output_compare_a = 750;
}
void servo_rotate_m180(){
  servo->output_compare_a = 150;
}
