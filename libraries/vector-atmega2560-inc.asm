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
    jmp RESET       ; Reset Handler 
    jmp INT0        ; IRQ0 Handler 
    jmp INT1        ; IRQ1 Handler 
    jmp INT2        ; IRQ2 Handler 
    jmp INT3        ; IRQ3 Handler 
    jmp INT4        ; IRQ4 Handler 
    jmp INT5        ; IRQ5 Handler 
    jmp INT6        ; IRQ6 Handler 
    jmp INT7        ; IRQ7 Handler 
    jmp PCINT0      ; PCINT0 Handler 
    jmp PCINT1      ; PCINT1 Handler 
    jmp PCINT2      ; PCINT2 Handler 
    jmp WD          ; Watchdog Timeout Handler 
    jmp TIM2_COMPA  ; Timer2 CompareA Handler 
    jmp TIM2_COMPB  ; Timer2 CompareB Handler 
    jmp TIM2_OVF    ; Timer2 Overflow Handler 
    jmp TIM1_CAPT   ; Timer1 Capture Handler 
    jmp TIM1_COMPA  ; Timer1 CompareA Handler 
    jmp TIM1_COMPB  ; Timer1 CompareB Handler 
    jmp TIM1_COMPC  ; Timer1 CompareC Handler 
    jmp TIM1_OVF    ; Timer1 Overflow Handler 
    jmp TIM0_COMPA  ; Timer0 CompareA Handler 
    jmp TIM0_COMPB  ; Timer0 CompareB Handler 
    jmp TIM0_OVF    ; Timer0 Overflow Handler 
    jmp SPI_STC     ; SPI Transfer Complete Handler 
    jmp USART0_RXC  ; USART0 RX Complete Handler 
    jmp USART0_UDRE ; USART0,UDR Empty Handler 
    jmp USART0_TXC  ; USART0 TX Complete Handler 
    jmp ANA_COMP    ; Analog Comparator Handler 
    jmp ADC         ; ADC Conversion Complete Handler 
    jmp EE_RDY      ; EEPROM Ready Handler 
    jmp TIM3_CAPT   ; Timer3 Capture Handler 
    jmp TIM3_COMPA  ; Timer3 CompareA Handler 
    jmp TIM3_COMPB  ; Timer3 CompareB Handler 
    jmp TIM3_COMPC  ; Timer3 CompareC Handler 
    jmp TIM3_OVF    ; Timer3 Overflow Handler 
    jmp USART1_RXC  ; USART1 RX Complete Handler 
    jmp USART1_UDRE ; USART1,UDR Empty Handler 
    jmp USART1_TXC  ; USART1 TX Complete Handler 
    jmp TWI         ; 2-wire Serial Handler 
    jmp SPM_RDY     ; SPM Ready Handler 
    jmp TIM4_CAPT   ; Timer4 Capture Handler 
    jmp TIM4_COMPA  ; Timer4 CompareA Handler 
    jmp TIM4_COMPB  ; Timer4 CompareB Handler 
    jmp TIM4_COMPC  ; Timer4 CompareC Handler 
    jmp TIM4_OVF    ; Timer4 Overflow Handler 
    jmp TIM5_CAPT   ; Timer5 Capture Handler 
    jmp TIM5_COMPA  ; Timer5 CompareA Handler 
    jmp TIM5_COMPB  ; Timer5 CompareB Handler 
    jmp TIM5_COMPC  ; Timer5 CompareC Handler 
    jmp TIM5_OVF    ; Timer5 Overflow Handler 
    jmp USART2_RXC  ; USART2 RX Complete Handler 
    jmp USART2_UDRE ; USART2,UDR Empty Handler 
    jmp USART2_TXC  ; USART2 TX Complete Handler 
    jmp USART3_RXC  ; USART3 RX Complete Handler 
    jmp USART3_UDRE ; USART3,UDR Empty Handler 
    jmp USART3_TXC  ; USART3 TX Complete Handler 		

;; .org 0x72
	
