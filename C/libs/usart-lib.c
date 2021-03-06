/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   usart-lib.c
   
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

#include "usart-lib.h"

#include <avr/io.h>

typedef struct {
  uint8_t status_control_a;
  uint8_t status_control_b;
  uint8_t status_control_c;
  uint8_t reserved1;
  uint8_t baud_rate_l;
  uint8_t baud_rate_h;
  uint8_t data;
} volatile uart_t;

volatile uart_t *serial = (uart_t*) (0xc0);

#ifdef USART_1
volatile uart_t *serial_1 = (uart_t*) (0xc8);
#endif
#ifdef USART_2
volatile uart_t *serial_2 = (uart_t*) (0xd0);
#endif
#ifdef USART_3
volatile uart_t *serial_3 = (uart_t*) (0x130);
#endif

void serial_init(){

serial->baud_rate_h = (unsigned char) (BRR_VALUE>>8);
serial->baud_rate_l = (unsigned char) BRR_VALUE;

serial->status_control_b = 0;

#ifdef USART_RX_INT_ENABLE
serial->status_control_b |= (1<<RCXIE0);
#endif
#ifdef USART_TX_INT_ENABLE
serial->status_control_b |= (1<<TCXIEN0);
#endif
#ifdef USART_UDR_INT_ENABLE
serial->status_control_b |= (1<<UDRIE0);
#endif

#ifdef USART_RX_ENABLE
serial->status_control_b |= (1<<RXEN0);
#endif
#ifdef USART_TX_ENABLE
serial->status_control_b |= (1<<TXEN0);
#endif
/*
// (0<<RCXIE0) | (0<<TCXIE0) | (0<<UDRIE) |
| (1<<RXEN0) | (1<<TXEN0);
// (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
*/

#ifdef USART_CHARACTER_SIZE_9
serial->status_control_b |= (1<<UCSZ02);
#endif

serial->status_control_c = 0;

#ifdef USART_SYNC_MODE
serial->status_control_c |= (1<<UMLSEL0);
#endif
#ifdef USART_MASTER_SPI_MODE
serial->status_control_c |= (1<<UMLSEL1) | (1<<UMLSEL0);
#endif

#ifdef USART_PARITY_CHECK_ODD
serial->status_control_c |= (1<<UPM1) | (1<<UPM0) ;
#endif
#ifdef USART_PARITY_CHECK_EVEN
serial->status_control_c |= (1<<UPM1);
#endif

#ifdef USART_STOP_BIT_TWO
serial->status_control_c |= (1<<USBS0);
#endif

#ifdef USART_CHARACTER_SIZE_8
serial->status_control_c |= (1<<UCSZ01) | (1<<UCSZ00);
#endif
#ifdef USART_CHARACTER_SIZE_7
serial->status_control_c |= (1<<UCSZ01);
#endif
#ifdef USART_CHARACTER_SIZE_6
serial->status_control_c |= (1<<UCSZ00);
#endif

#ifdef USART_POLARITY_TX_FALLING
serial->status_control_c |= (1<<UCPOL0);
#endif


/*
| (1<<UCSZ01) | (1<<UCSZ00);
*/

#ifdef USART1

serial1->baud_rate_h = (unsigned char) (USART1_BRR_VALUE>>8);
serial1->baud_rate_l = (unsigned char) USART1_BRR_VALUE;

serial1->status_control_b = 0;

#ifdef USART1_RX_INT_ENABLE
serial1->status_control_b |= (1<<USART1_RCXIE0);
#endif
#ifdef USART1_TX_INT_ENABLE
serial1->status_control_b |= (1<<USART1_TCXIEN0);
#endif
#ifdef USART1_UDR_INT_ENABLE
serial1->status_control_b |= (1<<USART1_UDRIE0);
#endif

#ifdef USART1_RX_ENABLE
serial1->status_control_b |= (1<<USART1_RXEN0);
#endif
#ifdef USART1_TX_ENABLE
serial1->status_control_b |= (1<<USART1_TXEN0);
#endif

#ifdef USART1_CHARACTER_SIZE_9
serial1->status_control_b |= (1<<USART1_UCSZ02);
#endif

serial1->status_control_c = 0;

#ifdef USART1_SYNC_MODE
serial1->status_control_c |= (1<<USART1_UMLSEL0);
#endif
#ifdef USART1_MASTER_SPI_MODE
serial1->status_control_c |= (1<<USART1_UMLSEL1) | (1<<USART1_UMLSEL0);
#endif

#ifdef USART1_PARITY_CHECK_ODD
serial1->status_control_c |= (1<<USART1_UPM1) | (1<<USART1_UPM0) ;
#endif
#ifdef USART1_PARITY_CHECK_EVEN
serial1->status_control_c |= (1<<USART1_UPM1);
#endif

#ifdef USART1_STOP_BIT_TWO
serial1->status_control_c |= (1<<USART1_USBS0);
#endif

#ifdef USART1_CHARACTER_SIZE_8
serial1->status_control_c |= (1<<USART1_UCSZ01) | (1<<USART1_UCSZ00);
#endif
#ifdef USART1_CHARACTER_SIZE_7
serial1->status_control_c |= (1<<USART1_UCSZ01);
#endif
#ifdef USART1_CHARACTER_SIZE_6
serial1->status_control_c |= (1<<USART1_UCSZ00);
#endif

#ifdef USART1_POLARITY_TX_FALLING
serial1->status_control_c |= (1<<USART1_UCPOL0);
#endif

#endif // USART_1

#ifdef USART_2

serial2->baud_rate_h = (unsigned char) (USART2_BRR_VALUE>>8);
serial2->baud_rate_l = (unsigned char) USART2_BRR_VALUE;

serial2->status_control_b = 0;

#ifdef USART2_RX_INT_ENABLE
serial2->status_control_b |= (1<<USART2_RCXIE0);
#endif
#ifdef USART2_TX_INT_ENABLE
serial2->status_control_b |= (1<<USART2_TCXIEN0);
#endif
#ifdef USART2_UDR_INT_ENABLE
serial2->status_control_b |= (1<<USART2_UDRIE0);
#endif

#ifdef USART2_RX_ENABLE
serial2->status_control_b |= (1<<USART2_RXEN0);
#endif
#ifdef USART2_TX_ENABLE
serial2->status_control_b |= (1<<USART2_TXEN0);
#endif

#ifdef USART2_CHARACTER_SIZE_9
serial2->status_control_b |= (1<<USART2_UCSZ02);
#endif

serial2->status_control_c = 0;

#ifdef USART2_SYNC_MODE
serial2->status_control_c |= (1<<USART2_UMLSEL0);
#endif
#ifdef USART2_MASTER_SPI_MODE
serial2->status_control_c |= (1<<USART2_UMLSEL1) | (1<<USART2_UMLSEL0);
#endif

#ifdef USART2_PARITY_CHECK_ODD
serial2->status_control_c |= (1<<USART2_UPM1) | (1<<USART2_UPM0) ;
#endif
#ifdef USART2_PARITY_CHECK_EVEN
serial2->status_control_c |= (1<<USART2_UPM1);
#endif

#ifdef USART2_STOP_BIT_TWO
serial2->status_control_c |= (1<<USART2_USBS0);
#endif

#ifdef USART2_CHARACTER_SIZE_8
serial2->status_control_c |= (1<<USART2_UCSZ01) | (1<<USART2_UCSZ00);
#endif
#ifdef USART2_CHARACTER_SIZE_7
serial2->status_control_c |= (1<<USART2_UCSZ01);
#endif
#ifdef USART2_CHARACTER_SIZE_6
serial2->status_control_c |= (1<<USART2_UCSZ00);
#endif

#ifdef USART2_POLARITY_TX_FALLING
serial2->status_control_c |= (1<<USART2_UCPOL0);
#endif

#endif // USART_2

#ifdef USART_3

serial3->baud_rate_h = (unsigned char) (USART3_BRR_VALUE>>8);
serial3->baud_rate_l = (unsigned char) USART3_BRR_VALUE;

serial3->status_control_b = 0;

#ifdef USART3_RX_INT_ENABLE
serial3->status_control_b |= (1<<USART3_RCXIE0);
#endif
#ifdef USART3_TX_INT_ENABLE
serial3->status_control_b |= (1<<USART3_TCXIEN0);
#endif
#ifdef USART3_UDR_INT_ENABLE
serial3->status_control_b |= (1<<USART3_UDRIE0);
#endif

#ifdef USART3_RX_ENABLE
serial3->status_control_b |= (1<<USART3_RXEN0);
#endif
#ifdef USART3_TX_ENABLE
serial3->status_control_b |= (1<<USART3_TXEN0);
#endif

#ifdef USART3_CHARACTER_SIZE_9
serial3->status_control_b |= (1<<USART3_UCSZ02);
#endif

serial3->status_control_c = 0;

#ifdef USART3_SYNC_MODE
serial3->status_control_c |= (1<<USART3_UMLSEL0);
#endif
#ifdef USART3_MASTER_SPI_MODE
serial3->status_control_c |= (1<<USART3_UMLSEL1) | (1<<USART3_UMLSEL0);
#endif

#ifdef USART3_PARITY_CHECK_ODD
serial3->status_control_c |= (1<<USART3_UPM1) | (1<<USART3_UPM0) ;
#endif
#ifdef USART3_PARITY_CHECK_EVEN
serial3->status_control_c |= (1<<USART3_UPM1);
#endif

#ifdef USART3_STOP_BIT_TWO
serial3->status_control_c |= (1<<USART3_USBS0);
#endif

#ifdef USART3_CHARACTER_SIZE_8
serial3->status_control_c |= (1<<USART3_UCSZ01) | (1<<USART3_UCSZ00);
#endif
#ifdef USART3_CHARACTER_SIZE_7
serial3->status_control_c |= (1<<USART3_UCSZ01);
#endif
#ifdef USART3_CHARACTER_SIZE_6
serial3->status_control_c |= (1<<USART3_UCSZ00);
#endif

#ifdef USART3_POLARITY_TX_FALLING
serial3->status_control_c |= (1<<USART3_UCPOL0);
#endif

#endif // USART_3

}

