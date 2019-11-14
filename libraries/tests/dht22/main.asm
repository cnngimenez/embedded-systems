;; License

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

;; Including needed files

.include "../../vector-atmega2560-inc.asm"
.include "../../registers-atmega2560-inc.asm"

;; Definind some memory address
;; The following are linked addresses.


.data
sensord:

;; Starting main routine

.text
RESET:

;; Set the memory
;; The Z registers will store the memory address where the readed data is saved. 


    ldi ZL, lo8(sensord)
    ldi ZH, hi8(sensord)

;; Initialize libraries
;; Initialize USART library and send something for testing purposes.


    rcall USART_INIT
    ldi r18, 'h'
    rcall USART_PUT

;; Read a data

main_loop:
    rcall DHT_START

    rcall DHT_RECEIVE

    ldi r18, 's'
    rcall USART_PUT

    
    ldi r18, '\n'
    rcall USART_PUT
    ldi r18, '\r'
    rcall USART_PUT

;; Get RH

    ld XH, Z
    ldd XL, Z+1
    rcall USART_HEX

    ldi r18, ' '
    rcall USART_PUT

;; Get T

    ldd XH, Z+2
    ldd XL, Z+3
    rcall USART_HEX

    ldi r18, ' '
    rcall USART_PUT

;; Checksum

    ldd XH, Z+4
    ldi XL, 0xff
    rcall USART_HEX

    ldi r18, ' '
    rcall USART_PUT

;; End program

    ldi r18, 1
    rcall WAIT
    rjmp main_loop

;; Include libraries

.include "../../dht22-lib.asm"
.include "../../usart-lib.asm"
.include "../../wait-lib.asm"

;; Interruption  handlers

;; Vector Handlers


INT0:        ; IRQ0 Handler 
INT1:        ; IRQ1 Handler 
INT2:        ; IRQ2 Handler 
INT3:        ; IRQ3 Handler 
INT4:        ; IRQ4 Handler 
INT5:        ; IRQ5 Handler 
INT6:        ; IRQ6 Handler 
INT7:        ; IRQ7 Handler 
PCINT0:      ; PCINT0 Handler 
PCINT1:      ; PCINT1 Handler 
PCINT2:      ; PCINT2 Handler 
WD:          ; Watchdog Timeout Handler 
TIM2_COMPA:  ; Timer2 CompareA Handler 
TIM2_COMPB:  ; Timer2 CompareB Handler 
TIM2_OVF:    ; Timer2 Overflow Handler 
TIM1_CAPT:   ; Timer1 Capture Handler 
TIM1_COMPA:  ; Timer1 CompareA Handler 
TIM1_COMPB:  ; Timer1 CompareB Handler 
TIM1_COMPC:  ; Timer1 CompareC Handler 
TIM1_OVF:    ; Timer1 Overflow Handler 
TIM0_COMPA:  ; Timer0 CompareA Handler 
TIM0_COMPB:  ; Timer0 CompareB Handler 
TIM0_OVF:    ; Timer0 Overflow Handler 
SPI_STC:     ; SPI Transfer Complete Handler 
USART0_RXC:  ; USART0 RX Complete Handler 
USART0_UDRE: ; USART0,UDR Empty Handler 
USART0_TXC:  ; USART0 TX Complete Handler 
ANA_COMP:    ; Analog Comparator Handler 
ADC:         ; ADC Conversion Complete Handler 
EE_RDY:      ; EEPROM Ready Handler 
TIM3_CAPT:   ; Timer3 Capture Handler 
TIM3_COMPA:  ; Timer3 CompareA Handler 
TIM3_COMPB:  ; Timer3 CompareB Handler 
TIM3_COMPC:  ; Timer3 CompareC Handler 
TIM3_OVF:    ; Timer3 Overflow Handler 
USART1_RXC:  ; USART1 RX Complete Handler 
USART1_UDRE: ; USART1,UDR Empty Handler 
USART1_TXC:  ; USART1 TX Complete Handler 
TWI:         ; 2-wire Serial Handler 
SPM_RDY:     ; SPM Ready Handler 
TIM4_CAPT:   ; Timer4 Capture Handler 
TIM4_COMPA:  ; Timer4 CompareA Handler 
TIM4_COMPB:  ; Timer4 CompareB Handler 
TIM4_COMPC:  ; Timer4 CompareC Handler 
TIM4_OVF:    ; Timer4 Overflow Handler 
TIM5_CAPT:   ; Timer5 Capture Handler 
TIM5_COMPA:  ; Timer5 CompareA Handler 
TIM5_COMPB:  ; Timer5 CompareB Handler 
TIM5_COMPC:  ; Timer5 CompareC Handler 
TIM5_OVF:    ; Timer5 Overflow Handler 
USART2_RXC:  ; USART2 RX Complete Handler 
USART2_UDRE: ; USART2,UDR Empty Handler 
USART2_TXC:  ; USART2 TX Complete Handler 
USART3_RXC:  ; USART3 RX Complete Handler 
USART3_UDRE: ; USART3,UDR Empty Handler 
USART3_TXC:  ; USART3 TX Complete Handler

;; __________________________________________________
    reti
END:
    nop
    break
    rjmp END
