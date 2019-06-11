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

#ifdef USART_CHARACTER_SIZE_9
serial->status_control_b |= (1<<UCSZ02);
#endif

/*
// (0<<RCXIE0) | (0<<TCXIE0) | (0<<UDRIE) |
| (1<<RXEN0) | (1<<TXEN0);
// (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
*/

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

}

char serial_get_char(){

while (! (serial->status_control_a & (1<<RXC0)));

char c = serial->data;
return c;

}

void serial_put_char(char c){

while (! (serial->status_control_a & (1<<UDRE0)));

serial->data = c;

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