char _serial_get_char(uart_t *p_serial){

while (! (p_serial->status_control_a & (1<<RXC0)));

char c = p_serial->data;
return c;

} // _serial_get_char

void _serial_put_char(uart_t *p_serial, char c){

while (! (p_serial->status_control_a & (1<<UDRE0)));

p_serial->data = c;

}

void serial_put_char(char c){
  _serial_put_char(serial, c);
}

char serial_get_char(){
  return _serial_get_char(serial);
}

void serial_send_string(char *s){

unsigned int i = 0;

char c = s[i];

while (c){
  serial_put_char(c);
  i++;
  c = s[i];
}

}

void serial_send_integer(int number){

char s[100];

uint8_t i = 0;

if (number < 0){
  number = number * -1;
  s[i] = '-';
  i++;
 }

while (number) {

uint8_t digit = number % 10;
number = number/10;

s[i] = digit + '0';
 i++;
}

s[i] = '\0';

int j = 0;
if (s[0] == '-'){
  j = 1;
}

for (i=i-1; i > j ; i--){
  char c = s[i];
  s[i] = s[j];
  s[j] = c;
  j++;
}

serial_send_string(s);

}

void serial_send_hex(uint8_t number){

char s[3] = "\0\0\0";
uint8_t digit1 = (number>>4);
if (digit1 < 10){
  s[0] = digit1 + '0';
}

switch (digit1){
  case 10:
    s[0] = 'A';
    break;
  case 11:
    s[0] = 'B';
    break;
  case 12:
    s[0] = 'C';
    break;
  case 13:
    s[0] = 'D';
    break;
  case 14:
    s[0] = 'E';
    break;
  case 15:
    s[0] = 'F';
    break;
}

uint8_t digit2 = (number & 0b00001111);
if (digit2 < 10){
  s[1] = digit2 + '0';
}

switch (digit2){
  case 10:
    s[1] = 'A';
    break;
  case 11:
    s[1] = 'B';
    break;
  case 12:
    s[1] = 'C';
    break;
  case 13:
    s[1] = 'D';
    break;
  case 14:
    s[1] = 'E';
    break;
  case 15:
    s[1] = 'F';
    break;
}

serial_send_string(s);

} // serial_send_hex
