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

;; Include basic files
;; Include interruption vectors and add the register names.


.include "../libraries/vector-atmega2560-inc.asm"
.include "../libraries/registers-atmega2560-inc.asm"



;; Start the program section.


.text

;; Initialization

RESET:

;; Configure LED Pin for Output 
;; The L led will be used for displaying when the ATmega is not sleeping. 


    sbi ODDRB, 7

;; Configure an input pin
;; This set the input mode on PIN PB0 (pin 53 in Arduino Mega or pin PWM 8 in Arduino UNO).


    cbi ODDRB, 0

;; Initialize USART
;; Call the initialization procedure. 


    rcall USART_INIT

;; Sleep mode
;; Set the Extended Standby sleep mode. SM2:0 bits must be at 111.


    ldi r16, 0b00001110
    sts SMCR, r16

;; Pin Change Interrupt Control Register - PCICR 
;; Enable all interruptions. Specially, the PCIE0 bit which corresponds to the PB0/PCINT0 pin. Basically, activate the PCMSKn group of bits.


    ldi r16, 0b00000001
    sts PCICR, r16

;; Pin Change Mask Register 0 - PCMSK0
;; This select the pins that can trigger an interruption. PCICR first bit must be 1. 

;; This affects PCINT7:0 pins. Only the PB0/PCINT0 pin is needed to be activated.


    ldi r16, 0b00000001
    sts PCMSK0, r16

;; Send a signal
;; To test that the board is initializing, send a signal.

;; Turn on the L led and turn it off.


    sbi OPORTB, 7
    ldi r16, 0x05
    rcall WAIT
    cbi OPORTB, 7
    ldi r16, 0x05
    rcall WAIT
    sbi OPORTB, 7
    ldi r16, 0x05
    rcall WAIT



;; Send a hello.


    ldi r18, 'H'
    rcall USART_PUT
    rcall WAIT

;; Sleep Loop
;; Declare the label to return to.


MAIN_LOOP:



;; Send an "S" to the USART and turn on the L led.


    ldi r18, 's'
    rcall USART_PUT
    ldi r16, 0x05
    rcall WAIT
    sbi OPORTB, 7



;; Enable interruptions.


    sei



;; Send the sleep command to the AVR.


    lds r18, SMCR
    set
    bld r18, 0
    sts SMCR, r18

    sleep



;; When returning from sleeping disable sleep mode, disable interruptions and  notify the user. Turn off the L led and send a "W" using the USART protocol.


    lds r18, SMCR
    clt 
    bld r18, 0
    sts SMCR, r18

    cli

    ldi r18, 'w'
    rcall USART_PUT
    ldi r16, 0x05
    rcall WAIT

    cbi OPORTB, 7



;; Check if the PINB0 was the reason.


    sbrc r20, 0
    rjmp 1f
    ldi r18, '0'
    rcall USART_PUT
1:




;; Wait a little.


    ldi r16, 0x05
    rcall WAIT



;; Return to the main loop.


    rjmp MAIN_LOOP

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
    set
    bld r20, 0
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

;; Include libraries
;; Include the USART library. It is explained at [[file:../libraries/usart-lib.org][USART lib page]].


.include "../libraries/usart-lib.asm"



;; Include a wait subroutine. See the [[file:../libraries/wait-lib.org][Wait library page]] for more information.


.include "../libraries/wait-lib.asm"
