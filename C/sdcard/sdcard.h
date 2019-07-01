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
