/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   sdcard.h
   
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

#ifndef _SDCARD_H
#define _SDCARD_H 1

#include <stdint.h>

#define USE_ADDRESS_UNDEFINED 0x00
#define USE_BYTE_ADDRESS 0x01
#define USE_BLOCK_ADDRESS 0x02

#define INIT_STOP_NONE 0
#define INIT_STOP_SPI 1
#define INIT_STOP_CMD0 2
#define INIT_STOP_CMD8 3

uint8_t sdcard_init(uint8_t stop_at_step);
uint8_t sdcard_send_acmd(uint8_t acmd, uint32_t args);
void sdcard_send_command(uint8_t command, uint32_t arguments);
void sdcard_send_command_raw(uint8_t cmd[6]);

uint8_t sdcard_receive(uint8_t check_0xff);

uint8_t* sdcard_last_cmd();

uint8_t sdcard_use_address();

#endif // _SDCARD_H
