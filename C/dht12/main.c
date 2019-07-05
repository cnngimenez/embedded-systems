#include "dht12.h"

#include "../libs/usart-lib.h"

void main(){

serial_init();
serial_send_string("USART initialized.\n\r");

dht12_init();
serial_send_string("DHT12 initialized.\n\r");

unsigned long i = 0;
uint8_t resp;

while (1){

serial_send_string("\n\rTemp:");
serial_send_hex(last_reading.temp);
serial_send_string("\n\rTemp Decimals:");
serial_send_hex(last_reading.temp_dec);

serial_send_string("\n\rHum:");
serial_send_hex(last_reading.humidity);
serial_send_string("\n\rHum Decimals:");
serial_send_hex(last_reading.humidity_dec);
serial_send_string("\n\r");

resp = dht12_get();
if (resp != GET_SUCCESS){
  serial_send_string("Error getting data\n\r");
  serial_send_hex(resp);
  serial_send_string("\n\r");
}

for (i = 0; i < 4000000; i++);

} // while

} // main
