;; Include needed files

.include "../libraries/vector-inc.asm"
.include "../libraries/registers-inc.asm"

;; Static data

;; This section is for read only data.


.section .rodata

;; Some data to test the USART
;; This is a "hello" that will be sendend through the USART.

;; Important: The address ~.SDhello~ assigned by GNU Assembler will depend on the linker parameters. The ~-Tdata=0x800100~ will indicate that the start of data will be at the 0x0100 address of the SRAM. Atmel 328p datasheet designates that the SRAM has registers mapped from 0x0000 to 0x00ff, so assign ~.SDhello~ must be assigned to start at 0x0100 minimum.


.SDhello:
    .string "hello "

;; Start code of the program

.text

RESET:

;; Copy the string constant to data memory
;; String constants are at the program memory (0x0000 address in the program memory is not the same as 0x0000 at the SRAM!).

;; This copy all the string into SRAM.


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

;; Initialize the USART library
;; Call the init subroutine.


call USART_INIT



;; Test for the library: 

;; Test sending a "hello". Take the pointer from the string memory and send it to the USART_SEND subroutine.


ldi XL, lo8(.SDhello)
ldi XH, hi8(.SDhello)
call USART_SEND

ldi XL, 0X23
ldi XH, 0Xaf
call USART_HEX

;; Voltage Reference Configuration

;;    The ADC requires a voltage as reference. There are three possible options:

;;    |-------+-------+---------------------------------------------------------------------|
;;    | REFS1 | REFS0 | Voltage Reference Selection                                         |
;;    |-------+-------+---------------------------------------------------------------------|
;;    |     0 |     0 | AREF, Internal Vref turned off                                      |
;;    |     0 |     1 | AVcc with external capacitor at AREF pin                            |
;;    |     1 |     0 | Reserved                                                            |
;;    |     1 |     1 | Internal 1.1V voltage reference with external capacitor at AREF pin |
;;    |-------+-------+---------------------------------------------------------------------|

;;    According to the Arduino UNO Schematic, (see Figure ref:fig:aref-capacitor)
;;    there is a 100nF capacitor connected to the AREF pin which is required to reduce the noise. If REFS is setted with any of the modes, then, there is no need to use any other capacitor.

;;    #+caption: Schematic section that shows the capacitor attached to the AREF pin. label:fig:aref-capacitor
;;    [[file:aref-capacitor.png]]

;;    Which value is best? Sensors may work with different voltages, and maybe not 1.1V. Thus, test the voltage output at the analog of the sensor and try to make a huge noise to see which is the maximum wanted. Take note of voltages for minimum and maximum and use that as input for AREF.

;;    For the sound module, the voltage is 3V when the ambient is tranquil. For this reason, a 3V or 5V in the AREF will work. Setting REFS1:0 at ~01~ for using the Arduino capacitor will work properly (tested with the MQ3 alcoholimeter and with 3.3V in AREF too!).


lds r16, ADMUX
clt
bld r16, 7      ; 7 bit is REFS1
set
bld r16, 6      ; 7 bit is REFS0
sts ADMUX, r16

;; Input Channel Configuration

;; The MUX bits configure which ADCn channel to use. ADC0 to 5 is connected in order to the AD1 to 6 of the Arduino board. Convert the binary number of these bits into decimal to know which ADCn channel is used.

;; If MUX bits are setted to 1110 or 1111 the input values will be fixed at  1.1V (V_{BG}) or 0V (GND). Useful for testing purposes. If used, remember to set the REFs bits to 1.1V reference voltage (REF1 and REF0 to values 11).

;; In this case, *the channel 2 is will be used*. MUX will be configured to 0010:


lds r16, ADMUX
clt
bld r16, 0      ; bit 0 is MUX0
set
bld r16, 1      ; bit 1 is MUX1
clt
bld r16, 2      ; MUX2
bld r16, 3	; MUX3
sts ADMUX, r16

