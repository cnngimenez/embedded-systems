#include "uart.h"

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

serial->baud_rate_h = (unsigned char) (BRR_VALUE >> 8);
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
#ifdef USART_CHARACTER_SIZE 8
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
