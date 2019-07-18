;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; vectors-atmega2560-inc.asm
	   
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


;; Vector table for the AVR ATmega 2560.

.org 0
    rjmp RESET       ; Reset Handler 
    rjmp INT0        ; IRQ0 Handler 
    rjmp INT1        ; IRQ1 Handler 
    rjmp INT2        ; IRQ2 Handler 
    rjmp INT3        ; IRQ3 Handler 
    rjmp INT4        ; IRQ4 Handler 
    rjmp INT5        ; IRQ5 Handler 
    rjmp INT6        ; IRQ6 Handler 
    rjmp INT7        ; IRQ7 Handler 
    rjmp PCINT0      ; PCINT0 Handler 
    rjmp PCINT1      ; PCINT1 Handler 
    rjmp PCINT2      ; PCINT2 Handler 
    rjmp WD          ; Watchdog Timeout Handler 
    rjmp TIM2_COMPA  ; Timer2 CompareA Handler 
    rjmp TIM2_COMPB  ; Timer2 CompareB Handler 
    rjmp TIM2_OVF    ; Timer2 Overflow Handler 
    rjmp TIM1_CAPT   ; Timer1 Capture Handler 
    rjmp TIM1_COMPA  ; Timer1 CompareA Handler 
    rjmp TIM1_COMPB  ; Timer1 CompareB Handler 
    rjmp TIM1_COMPC  ; Timer1 CompareC Handler 
    rjmp TIM1_OVF    ; Timer1 Overflow Handler 
    rjmp TIM0_COMPA  ; Timer0 CompareA Handler 
    rjmp TIM0_COMPB  ; Timer0 CompareB Handler 
    rjmp TIM0_OVF    ; Timer0 Overflow Handler 
    rjmp SPI_STC     ; SPI Transfer Complete Handler 
    rjmp USART0_RXC  ; USART0 RX Complete Handler 
    rjmp USART0_UDRE ; USART0,UDR Empty Handler 
    rjmp USART0_TXC  ; USART0 TX Complete Handler 
    rjmp ANA_COMP    ; Analog Comparator Handler 
    rjmp ADC         ; ADC Conversion Complete Handler 
    rjmp EE_RDY      ; EEPROM Ready Handler 
    rjmp TIM3_CAPT   ; Timer3 Capture Handler 
    rjmp TIM3_COMPA  ; Timer3 CompareA Handler 
    rjmp TIM3_COMPB  ; Timer3 CompareB Handler 
    rjmp TIM3_COMPC  ; Timer3 CompareC Handler 
    rjmp TIM3_OVF    ; Timer3 Overflow Handler 
    rjmp USART1_RXC  ; USART1 RX Complete Handler 
    rjmp USART1_UDRE ; USART1,UDR Empty Handler 
    rjmp USART1_TXC  ; USART1 TX Complete Handler 
    rjmp TWI         ; 2-wire Serial Handler 
    rjmp SPM_RDY     ; SPM Ready Handler 
    rjmp TIM4_CAPT   ; Timer4 Capture Handler 
    rjmp TIM4_COMPA  ; Timer4 CompareA Handler 
    rjmp TIM4_COMPB  ; Timer4 CompareB Handler 
    rjmp TIM4_COMPC  ; Timer4 CompareC Handler 
    rjmp TIM4_OVF    ; Timer4 Overflow Handler 
    rjmp TIM5_CAPT   ; Timer5 Capture Handler 
    rjmp TIM5_COMPA  ; Timer5 CompareA Handler 
    rjmp TIM5_COMPB  ; Timer5 CompareB Handler 
    rjmp TIM5_COMPC  ; Timer5 CompareC Handler 
    rjmp TIM5_OVF    ; Timer5 Overflow Handler 
    rjmp USART2_RXC  ; USART2 RX Complete Handler 
    rjmp USART2_UDRE ; USART2,UDR Empty Handler 
    rjmp USART2_TXC  ; USART2 TX Complete Handler 
    rjmp USART3_RXC  ; USART3 RX Complete Handler 
    rjmp USART3_UDRE ; USART3,UDR Empty Handler 
    rjmp USART3_TXC  ; USART3 TX Complete Handler 		

;; .org 0x72
	
