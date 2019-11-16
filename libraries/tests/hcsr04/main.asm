;; Include headers
;; The following declares some symbols and include the vector table.


.include "../../registers-inc.asm"
.include "../../vector-inc.asm"

;; Configure the HCSR04 library
;; The library needs some symbols before using it. The following defines the PB0 as the trigger pin and the PB1 as the echo one.


.set HCSR_TPORT, OPORTB
.set HCSR_TDDR,  ODDRB
.set HCSR_TNUM,  0

.set HCSR_EPIN, OPINB
.set HCSR_EDDR, ODDRB
.set HCSR_ENUM, 1

;; Start main program

;; Start the main program and initialize libraries.


.text
RESET:
    rcall USART_INIT
    rcall HCSR_INIT



;; Send something through usart to test it.


    ldi r18, 's'
    rcall USART_PUT

;; Main loop
;; Get the distance from the module and print it using the USART library.

;; Remember that ~HCSR_GET~ return the data in the X registers. Also, the ~USART_HEX~ subroutine uses the X registers as input parameters.


loop:
    rcall HCSR_GET
    rcall USART_HEX



;; Print a new line and wait some time before requesting another distance data.


    ldi r18, '\r'
    rcall USART_PUT
    ldi r18, '\n'
    rcall USART_PUT
    ldi r16, 20
    rcall WAIT

    rjmp loop

;; Include libraries
;; Include the following libraries:

;; - USART
;; - HCSR04
;;   - WAIT (HCSR04 depends on wait and the main program uses it).


.include "../../usart-lib.asm"
.include "../../hcsr04-lib.asm"
.include "../../wait-lib.asm"

;; Vector handlers for the AT368
;; No need to set other vector handlers. Simply declare them to avoid errors on the assembler compiler.

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
    reti
END:
    nop
    break
    rjmp END
