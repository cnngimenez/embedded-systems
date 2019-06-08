;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; vectors-inc.asm
	   
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

.org 0

rjmp  	RESET		; Reset Handler 
rjmp  	EXT_INT0  	; IRQ0 Handler 
rjmp  	EXT_INT1  	; IRQ1 Handler 
rjmp  	PCINT0  	; PCINT0 Handler 
rjmp  	PCINT1  	; PCINT1 Handler 
rjmp  	PCINT2  	; PCINT2 Handler 
rjmp  	WDT		; Watchdog Timer Handler 
rjmp  	TIM2_COMPA 	; Timer2 Compare A Handler 
rjmp  	TIM2_COMPB 	; Timer2 Compare B Handler 
rjmp  	TIM2_OVF  	; Timer2 Overflow Handler 
rjmp  	TIM1_CAPT  	; Timer1 Capture Handler 
rjmp  	TIM1_COMPA 	; Timer1 Compare A Handler 
rjmp  	TIM1_COMPB 	; Timer1 Compare B Handler 
rjmp  	TIM1_OVF 	; Timer1 Overflow Handler 
rjmp  	TIM0_COMPA 	; Timer0 Compare A Handler 
rjmp  	TIM0_COMPB 	; Timer0 Compare B Handler 
rjmp  	TIM0_OVF 	; Timer0 Overflow Handler 
rjmp  	SPI_STC  	; SPI Transfer Complete Handler 
rjmp  	USART_RXC 	; USART, RX Complete Handler 
rjmp  	USART_UDRE 	; USART, UDR Empty Handler 
rjmp  	USART_TXC	; USART, TX Complete Handler 
rjmp  	ADC	  	; ADC Conversion Complete Handler 
rjmp  	EE_RDY  	; EEPROM Ready Handler 
rjmp  	ANA_COMP	; Analog Comparator Handler 
rjmp  	TWI	  	; 2-wire Serial Interface Handler 
rjmp 	SMP_RDY 	; SPM_RDYStore Program Memory Ready

;; .org 0x20
