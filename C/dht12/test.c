/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   test.c
   
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

#include <stdint.h>

#include "../libs/usart-lib.h"

#include "../libs/i2c.h"

void main(){

serial_init();
serial_send_string("\n\rUSART initialized.\n\r");

i2c_init(14, 0);
serial_send_string("I2C initialized.\n\r");

uint8_t resp;
uint8_t data;

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_w(0xb8);
serial_send_string("\n\rSLA+W:");
serial_send_hex(resp);

resp = i2c_send(0x00);
serial_send_string("\n\rSend data:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_r(0xb8);
serial_send_string("\n\rSLA+R:");
serial_send_hex(resp);

resp = i2c_receive(&data, 1);
serial_send_string("\n\rReceived data:");
serial_send_hex(data);

serial_send_string(" | Status:");
serial_send_hex(resp);

resp = i2c_stop();
serial_send_string("\n\rSTOP:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_w(0xb8);
serial_send_string("\n\rSLA+W:");
serial_send_hex(resp);

resp = i2c_send(0x01);
serial_send_string("\n\rSend data:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_r(0xb8);
serial_send_string("\n\rSLA+R:");
serial_send_hex(resp);

resp = i2c_receive(&data, 1);
serial_send_string("\n\rReceived data:");
serial_send_hex(data);

serial_send_string(" | Status:");
serial_send_hex(resp);

resp = i2c_stop();
serial_send_string("\n\rSTOP:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_w(0xb8);
serial_send_string("\n\rSLA+W:");
serial_send_hex(resp);

resp = i2c_send(0x02);
serial_send_string("\n\rSend data:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_r(0xb8);
serial_send_string("\n\rSLA+R:");
serial_send_hex(resp);

resp = i2c_receive(&data, 1);
serial_send_string("\n\rReceived data:");
serial_send_hex(data);

serial_send_string(" | Status:");
serial_send_hex(resp);

resp = i2c_stop();
serial_send_string("\n\rSTOP:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_w(0xb8);
serial_send_string("\n\rSLA+W:");
serial_send_hex(resp);

resp = i2c_send(0x03);
serial_send_string("\n\rSend data:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_r(0xb8);
serial_send_string("\n\rSLA+R:");
serial_send_hex(resp);

resp = i2c_receive(&data, 1);
serial_send_string("\n\rReceived data:");
serial_send_hex(data);

serial_send_string(" | Status:");
serial_send_hex(resp);

resp = i2c_stop();
serial_send_string("\n\rSTOP:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_w(0xb8);
serial_send_string("\n\rSLA+W:");
serial_send_hex(resp);

resp = i2c_send(0x04);
serial_send_string("\n\rSend data:");
serial_send_hex(resp);

resp = i2c_start();
serial_send_string("\n\rSTART:");
serial_send_hex(resp);

resp = i2c_sla_r(0xb8);
serial_send_string("\n\rSLA+R:");
serial_send_hex(resp);

resp = i2c_receive(&data, 1);
serial_send_string("\n\rReceived data:");
serial_send_hex(data);

serial_send_string(" | Status:");
serial_send_hex(resp);

resp = i2c_stop();
serial_send_string("\n\rSTOP:");
serial_send_hex(resp);

} // main
