.include "../libraries/vector-inc.asm"
.include "../libraries/registers-inc.asm"

.text

RESET:

sbi ODDRB, 5

ldi r16, 0
ldi r17, 103
sts UBRR0H, r16
sts UBRR0L, r17

lds r16, UCSR0B
set
bld r16, 4       ; RXEN0 bit enabled
set
bld r16, 3       ; TXEN0 bit enabled
sts UCSR0B, r16

TXWAIT:
    cbi OPORTB, 5     ; Turn off L led

    lds r16, UCSR0A
    sbrs r16, 5       ; bit 5 is UDRE
    rjmp TXWAIT

sbi OPORTB, 5    ; turn on L led

ldi r16, 65
sts UDR0, r16

RX_LOOP:

lds r16, UCSR0A
sbrs r16, 7       ; RXC0 is 7th bit
rjmp RX_LOOP

lds r17, UDR0

TXWAIT2:
    lds r16, UCSR0A
    sbrs r16, 5      ; UDRE is the 5th bit
    rjmp TXWAIT2

sts UDR0, r17

rjmp RX_LOOP

;; __________________________________________________
	;; Vector Handlers
	
EXT_INT0:	; IRQ0 Handler 
EXT_INT1:	; IRQ1 Handler 
PCINT0:		; PCINT0 Handler 
PCINT1:		; PCINT1 Handler 
PCINT2:		; PCINT2 Handler 
WDT:		; Watchdog Timer Handler 
TIM2_COMPA:	; Timer2 Compare A Handler 
TIM2_COMPB:	; Timer2 Compare B Handler 
TIM2_OVF:	; Timer2 Overflow Handler 
TIM1_CAPT:	; Timer1 Capture Handler 
TIM1_COMPA:	; Timer1 Compare A Handler 
TIM1_COMPB:	; Timer1 Compare B Handler 
TIM1_OVF:	; Timer1 Overflow Handler 
TIM0_COMPA:	; Timer0 Compare A Handler 
TIM0_COMPB:	; Timer0 Compare B Handler 
TIM0_OVF:	; Timer0 Overflow Handler 
SPI_STC:	; SPI Transfer Complete Handler 
USART_RXC:	; USART, RX Complete Handler 
USART_UDRE:	; USART, UDR Empty Handler 
USART_TXC:	; USART, TX Complete Handler 
ADC:		; ADC Conversion Complete Handler 
EE_RDY:		; EEPROM Ready Handler 
ANA_COMP:	; Analog Comparator Handler 
TWI:		; 2-wire Serial Interface Handler 
SMP_RDY:	; SPM_RDYStore Program Memory Ready

;; __________________________________________________
END:
	nop
