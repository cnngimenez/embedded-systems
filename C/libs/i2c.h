/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   i2c.h
   
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

#ifndef _I2C_H
#define _I2C_H 1

#include <stdint.h>

#define MT_START_TRANSMITTED 0x08
#define MT_RSTART_TRANSMITTED 0x10
#define MT_LOST_ERROR 0x38
#define MT_SLAACK_RECEIVED  0x18
#define MT_SLANACK_ERROR 0x20
#define MT_ACK_DATAREC 0x28
#define MT_NACK_DATAREC 0x30

#define MR_START_TRANSMITTED 0x08
#define MR_RSTART_TRANSMITTED 0x10
#define MR_LOST_ERROR 0x38
#define MR_SLAACK_RECEIVED  0x40
#define MR_SLANACK_ERROR 0x48
#define MR_ACK_DATAREC 0x50
#define MR_NACK_DATAREC 0x58

uint8_t i2c_init(uint8_t baudrate, uint8_t prescaler);

uint8_t i2c_start();

uint8_t i2c_stop();

uint8_t i2c_sla_r(uint8_t addr);
uint8_t i2c_sla_w(uint8_t addr);

uint8_t i2c_send(uint8_t data);

uint8_t i2c_receive(uint8_t *data, uint8_t send_nack);



#endif // _I2C_H
