;; License

;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; hcsr04-lib.asm
	   
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

;; Declare the subroutine
;; Declare the subroutine.

HCSR_INIT:

;; Set the port modes
;; Set the target pin as output and the echo as input.


    sbi HCSR_TDDR, HCSR_TNUM
    cbi HCSR_EDDR, HCSR_ENUM

;; Return

    ret

;; Declare subroutine 


HCSR_GET:
    ldi XL, 0
    ldi XH, 0

;; Send the trigger signal
;; Send 10 \mu{}s a high value to trigger the sound.


    sbi HCSR_TPORT, HCSR_TNUM
    ldi r16, 8 ;; wait 8 us at least
    rcall WAITUS



;; Now, stop the trigger signal.


    cbi HCSR_TPORT, HCSR_TNUM

;; Ignore the low echo value
;; While the trigger activates and send the 8 sonic burst, the echo sends low values. 

;; Read the pin register. If the bit is not high, repeat.


1:
    sbis HCSR_EPIN, HCSR_ENUM
    rjmp 1b

;; Count time from the echo 
;; Count the time when the echo time is up. The X 16 bit registers is used in order to count more than 255 microseconds. 

;; First, add 1 to the X registers. Then, wait for one microsecond. Finally, check the echo value if it is low and repeat if it is not.


1:
    adiw X, 1
    rcall _oneus
    sbic HCSR_EPIN, HCSR_ENUM
    rjmp 1b

;; Wait for one microsecond
;; An Arduino cicle has 62.5ns (using a clock 16Mhz). Then, to execute 16 cicles (16 no-op instructions) needs 1000ns to complete. 

;; The following code declare an internal label and use 16 nop instructions to wait for 1000ns (1 microsecond), then simply return. It is easy to count rather than using a loop and considering such a limited amount of instructions.


_oneus:
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        ret

;; Declare subroutine

HCSR_CALC:
