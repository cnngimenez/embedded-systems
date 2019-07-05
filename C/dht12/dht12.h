/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   dht12.h
   
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

#ifndef _DHT12_H
#define _DHT12_H 1

#include <stdint.h>

typedef struct {
  uint8_t humidity;
  uint8_t humidity_dec;
  uint8_t temp;
  uint8_t temp_dec;
  uint8_t checksum;
} dht12data_t;

dht12data_t last_reading;

void dht12_init();

#define GET_SUCCESS 1
int dht12_get();

#define DHT12_HUMIDITY 0x00
#define DHT12_HUMDEC 0x01
#define DHT12_TEMP 0x02
#define DHT12_TEMPDEC 0x03
#define DHT12_CHECKSUM 0x04
uint8_t dht12_get_data(uint8_t addr, uint8_t *data);

#endif // _DHT12_H
