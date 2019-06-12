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
  servo_rotate_360();
  for (unsigned long i=0; i < 1000000; i++);
  }

} // main
