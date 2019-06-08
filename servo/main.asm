;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; main.asm
	   
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
	   
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
	   
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Vector table
          .include "../libraries/vector-inc.asm"

          .include "../libraries/registers-inc.asm"
          .text
RESET:

ldi r16, 0b10100010
sts TCCR1A, r16

;; ICD1 = 4999 (20 ms o 50 Hz) =  1'0011'1000'0111 
ldi r16, 0b00010011
sts ICR1H, r16
ldi r16, 0b10000111
sts ICR1L, r16

ldi r16, 0b00011011
sts TCCR1B, r16

sbi ODDRB, 1

sbi ODDRB, 5

LOOP:
	rcall TURN_ON

ldi r16, 0
ldi r17, 250
    sts OCR1AH, r16
    sts OCR1AL, r17

ldi r16, 0x80
    rcall WAIT

rcall TURN_OFF

ldi r16, 0b00000001
ldi r17, 0b11110100
    sts OCR1AH, r16
    sts OCR1AL, r17

ldi r16, 0x80
    rcall WAIT

rjmp LOOP

.include "../libraries/wait-lib.asm"

TURN_ON:
	sbi OPORTB, 5
	ret

TURN_OFF:
	cbi OPORTB, 5
	ret

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
