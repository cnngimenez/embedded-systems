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

;; Initialize USART
;; Configure the following (register/bits is shown in parenthesis): 

;; - 9600 baud rate (UBBR).
;; - enable the transmitter (UCSRB/TXEN).
;; - use the async USART mode (UCSRC/UMSEL).
;; - no parity bit (UCSRC/UPM).
;; - 1 stop bit for the transmission (UCSRC/USBS).
;; - 8 bits of character (UCSRC/UCSZ).

;; Remember this configuration because the ~minicom~ or ~stty~ will need these. Minicom have to show the ~9600 8N1~ mode.

;; Declare a label for the USART initialization. Save temporary registers.


USART_INIT:
    push r16
    push r17

;; Prepare the USART Baud Rate Register UBRR
;; Prepare the 9600bps at the USART Baud Rate Register (UBRR). According to the Atmel 328p datasheet, the UBRR value is calculated according to the following formulae: $UBRRn = \frac{f_{osc}}{16 \cdot BAUD} - 1$. The f_{osc} is the frequency of the external timer which in the Arduino UNO is 16MHz. The UBBR value is:

;; $$UBBR = \frac{f_{osc} }{16 \cdot BAUD} - 1 = \frac{16000000}{16 \cdot 9600} - 1 = 103.166666667$$


ldi r16, 0
ldi r17, 103
sts UBRR0H, r16
sts UBRR0L, r17

;; Configure UCSR B
;; The initial values are the following:

;; - RCXIEn :: 0 (RX Complete Interrupt Enable).
;; - TCXIEn :: 0 (TX Complete Interrupt Enable).
;; - UDRIEn :: 0 (USART Data Register Empty Interrupt Enable).
;; - RXENn :: 0 (Receiver Enable).
;; - TXENn :: 0 (Transmitter Enable).
;; - UCSZn2 :: 0 (Character Size).
;; - RXB8n :: 0 (Received 8th data bit).
;; - TXB8n :: 0 (Received 8th data bit).

;; The following code enables the RXEN and TXEN bits.


lds r16, UCSR0B
set
bld r16, 4       ; RXEN0 is 4th bit
bld r16, 3       ; TXEN0 is 3rd bit
sts UCSR0B, r16

;; Return from the subroutine
;; Restore register used and return from the subroutine.


pop r17
pop r16
ret

;; Send character
;; The following section describe the assembler code for sending a character to the computer. This character must be stored at the r18 register.

;; Parameters:

;; - r18 :: the character data to send.

;; Declare a label to call this subroutine.


USART_PUT:



;; Save the register to use.


push r16




;; Wait for the completion of the previous transmission.


1: 
    lds r16, UCSR0A
    sbrs r16, 5       ; bit 5 is UDRE
    rjmp 1b



;; The data is empty, store the character to send and USART will start sending.


sts UDR0, r18



;; Restore registers and return from the subroutine.


pop r16
ret

;; Send a string
;; The subroutine declared at the section [[*Send character][Send character]] will be used for sending each character.

;; Parameters:

;; - X :: 16bit address pointer to the string in SRAM to send.

;; Registers that will be used (they are saved on the stack):

;; - r18
;; - r19

;; First, declare a label to call the subroutine.


USART_SEND:



;; Save the register that are used.


push r18
push r19



;; Get one character from the X register parameter and increment 1.


1:
    ld r18, X+



;; Check if the character is zero, and if it is, return from the subroutine. The Z bit at the Status Register (SREG) is 1 when the comparison with ~cpi~ is true. ~cpi Rd, k~ applies the substraction ~Rd - k~ without saving the result but changing the Z, N, V, C and H bits at SREG accordingly. ~tst Rd~ could be used but  the result goes to the same Rd register losing the character if it is not zero.
;; The ~sbrc SREG, 1~ instruction will skip the next line if the Z bit is cleared (~Rd - k~ is not zero and thus, they are different).


cpi r18, 0      ; Z = 1 if r18 - 0 = 0
lds r19, SREG
sbrc r19, 1    ; 1 is Z bit 
rjmp 2f             ; if r18 is 0 (Z = 0) then return subroutine



;; The character is not zero, send it.


call USART_PUT



;; Do the process again.


rjmp 1b


   
;; Return part. First restore register and return.


2:
    pop r19
    pop r18
    ret

;; Send an unsigned integer
;; Cast the X 16bit unsigned integer into string and send it through USART.

;; Parameters:

;; - X registers :: The number in hex to print. Data will be lost.

;; Declare the subroutine and save "local" registers.


USART_HEX:
    push r16
    push r17
    push r18
    push r19



;; Initialize counter.


ldi r19, 0b1111



;; First, make a copy of XH and keep with the four last bits. 


1:
    mov r16, XH
    lsr r16
    lsr r16
    lsr r16
    lsr r16



;; Check if it is a number between 0x1 to 0x9.


cpi r16, 0x0a
    brlo 2f
    ;; It is a digit between 0x0a to 0x0f
    subi r16, 0x0a
    ldi r17, 65     ;; 65 is ASCII for "A"
    add r16, r17
    mov r18, r16
    rcall USART_PUT    
    rjmp 3f
2: 
    ;; It is a number between 0x01 to 0x09
    ldi r17, 48     ;; 48 is ASCII for "0"
    add r16, r17
    mov r18, r16
    rcall USART_PUT
    rjmp 3f




;; Remove the last four bits already printed in hex and check if all bits in XH are is zero. If they are, use XL as XH.


3:
    lsr r19 ;; reduce one bit from the counter

    lsl XH
    lsl XH
    lsl XH
    lsl XH

    cpi r19, 0b0000
    breq 4f  ;; r19 counter is zero, return.

    cpi r19, 0b0011
    brne 1b  ;; r19 counter is working!

    ;; counter is 0b0011: work with XL
    mov XH, XL
    rjmp 1b

4:
    ;; XL and XH is 0x00! return!
    pop r19
    pop r18
    pop r17
    pop r16
    ret
