#include "i2c.h"

#include <stdint.h>

#include <avr/io.h>

typedef struct {
  uint8_t bit_rate;     // TWRP 0xB8
  uint8_t status;       // TWSR 0xB9
  uint8_t address;      // TWAR 0xBA
  uint8_t data;         // TWDR 0xBB  
  uint8_t control;      // TWCR 0xBC
  uint8_t address_mask; // TWAMR 0xBD
} volatile i2c_t;

volatile i2c_t *i2c = (i2c_t*) (0xb8);

void wait_trans(){
  while ((i2c->control & 0x80) != 0);
}

void ack_and_wait(){

i2c->control = (1<<TWINT) | (1<<TWEA) | (1<<TWEN);

wait_trans();

} // ack_and_wait

uint8_t i2c_init(uint8_t baudrate, uint8_t prescaler){

volatile uint8_t *portc = (uint8_t*) (0x28);
/*
volatile uint8_t *ddrc = (uint8_t*) (0x27);
volatile uint8_t *pinc = (uint8_t*) (0x26);
volatile unti8_t *mcucr = (uint8_t*) (0x55);
*/
*portc |= (1<<PORTC5) | (1<<PORTC4);
// *ddrc &= 0b11101111; // Clear PUD bit (4th bit )
// *ddrc &= 0b11001111; // Clear DDR5 bit and DDR4 bits

i2c->bit_rate = baudrate;

i2c->status = 0b11111100 | (prescaler & 0b00000011);

i2c->control = (1<<TWEA) | (1<<TWEN);

} // i2c_init

uint8_t i2c_start(){

i2c->control =  (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);

while ((i2c->control & 0x80) == 0);

return i2c->status;
} // i2c_start

uint8_t i2c_stop(){
  i2c->control =  (1<<TWINT) | (1<<TWSTO) | (1<<TWEN);
  while ((i2c->control & 0x80) != 0);
  return i2c->status;
} // i2c_stop

uint8_t i2c_sla_r(uint8_t addr){

i2c->data = addr | 0x01;
i2c->control = (1<<TWINT) | (1<<TWEN);

while ((i2c->control & 0x80) == 0);

return i2c->status;
} // i2c_sla_r

uint8_t i2c_sla_w(uint8_t addr){
  i2c->data = addr & 0b11111110;
  i2c->control = (1<<TWINT) | (1<<TWEN);
  while ((i2c->control & 0x80) == 0);
  return i2c->status;
} // i2c_sla_w

uint8_t i2c_send(uint8_t data){

while ((i2c->control & 0x80) == 0);

i2c->data = data;
i2c->control = (1<<TWINT) | (1<<TWEN);

while ((i2c->control & 0x80) == 0);

return i2c->status;
} // i2c_send

uint8_t i2c_receive(uint8_t *data, uint8_t send_nack){

if (send_nack){
  i2c->control &= 0b10111111;
}else{
  i2c->control |= (1<<TWEA);
}

while ((i2c->control & 0x80) == 0);

*data = i2c->data;

return i2c->status;
} // i2c_receive