;; Set the prescaler
;; The prescaler is the division factor between the external clock frequency and the ADC clock to the ADC. According to the Atmel 328p datasheet, the ADC clock works between 50kHz and 200kHz. The external clock at the Arduino board works 16MHz. If the external clock is replaced by another this prescalar must be reconfigured.


;; 16MHz is 16000000 cicles per seconds wich means each cicle will take 62.5 nanoseconds  ($\frac{1000000000ns}{16000000c} = \frac{1000}{16} = \frac{62.5ns}{1c}$). 200kHz is 200000 cicles per seconds which means that each ADC cicle will take 5000 nanoseconds ($\frac{1000000000ns}{200000c} = \frac{10000}{2} = 5000ns$). The diference between them is $\frac{16000000}{200000} = \frac{80}{1}$. This means that for each 80 cicles of external clock there is 1 cicle for ADC.

;; 13 ADC cicles are needed for each reading.  Then, 13 ADC cicles takes $5\mu{}s \cdot 13 = 65\mu{}s$. Also, 25 ADC cicles are needed for the first reading. Considering the same ADC cicle time, then $25 \cdot 5\mu{}s = 125\mu{}s$. 

;; The prescaler is important when asking for values continuously (when ADATE bit is enabled). The sample reading and holding value is done between the first cicle rising edge and the second cicle fall edge after the prescaling ends. The rest of the cicles are used for decoding the value into a digital number. The next value is retrieved again at the end of the next prescaler cicle meaning that each reading value iteration is controlled by the external clock.


;; The prescaler value must be 2, 4, 8, 16, 32, 64 or 128. Considering that 80 cicles from the external clock is needed for retrieving one cicle, it means that *a 128 value is needed* (1 prescaled cicle per 128 external clock cicles). $128 - 80 = 48$ cicles will not be used by any task referred to the ADC.

;; According to the Atmel 328p datasheet, ADPS2:0 must have the value 111 for a prescaler value of 128.


lds r16, ADCSRA
set
bld r16, 2       ; ADPS2
bld r16, 1       ; ADPS1
bld r16, 0       ; ADPS0
sts ADCSRA, r16

;; Set the auto trigger
;; To read values continuously, the auto trigger must be enabled.


lds r16, ADCSRA
set
bld r16, 5       ; 5th bit is ADATE
sts ADCSRA, r16

;; Reading loop

;; Declare a label for reapeating the loop and initialize registers that will store the data. 


MAIN_LOOP:
  ldi r17, 0



;; Enable the ADC and start a conversion.


lds r16, ADCSRA
set
bld r16, 7
bld r16, 6       ; 6th bit is ADSC
sts ADCSRA, r16



;; Wait until an ADC value is ready.


1:
  lds r16, ADCSRA
  sbrs r16, 4       ; 4th bit is ADIF
  rjmp 1b



;; Read the value from the ADC. The order is important because the ADC data registers blocks once it start reading the ADCL. This is in case of a new reading interrupt happens after reading ADCL. If there is no blocking mechanism, when reading the ADCH it is not possible to ensure if it corresponds to the ADCL readed.

;; The register X is used as parameter for the USART_HEX subroutine at the USART library. 


lds XL, ADCL
lds XH, ADCH



;; Now, send the value as character through USART serial protocol.


ldi r18, 10       ;; 13 is line feed in ASCII
call USART_PUT
ldi r18, 13       ;; 13 is carriage return in ASCII
call USART_PUT
call USART_HEX



;; A wait call, so the program won't saturate the user's reading.


ldi r16, 0x30
rcall WAIT



;; Repeat the loop.


rjmp MAIN_LOOP

;; Include needed libraries

;; Include the USART library.


.include "../libraries/usart-lib.asm"



;; Include the wait library which imports a command for waiting.


.include "../libraries/wait-lib.asm"

;; Vector Table


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



;; Reference to the static data. The assembler store them at the end.


STATIC_DATA:
