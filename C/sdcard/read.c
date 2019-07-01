/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   read.c
   
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

#include "../libs/usart-lib.h"

#include "sdcard.h"

void main(){

serial_init();
serial_send_string("Serial initialized\n\r");
uint8_t initret = sdcard_init(INIT_STOP_NONE);
 if (initret) {
   serial_send_string("SD card initialized\n\r");
 }else{
   serial_send_string("SD card initialization error:");
   serial_send_hex(initret);
 }

sdcard_send_command(58,0);
serial_send_string("CMD58:");
uint8_t resp[5];
resp[0] = sdcard_receive(1);
serial_send_hex(resp[0]);
resp[1] = sdcard_receive(0);
serial_send_hex(resp[1]);
resp[2] = sdcard_receive(0);
serial_send_hex(resp[2]);
resp[3] = sdcard_receive(0);
serial_send_hex(resp[3]);
resp[4] = sdcard_receive(0);
serial_send_hex(resp[4]);

// Read some blocks
uint8_t res;
sdcard_send_command(17, 0x00);
serial_send_string("\n\rCMD17:");
res = sdcard_receive(1);
serial_send_hex(res);
serial_send_string("\n\r");

if (res == 0x00){
  int i = 0;
  for (i = 0; i < 512; i++){
    res = sdcard_receive(0);
    serial_send_hex(res);
    if (i % 2 == 0) {
      serial_put_char(' ');
    }
    if (i % 16 == 0){
      serial_send_string("\n\r");
    }
  }
}

} // main
