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

;; Set Text Mode

LCD_TMODE:
    push r16
    push r17

    ldi r16, 0b00110100 ;; Enable extended Inst. Set.
    ldi r17, 0x00
    rcall LCD_INST
    ldi r16, 0b00110100 ;; Enable extended Inst. Set.
    ldi r17, 0x00
    rcall LCD_INST
    ldi r16, 0b00110000 ;; Enable extended Inst. Set.
    ldi r17, 0x00
    rcall LCD_INST

    pop r17
    pop r16
    ret

;; Set Graphic Mode

LCD_GMODE:
    push r16
    push r17



;; First, set the extended instruction set.


    ldi r16, 0b00110100 ;; Enable extended Inst. Set.
    ldi r17, 0x00
    rcall LCD_INST



;; Now set the graphic command.


    ldi r16, 0b00110110 ;; Enable Graphic mode
    ldi r17, 0x00
    rcall LCD_INST

    pop r17
    pop r16
    ret

;; Define the subroutine

LCD_GDRAM_ADDR:

;; Set the graphic mode

    rcall LCD_GMODE

;; Send the vertical value
;; Always send the vertical value first. The ST7920 will be waiting for the low value.


    push r17

    ori r16, 0b10000000
    ldi r17, 0x00
    rcall LCD_INST
    
    pop r17

;; Send the horizontal value


    push r16
    push r17

    mov r16, r17
    ori r16, 0b10000000
    ldi r17, 0x00
    rcall LCD_INST

    pop r17
    pop r16

;; End Subroutine

    ret

;; Begin subroutine

LCD_GDRAM_VAL:

;; Send values

    push r17

    ;; Send high value
    ldi r17, 0x01
    rcall LCD_INST

    pop r17

    ;; Send low value
    mov r16, r17
    ldi r17, 0x01
    rcall LCD_INST

;; Return from subroutine

    ret

;; Define subroutine

LCD_COPY_GDRAM:
    push r20
    push r21
    push r22
    push r23

;; Preserve some registers
;; r16 and r17 registers will be used for parameters. Move their values to another place.

;; |--------------+-----------+----------------|
;; | New register | previous  | Desc.          |
;; |--------------+-----------+----------------|
;; | r18          | r18       | X              |
;; | r19          | r19       | Y              |
;; | r20          | r16       | Width          |
;; | r21          | r17       | Height         |
;; | r22          | r16 / r20 | Width counter  |
;; | r23          | r17 / r21 | Height counter |
;; |--------------+-----------+----------------|


    mov r20, r16
    mov r21, r17
    mov r22, r16
    mov r23, r17

;; Position the GDRAM
;; Position the GDRAM cursor.


.position:
    mov r16, r19
    mov r17, r18
    rcall LCD_GDRAM_ADDR

;; Send bytes
;; Take one byte from RAM and send it to the LCD. Repeat until width-bytes has been transmitted.


1:
    ld r16, X+
    ld r17, X+
    rcall LCD_GDRAM_VAL

    dec r22 ;; Decrement width counter
    dec r22
    cpi r22, 0x00
    brne 1b

;; Increment the vertical position
;; Decrement the height value, and increment the vertical position.

;; Restore the width counter with the total width.

;; If the height value reaches zero, then end.


    dec r23 ;; Decrement height counter
    inc r19

    mov r22, r20 ;; Restore width counter

    cpi r23, 0x00
    brne .position

;; End subroutine

    pop r23
    pop r22
    pop r21
    pop r20
    ret

;; Begin subroutine

LCD_GCLEAR:
    push r17
    push r18
    push r19
    push r20
    mov r20, r16

;; Starting Position 
;; Set the counters at the initial values.

;; - r18 :: Vertical counter.
;; - r19 :: Horizontal counter.


    ldi r16, 0x00
    ldi r17, 0x00
    ldi r18, 0x00
    ldi r19, 0x00
1:
    mov r16, r19
    mov r17, r18
    rcall LCD_GDRAM_ADDR

;; Send the bytes

;; Send the bytes.

2:
    mov r16, r20
    mov r17, r20
    rcall LCD_GDRAM_VAL



;; Decrement and check if the vertical counter is in zero.


    inc r18
    cpi r18, 16
    brne 2b



;; Decrement and check if the horizontal counter is in zero. If not, restore the vertical counter and repeat.


    inc r19
    ldi r18, 0

    cpi r19, 64
    brne 1b

;; End subroutine


    pop r20
    pop r19
    pop r18
    pop r17
    ret

;; Begin subroutine

LCD_HOME:
    push r16
    push r17

;; Send the command

    ldi r16, 0x02
    ldi r17, 0x00
    rcall LCD_INST

;; End Subroutine

    pop r17
    pop r16
    ret

;; Begin subroutine

LCD_CLEAR:
    push r16
    push r17

;; Send the command

    ldi r16, 0x01
    ldi r17, 0x00
    rcall LCD_INST

;; End Subroutine

    pop r17
    pop r16
    ret
