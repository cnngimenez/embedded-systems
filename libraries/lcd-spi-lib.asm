;; License

;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; usart-lib.asm
	   
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

;; Include headers
;; The [[file:wait-lib.org]] library is used. 


.include "wait-lib.asm"

;; Start the subroutine
;; Define the name of the subroutine and save needed registers on the stack.


.SPI_INIT:
    push r16
    ;; push r17

;; AtMega 2560

;; |-------------+-----+-----------------|
;; | ATMega Port | I/O | LCD Module Pin  |
;; |-------------+-----+-----------------|
;; | PB3         | I   | MISO / GND      |
;; | PB2         | O   | MOSI / SID / RW |
;; | PB1         | O   | SCK / E         |
;; | PB0         | O   | SS / CS / RS    |
;; |-------------+-----+-----------------|


    lds r16, DDRB

    set
    bld r16, 2 ;; PB2
    bld r16, 1 ;; PB1
    bld r16, 0 ;; PB0
    clt 
    bld r16, 3 ;; PB3

    sts DDRB, r16
    sbi OPORTB, 0 ;; PORTB0

;; SPCR - SPI Control Register 
;; This register controls almost all the settings needed for the SPI module. The following section will initialize it with the proper values.

;; The following table depicts the register's bits and their description.

;; |------+-----+------+------+------+------+------+------|
;; |    7 |   6 |    5 |    4 |    3 |    2 |    1 |    0 |
;; |------+-----+------+------+------+------+------+------|
;; | SPIE | SPE | DORD | MSTR | CPOL | CPHA | SPR1 | SPR0 |
;; |------+-----+------+------+------+------+------+------|

;; Use the R16 register to change the SPCR value.


    lds r16, SPCR

;; SPIE - Disable Interruptions
;; Disable the SPI interruptions.


    clt
    bld r16, 7 ;; SPIE

;; SPE - SPI Enable
;; Turn on the SPI.


    set
    bld r16, 6 ;; SPE

;; DORD - Data Order
;; Send the MSB first. 

;; |------+------------|
;; | DORD | Send first |
;; |------+------------|
;; |    0 | MSB Word   |
;; |    1 | LSB Word   |
;; |------+------------|


    clt
    bld r16, 5 ;; DORD

;; MSTR - Master mode
;; Set the master mode. Slave mode is the LCD.


    set
    bld r16, 4 ;; MSTR

;; CPOL - Clock Polarity
;; The Clock Polarity bit (CPOL) defines when is considered an idle state. 

;; |------+----------------------|
;; | CPOL | SCK is in Idle State |
;; |------+----------------------|
;; |    0 | Low when idle        |
;; |    1 | High when idle       |
;; |------+----------------------|

;; The IDLE should be at idle when low: CPOL = 0.


    clt
    bld r16, 3 ;; CPOL

;; CPHA - Clock Phase
;; The data is sampled on leading (first) or trailing (last) edge.

;; |------+----------------|
;; | CPHA | Data Sample on |
;; |------+----------------|
;; |    0 | Leading Edge   |
;; |    1 | Trailing Edge  |
;; |------+----------------|

;; The data sample should be at leading edge: CPHA = 0.


    clt
    bld r16, 2 ;; CPHA

;; SPR bits - Prescaler
;; The prescaler is configured according to the following formulae.

;; $$\frac{F_{osc}}{Freq} = Prescaler$$ 

;; The Arduino oscilator frequency is 16,000,000 Hz (16000Khz). The desired frequency should be between 100 and 400Khz.

;; $$\frac{16000Khz}{400Khz} \le X \le \frac{16000Khz}{100Khz}$$
;; $$40 \le X \le 160$$

;; Considering that SPI2X is zero, the possible prescaler values are.

;; |------+------+---------------|
;; | SPR1 | SPR0 | SCK Frequency |
;; |------+------+---------------|
;; |    0 |    0 | osc/4         |
;; |    0 |    1 | osc/16        |
;; |    1 |    0 | osc/64        |
;; |    1 |    1 | osc/128       |
;; |------+------+---------------|

;; Using SPR = ~0b10~ will result in $\frac{16000Khz}{64} = 250$.

;; |-------+------+------|
;; | SPI2X | SPR1 | SPR0 |
;; |-------+------+------|
;; |     0 |    1 | 0    |
;; |-------+------+------|


    set
    bld r16, 1 ;; SPR1
    clt 
    bld r16, 0 ;; SPR0

;; Store the constructed value

    sts SPCR, r16

;; SPSR - SPI Status Register
;; Only the SPI2X bit is writable. Thus, this bit is the only one to be configured.

;; Disable 2x prescaler.


    lds r16, SPSR
    clt 
    bld r16, 0 ;; SPI bit at SPSR
    sts SPSR, r16

