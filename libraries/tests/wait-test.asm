;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; wait-test.asm
	   
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

	.include "../vector-inc.asm"
	.include "../registers-inc.asm"

RESET:
	rcall USART_INIT
	ldi r18, 'h'
	rcall USART_PUT
	ldi r16, 0x05
	rcall WAIT
	
	ldi r18, 'e'
	rcall USART_PUT
	rcall WAIT
	
	ldi r18, 'l'
	rcall USART_PUT
	rcall WAIT
	
	ldi r18, 'l'
	rcall USART_PUT
	rcall WAIT
	
	ldi r18, 'o'
	rcall USART_PUT
	
	rjmp END
	
	.include "../usart-lib.asm"
	.include "../wait-lib.asm"
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
    break
    rjmp END
