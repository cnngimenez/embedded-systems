#include "dht12.h"

#include <stdint.h>

#include <avr/io.h>

#include "../libs/i2c.h"

void dht12_init(){

i2c_init(14, 0b11111100); // TMBR = 14, TWPS = 0

dht12_get();

} // dht12_init

uint8_t dht12_get_data(uint8_t addr, uint8_t *data){

uint8_t resp;

resp = i2c_start();
/*if (resp != MT_START_TRANSMITTED && resp != MT_RSTART_TRANSMITTED){
 return resp;
 }*/

resp = i2c_sla_w(0xb8);
/*if (resp != MT_SLAACK_RECEIVED) {
  return resp;
  }*/

resp = i2c_send(addr);
/*if (resp != MT_ACK_DATAREC) {
  return resp;
}*/

resp = i2c_start();
/*if (resp != MR_RSTART_TRANSMITTED){
  return resp;
}*/

resp = i2c_sla_r(0xb8);
/*if (resp != MR_SLAACK_RECEIVED) {
  return resp;
}*/

resp = i2c_receive(data, 1);
/*if (resp != MR_NACK_DATAREC){
  return resp;
}*/

resp = i2c_stop();

return 1;
} // dht12_get_data

int dht12_get(){

uint8_t data;
uint8_t resp;

resp = dht12_get_data(0x00, &data);
if (resp != 1){
  return resp;
}
last_reading.humidity = data;

resp = dht12_get_data(0x01, &data);
if (resp != 1){
  return resp;
}
last_reading.humidity_dec = data;

resp = dht12_get_data(0x02, &data);
if (resp != 1){
  return resp;
}
last_reading.temp = data;

resp = dht12_get_data(0x03, &data);
if (resp != 1){
  return resp;
}
last_reading.temp_dec = data;

resp = dht12_get_data(0x04, &data);
if (resp != 1){
  return resp;
}
last_reading.checksum = data;

return GET_SUCCESS;
} // dht12_get
