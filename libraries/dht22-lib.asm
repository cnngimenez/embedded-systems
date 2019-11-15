;; License

;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; dht22-lib.asm
	   
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

;; Set the pin in output mode
;; Activating the output mode on the port means:

;; - Set DDxn in 1.
;; - Use the PORTxn in 1 or 0.


_OUTPUT_MODE:
    push r16

    lds r16, DDRB
    set
    bld r16, 2 ;; PB2 output mode

    sts DDRB, r16

    pop r16
    ret

;; Set the pin in input mode

_INPUT_MODE:
    push r16

    lds r16, DDRB
    clt
    bld r16, 2 ;; PB2 output mode

    sts DDRB, r16

    pop r16
    ret

;; Send a digital one


_HIGH:
    sbi OPORTB, 2
    ret

;; Send a digital zero


_LOW:
    cbi OPORTB, 2
    ret

;; Enable the pull-up resistor globaly

_ENABLE_PULLUP:
    push r16

    lds r16, MCUCR
    clt
    bld r16, 4
    sts MCUCR, r16

    pop r16
    ret

;; Disable the pull-up resistor globaly

_DISABLE_PULLUP:
    push r16

    lds r16, MCUCR
    set
    bld r16, 4
    sts MCUCR, r16

    pop r16
    ret

;; Declare the Subroutine


DHT_START:
    push r16

;; Send the signal

;; Start the pull-up mode on the port. According to the ATmega datasheet DDB2 must be setted to zero, PORTB2 must be 1 and PUD (in MCUCR) to 0.


    rcall _ENABLE_PULLUP
    rcall _INPUT_MODE
    rcall _HIGH

    ldi r16, 1
    rcall WAITMS



;; Now, start the star sequence: 1 low and then high


    rcall _OUTPUT_MODE
    rcall _LOW

    ldi r16, 2
    rcall WAITMS

    ;; rcall _INPUT_MODE
    rcall _HIGH
    ldi r16, 25
    rcall WAITUS

;; Receives the DHT22 answer

;; Set the pin into input mode.


    rcall _INPUT_MODE
    rcall _LOW



;; The DHT22 sends a low voltage for 80\mu{}s.


1:
    lds r16, PINB
    sbrs r16, 2
    rjmp 1b



;; Then, the DHT22 sends a high voltage for 80\mu{}s.


2:
    lds r16, PINB
    sbrc r16, 2
    rjmp 2b

;; Return

    pop r16
    ret

;; Declare subroutine

_read_bit:
    push r16

;; Ignore the lower value
;; The DHT22 lower the voltage for 50\mu{}s each bit.


1:
    lds r16, PINB
    sbrs r16, 2 ;; PB2
    rjmp 1b

;; Save temporal registers

    push XL
    push XH

;; Initialize counter

    ldi XL, 0
    ldi XH, 0

;; Count the amount of cicles
;; The following snippet add one to the counter and repeat until the PINB 2nd bit is cleared.


1:
    adiw X, 1
    lds r16, PINB
    sbrc r16, 2
    rjmp 1b



;; Counting the amount of cicles is per loop is: 2 + 2 + 2 + 1 = 7. This means that each time X increments one it counts 7 cicles approx.

;; The amount of cicles is 448c for 28\mu{}s. And 448/7 = 64 loops (X = 64). However, 70\mu{}s is 1120 cicles and 1120/7 = 160 loops. A good measure is if X > 100 then it is a logic 1.


    cpi XL, 100
    brlo 2f
    ldi r20, 1
    rjmp 3f
2:
    ldi r20, 0

;; Restore used registers

3:
    pop XH
    pop XL

;; Return

5:
    pop r16
    ret

;; Declare subroutine

;; - r17 :: Store the bit index.
;; - r18 :: Store the temporal return value.


_read_byte:
    push r17
    push r18

;; Initialize variables
;; R17 stores the bit index for the r18 register.


    ldi r18, 0
    ldi r17, 0

;; Read loop


1:

;; Read a bit
;; The read bit subroutine ignores the low value. The r20 register has the return value.

;; After reading the bit, increment the index.


    rcall _read_bit
    inc r17

;; Add bit to the return value
;; First, shift left the temporal value and apply a logical or.


    lsl r18
    or r18, r20

;; Check if it is the 8th bit readed
;; Check if r17 has the 8th bit. If it is not, repeat the read-bit loop 


    cpi r17, 8
    brne 1b

;; Return
;; Prepare the return value, restore registers and return.


    mov r20, r18

    pop r18
    pop r17
    ret

;; Declare the subroutine

DHT_RECEIVE:

;; Set the input mode

    rcall _INPUT_MODE

;; Read RH integer
;; Read the first data and store it in memory.


    rcall _read_byte
    st Z, r20

;; Read RH decimal

    rcall _read_byte
    std Z+1, r20

;; Read temperature integer

    rcall _read_byte
    std Z+2, r20

;; Read temperature decimal

    rcall _read_byte
    std Z+3, r20

;; Read Checksum

    rcall _read_byte
    std Z+4, r20

;; Return 

    ret
