/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   sdcard.c
   
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

#include "sdcard.h"

#include <avr/io.h>

#include <stdint.h>

typedef struct {
  uint8_t spcr; // 0x4C
  uint8_t spsr; // 0x4D
  uint8_t spdr; // 0x4E
} volatile spi_t;

volatile spi_t *spi = (spi_t*) (0x4c);

volatile uint8_t* portb = (uint8_t*) (0x25);
volatile uint8_t* ddrb = (uint8_t*) (0x24);
volatile uint8_t* pinb = (uint8_t*) (0x23);

uint8_t last_cmd[6] = {0,0,0,0,0,0};

uint8_t use_address = USE_ADDRESS_UNDEFINED;

void mosi_on(){
  *portb |= (1<<PB3);
} // mosi_on
void cs_on(){
  *portb |= (1<<PB2);
} // cs_on

void mosi_off(){
  *portb &= 0b11110111; 
} // mosi_off
void cs_off(){
  *portb &= 0b11111011;
} // cs_off

unsigned char CRC7(const unsigned char message[], const unsigned int length) {
  const unsigned char poly = 0b10001001;
  unsigned char crc = 0;
  for (unsigned i = 0; i < length; i++) {
     crc ^= message[i];
     for (int j = 0; j < 8; j++) {
      // crc = crc & 0x1 ? (crc >> 1) ^ poly : crc >> 1;       
      crc = (crc & 0x80u) ? ((crc << 1) ^ (poly << 1)) : (crc << 1);
    }
  }
  //return crc;
  return crc >> 1;
}

void send_byte(uint8_t byte){
  spi->spdr = byte;
  while (! (spi->spsr & (1<<SPIF)));
} // send_byte

void sdcard_send_command_raw(uint8_t command[6]){
  uint8_t i;

for (i = 0; i < 6; i++){
  last_cmd[i] = command[i];
}

cs_off();

send_byte(0xff);
while (spi->spdr != 0xff){
  send_byte(0xff);
}

for (i = 0; i < 6; i++){
  send_byte(command[i]);
} // for

} // sdcard_send_command_raw

void sdcard_send_command(uint8_t command, uint32_t argument){

uint8_t cmd[6] = {0, 0, 0, 0, 0, 0};

cmd[0] = 0b01000000 | (0b00111111 & command);

cmd[1] = (argument>>24);
cmd[2] = 0b11111111 & (argument>>16);
cmd[3] = 0b11111111 & (argument>>8);
cmd[4] = 0b11111111 & argument;

cmd[5] = CRC7(cmd, 5);
cmd[5] = (cmd[5]<<1) | 0b00000001;

sdcard_send_command_raw(cmd);

} // sdcard_send_command

uint8_t sdcard_send_acmd(uint8_t acmd, uint32_t args){

sdcard_send_command(55,0);

uint8_t resp = 0;
do {
  resp = sdcard_receive(0);
} while (resp & 0x80);

if (resp != 0x01) return 0;

sdcard_send_command(acmd, args);

return 1;
} // sdcard_send_acmd

uint8_t sdcard_receive(uint8_t check_0xff){

cs_off();
spi->spdr = 0xff;

while (! (spi->spsr & (1<<SPIF)));

uint8_t data = spi->spdr;

cs_on();
if (check_0xff){
  uint8_t timeout = 0;
  while ((data == 0xff) && (timeout < 100)){

    cs_off();
    spi->spdr = 0xff;
    while (! (spi->spsr & (1<<SPIF)));
    data = spi->spdr;
    cs_on();

    timeout++;
  }
  // No need to check. It will return the data nevertheless.
}

cs_on();
return data;

} // sdcard_receive

void send_cmd58(uint8_t results[5]){
  sdcard_send_command(58, 0);

  uint8_t resp;

  resp = sdcard_receive(1);

  results[0] = resp;
  results[1] = sdcard_receive(0);
  results[2] = sdcard_receive(0);
  results[3] = sdcard_receive(0);
  results[4] = sdcard_receive(0);
} // send_cmd58

uint8_t get_v2_capacity(){

  uint8_t resp, timeout;

timeout = 0;

do {
  sdcard_send_acmd(41,0x40000000);
  resp = sdcard_receive(1);
  if (resp == 0xff) return 255;

  timeout++;
} while ((resp == 0x01) && (timeout < 100));
if (timeout == 100) return 255;

return resp;

} // get_v2_capacity

uint8_t get_v1_capacity(){
  uint8_t resp, timeout;
  timeout = 0; 
  
  do {
    sdcard_send_acmd(41,0x00000000);
    resp = sdcard_receive(1);
    if (resp == 0xff) return 255;
  
    timeout++;
  } while ((resp == 0x01) && (timeout < 100));
  if (timeout == 100) return 255;
  
  return resp;
} // get_v1_capacity

uint8_t get_mmc_capacity(){

uint8_t resp, timeout, timeout2;
timeout = 0; timeout2 = 0;

do {
  sdcard_send_command(1,0x00000000);
  resp = sdcard_receive(1);
  if (resp == 0xff) return 255;

  timeout++;
} while ((resp == 0x01) && (timeout < 100));
if (timeout == 100) return 255;

return resp;

} // get_mmc_capacity

uint8_t sdcard_init(uint8_t stop_at_step){

uint8_t count = 0;

*ddrb |= (1<<PB5) | (1<<PB3) | (1<<PB2);

spi->spcr = 0b01010010;

spi->spsr &= 0b11111110 | (0<<SPI2X);

cs_on();
for (int i =0; i < 10; i++){
  send_byte(0xff);
}

if (stop_at_step == INIT_STOP_SPI) return 1;

uint8_t resp = 0;
count = 0;
while (resp != 0x01 && count < 100){
  sdcard_send_command(0,0);
  resp = sdcard_receive(0);
  uint8_t count2 = 0;
  while ((resp & 0x80) && (count2 < 100)){
    resp = sdcard_receive(0);
    count2++;
  }
  if (count2 == 100) return 255;
  count++;
}
if (count == 100) return 254;

if (stop_at_step == INIT_STOP_CMD0) return 1;

count = 0;
sdcard_send_command(8, 0x1AA);
resp = sdcard_receive(1);
if (resp == 0xff) return 253;

if (resp == 0x01) {

resp = sdcard_receive(0);
resp = sdcard_receive(0);
uint8_t resp0 = sdcard_receive(0);
resp = sdcard_receive(0);
if ((resp0 & 0x0f) == 0x01 && 
    (resp == 0xAA)) {

if (!get_v2_capacity()) return 252;

uint8_t cmd58resp[5];
send_cmd58(cmd58resp);
if ( (cmd58resp[0] == 0x01) &&
     (cmd58resp[4] & 0b00000010)){
  // CCS bit is 1
  use_address = USE_BYTE_ADDRESS;
}else{
  use_address = USE_BLOCK_ADDRESS;
} // if cmd58resp...

}else{ // if (resp0 & 0x0f... ) 0x1AA pattern mismatch
  return 251;
} // if (resp0 & 0x0f...)

}else{ // CMD8 failed (0x01 R1 answer)

// It is a version 1 card.
if (!get_v1_capacity()){
  // It is an MMC v.3 card.
  if (!get_mmc_capacity()) return 250;
}

} // if (resp == 0x01)... ("if" that checks CMD8 answer)

if (stop_at_step == INIT_STOP_CMD8) return 1;

count = 0;
sdcard_send_command(16, 0x00000200);
resp = sdcard_receive(1);
if (resp == 0xff) return 249;

return 1;
} // sdcard_init

uint8_t* sdcard_last_cmd(){
  return last_cmd;
}

uint8_t sdcard_use_address(){
  return use_address;
} // sdcard_use_address
