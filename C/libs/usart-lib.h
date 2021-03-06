/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   usar-lib.h
   
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

#ifndef _USART_LIB_H
#define _USART_LIB_H 1

#include <stdint.h>

#include <math.h>

#define OSC_FREQUENCY 16000000UL // 16MHz
#define BAUD_RATE 9600 // bps

// Apply the UBRR formulae according to the Atmega 328 datasheet.
#define BRR_VALUE (unsigned long) round(OSC_FREQUENCY/16.0/BAUD_RATE) - 1

#define USART_RX_ENABLE 1
#define USART_TX_ENABLE 1

// #define USART_RX_INT_ENABLE 1
// #define USART_TX_INT_ENABLE 1
// #define USART_UDR_INT_ENABLE 1

// #define USART_CHARACTER_SIZE_5 1
// #define USART_CHARACTER_SIZE_6 1
// #define USART_CHARACTER_SIZE_7 1
#define USART_CHARACTER_SIZE_8 1
// #define USART_CHARACTER_SIZE_9 1

#define USART_ASYNC_MODE 1
// #define USART_SYNC_MODE 1
// #define USART_MASTER_SPI_MODE 1

#define USART_PARITY_CHECK_DISABLE 1
// #define USART_PARITY_CHECK_ODD 1
// #define USART_PARITY_CHECK_EVEN 1

#define USART_STOP_BIT_ONE 1
// #define USART_STOP_BIT_TWO 1

#define USART_POLARITY_TX_RISING 1
// #define USART_POLARITY_TX_FALLING 1

/*
 Uncomment this for enabling USART 1 registers and methods.
 Its mode is configure at the usart_1_config.h file.
*/
// #define USART_1

#ifdef USART_1
#include "usart_1_config.h"
#endif

/*
 Uncomment this for enabling USART 2 registers and methods.
 Its mode is configure at the usart_2_config.h file.
*/
// #define USART_2

#ifdef USART_2
#include "usart_2_config.h"
#endif

/*
 Uncomment this for enabling USART 3 registers and methods.
 Its mode is configure at the usart_3_config.h file.
*/
// #define USART_3

#ifdef USART_3
#include "usart_3_config.h"
#endif

void serial_init();

char serial_get_char();

char* serial_get_line();

char* serial_get_string();

int serial_get_integer();

void serial_put_char(char c);

void serial_send_string(char *s);

void serial_send_hex(uint8_t number);

void serial_send_integer(int number);

#define GET_CHAR_FNC(N) char serial ##N## _get_char();
#define GET_LINE_FNC(N) char* serial  ##N## _get_line();
#define GET_STRING_FNC(N) char* serial ##N## _get_string();
#define GET_INTEGER_FNC(N) int serial ##N## _get_integer();

#define PUT_CHAR_FNC(N) void serial ##N## _put_char(char c);
#define SEND_STRING_FNC(N) void serial ##N## _send_string(char *s);
#define SEND_INTEGER_FNC(N) void serial ##N## _send_integer(int number);

#ifdef USART_1

GET_CHAR_FNC(1)
GET_LINE_FNC(1)
GET_STRING_FNC(1)
GET_INTEGER_FNC(1)

PUT_CHAR_FNC(1)
SEND_STRING_FNC(1)
SEND_INTEGER_FNC(1)

#endif

#ifdef USART_2

GET_CHAR_FNC(2)
GET_LINE_FNC(2)
GET_STRING_FNC(2)
GET_INTEGER_FNC(2)

PUT_CHAR_FNC(2)
SEND_STRING_FNC(2)
SEND_INTEGER_FNC(2)

#endif

#ifdef USART_3

GET_CHAR_FNC(3)
GET_LINE_FNC(3)
GET_STRING_FNC(3)
GET_INTEGER_FNC(3)

PUT_CHAR_FNC(3)
SEND_STRING_FNC(3)
SEND_INTEGER_FNC(3)

#endif

#endif // _USART_LIB_H
