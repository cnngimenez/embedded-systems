/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   uart.h
   
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

#ifndef _UART_H
#define _UART_H 1

#include <stdint.h>

#include <math.h>

#define OSC_FREQUENCY 16000000UL // 16MHz
#define BAUD_RATE 9600 // bps

// Apply the UBRR formulae according to the Atmega 328 datasheet.
#define BRR_VALUE round(OSC_FREQUENCY/16.0/BAUD_RATE) - 1

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

void serial_init();
char serial_get_char();
void serial_put_char(char c);

#endif