;; Return from the Subroutine
;; Restore registers and return.


    ;; pop r17
    pop r16
    ret

;; Begin Subroutine
;; Start the subroutine and save registers.


LCD_INST:
    push r16
    push r17

;; Prepare the first byte
;; Prepare the following byte: ~11111 RW RS 0~


    lsl r17
    ori r17, 0b11111000



;; Send the first byte. Wait until the SPIF bit (in SPSR register) is one.


    sts SPDR, r17
1:
    lds r17, SPSR
    sbrs r17, 7 ;; SPIF bit at SPSR.
    rjmp 1b

;; Send the Higher Data bits
;; Prepare the following byte: ~D7-D4 0000~


    mov r17, r16
    andi r17, 0b11110000



;; Send the bits and wait for the high SPIF bit 


    sts SPDR, r17
1:
    lds r17, SPSR
    sbrs r17, 7 ;; SPIF bit at SPSR.
    rjmp 1b

;; Send the Lower Data Bits
;; Prepare the following byte: ~D3-D0 0000~


    mov r17, r16
    lsl r17
    lsl r17
    lsl r17
    lsl r17
    andi r17, 0b11110000



;; Send the bits and wait for the SPIF bit.


    sts SPDR, r17
1:
    lds r17, SPSR
    sbrs r17, 7 ;; SPIF bit at SPSR.
    rjmp 1b

;; Return
;; Return from the subroutine. Ensure the used register are restored.


    pop r17
    pop r16
    ret

;; Begin Subroutine
;; Save registers that will be used by the subroutine.

LCD_INIT:
    push r16
    push r17

;; Call the SPI Initialization
;; Ensure that the SPI has been initialized.

    rcall .SPI_INIT

;; Wait
;; Wait 40ms. 0x00ffffff is at least 16777215 cicles. A cicle cost 62.5 nanoseconds with a 16000Khz clock. 

;; $$62.5ns \cdot 16777215 cicles = 1048575937.5ns = 1048 ms$$

;; As long as R16 is 0x01, the waiting will be at least 1048ms.


    ldi r16, 0x01
    rcall WAIT

;; Send Two Function Set Commands
;; Send the first instruction. RS and RW must be 0. High data must be 0011.


    ldi r16, 0b00110000
    ldi r17, 0x00
    rcall LCD_INST



;; Wait more than 100 \mu{}s.


    ldi r16, 0x01
    rcall WAIT



;; Send the second instruction.


    ldi r16, 0b00110000
    ldi r17, 0x00
    rcall LCD_INST



;; Wait more than 35 \mu{}s.


    ldi r16, 0x01
    rcall WAIT

;; Send Display Status Command


    ldi r17, 0x00
    ldi r16, 0b00001100
    set
    bld r16, 2 ;; Display on = 1
    clt
    bld r16, 1 ;; Cursor on = 1
    bld r16, 0 ;; Blink on = 1
    rcall LCD_INST



;; Wait more than 100 \mu{}s.


    ldi r16, 0x01
    rcall WAIT

;; Send the Display Clear Command

    ldi r17, 0x00
    ldi r16, 0b00000001
    rcall LCD_INST



;; Wait 10 ms.


    ldi r16, 0x01
    rcall WAIT

;; Send the Entry Mode Command
;; This command controls the Increment and the Display Shift.


    ldi r17, 0x00
    ldi r16, 0b00000100
    set 
    bld r16, 1 ;; I/D
    clt
    bld r16, 0 ;; S
    rcall LCD_INST



;; Wait 72\mu{}s.


    ldi r16, 0x01
    rcall WAIT

;; End Subroutine
;; Restore registers and return.


    pop r17
    pop r16
    ret

;; Begin subroutine

LCD_DDRAM_ADDR:
    push r16
    push r17

;; Send the address
;; The set address command is:
;; |----+----+----+---------|
;; | RS | RW | D7 | D6-D0   |
;; |----+----+----+---------|
;; |  0 |  0 |  1 | Address |
;; |----+----+----+---------|


    ori r16, 0b10000000
    ldi r17, 0x00
    rcall LCD_INST

;; Wait 

    ldi r16, 0x01
    rcall WAIT

;; End subroutine

    pop r17
    pop r16
    ret

;; Begin subroutine


LCD_DDRAM_VAL:
    push r16
    push r17

;; Send the Data
;; Send the command following command:

;; |----+----+-------|
;; | RS | RW | D7-D0 |
;; |----+----+-------|
;; |  0 |  1 | D7-D0 |
;; |----+----+-------|


    ldi r17, 0b00000001
    rcall LCD_INST

;; Wait 

    ldi r16, 0x01
    rcall WAIT

;; End subroutine

    pop r17
    pop r16
    ret
