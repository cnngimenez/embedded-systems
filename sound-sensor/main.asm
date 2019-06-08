.include "../libraries/vector-inc.asm"
.include "../libraries/registers-inc.asm"

.section .rodata

.SDhello:
    .string "hello "

.text

RESET:

ldi ZL, lo8(STATIC_DATA)
  ldi ZH, hi8(STATIC_DATA)
  
  ldi XL, lo8(.SDhello)
  ldi XH, hi8(.SDhello)

1:
  lpm r16, Z+       ; get program data
  cpi r16, 0x0
  breq CONT_PROGRAM       ; r16 has zero! end string copy

  st X+, r16       ; store at SRAM
  rjmp 1b       ; next

CONT_PROGRAM: 
  st X+, r16   ; store the zero char

call USART_INIT

ldi XL, lo8(.SDhello)
ldi XH, hi8(.SDhello)
call USART_SEND

ldi XL, 0X23
ldi XH, 0Xaf
call USART_HEX

lds r16, ADMUX
clt
bld r16, 7      ; 7 bit is REFS1
set
bld r16, 6      ; 7 bit is REFS0
sts ADMUX, r16

lds r16, ADMUX
clt
bld r16, 0      ; bit 0 is MUX0
set
bld r16, 1      ; bit 1 is MUX1
clt
bld r16, 2      ; MUX2
bld r16, 3	; MUX3
sts ADMUX, r16

lds r16, ADCSRA
set
bld r16, 2       ; ADPS2
bld r16, 1       ; ADPS1
bld r16, 0       ; ADPS0
sts ADCSRA, r16

lds r16, ADCSRA
set
bld r16, 5       ; 5th bit is ADATE
sts ADCSRA, r16

MAIN_LOOP:
  ldi r17, 0

lds r16, ADCSRA
set
bld r16, 7
bld r16, 6       ; 6th bit is ADSC
sts ADCSRA, r16

1:
  lds r16, ADCSRA
  sbrs r16, 4       ; 4th bit is ADIF
  rjmp 1b

lds XL, ADCL
lds XH, ADCH

ldi r18, 10       ;; 13 is line feed in ASCII
call USART_PUT
ldi r18, 13       ;; 13 is carriage return in ASCII
call USART_PUT
call USART_HEX

ldi r16, 0x30
rcall WAIT

rjmp MAIN_LOOP

.include "../libraries/usart-lib.asm"

.include "../libraries/wait-lib.asm"

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
    ;; break
    sleep
    rjmp END

STATIC_DATA:
