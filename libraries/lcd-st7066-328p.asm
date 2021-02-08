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
.include "wait-lib.asm"
.LCD_INSTREADY:
        push r16
        push r17

        sbi OPORTB, 3 ; E
	
        ldi r16, 1
        rcall WAITMS
	
        cbi OPORTB, 3 ; E

        rcall WAITMS

        pop r17
        pop r16
        ret
.LCD_SEND4BITS:
        push r17
        push r16

        andi r16, 0b00001111    ; keep the useful data and center it
        lsl r16
        lsl r16
        
        lds r17, PORTD		; Retain the other bits value, just modify the center one.
        andi r17, 0b11000011
        or r17, r16
        out OPORTD, r16
	
        rcall .LCD_INSTREADY

        pop r16
        pop r17
        ret
.SET_OUTPUTPORTMODE:
        sbi ODDRD, 2
        sbi ODDRD, 3
        sbi ODDRD, 4
        sbi ODDRD, 5    

        sbi ODDRB, 4 ; RS
        sbi ODDRB, 3 ; E
        sbi ODDRB, 2 ; RW
        ret
.BLANK_PORTS:
        cbi OPORTD, 2
        cbi OPORTD, 3
        cbi OPORTD, 4
        cbi OPORTD, 5

        cbi OPORTB, 4
        cbi OPORTB, 3
        cbi OPORTB, 2
        ret
.macro clear_rs
        cbi OPORTB, 4           ; RS
.endm
.macro clear_rw
        cbi OPORTB, 2           ; RW	
.endm
.macro set_rs
        sbi OPORTB, 4		; RS
.endm
.macro set_rw
        sbi OPORTB, 2		; RW
.endm

LCD_INIT:
        push r16
        push r17
        rcall .SET_OUTPUTPORTMODE
        rcall .BLANK_PORTS
        ldi r16, 0x40
        rcall WAITMS
        ldi r16, 0b00000011 	; 0b0011
        rcall .LCD_SEND4BITS

        ldi r16, 5
        rcall WAITMS
        ldi r16,0b00000011 	; 0b0011
        rcall .LCD_SEND4BITS

        ldi r16, 1
        rcall WAITMS

	      ldi r16,0b00001100	; 0b0011
        rcall .LCD_SEND4BITS
        ldi r16,0b00000010	; 0b0010
        rcall .LCD_SEND4BITS
        ldi r16, 0b00101100 ; N F
        rcall LCD_INST
        ldi r16, 0b00001111
        rcall LCD_INST
        rcall LCD_CLEAR 
        ldi r16, 0b00000110
        rcall LCD_INST	

        pop r17
        pop r16
        ret
LCD_SENDDATA:
        push r18
        push r16

        mov r18, r16
        andi r16, 0b11110000	
        lsr r16
        lsr r16
        lsr r16
        lsr r16
        rcall .LCD_SEND4BITS

        mov r16, r18
        andi r16, 0b00001111
        rcall .LCD_SEND4BITS

        pop r16
        pop r18
        ret
LCD_INST:
        clear_rs
        clear_rw

        rcall LCD_SENDDATA

        ret
LCD_CLEAR:
        push r16
	
        ldi r16, 0b00000001
        rcall LCD_INST

        ldi r16, 10
        rcall WAITMS

        pop r16
        ret
LCD_HOME:
        push r16

        ldi r16, 0b00000010
        rcall LCD_INST

        pop r16
        ret
LCD_ENTRYMODE:
        push r16

        andi r16, 0b00000011	; Clean the unused bits
        ori r16, 0b00000100
        rcall LCD_INST
	
        pop r16
        ret
LCD_DISPLAYCONTROL:
        push r16

        andi r16, 0b00000111	; Clean the unused bits
        ori r16, 0b00001000
        rcall LCD_INST
	
        pop r16
        ret
LCD_CDMOVE:
        push r16

        andi r16, 0b00000011	; Clean the unused bits
        lsl r16
        lsl r16
        ori r16, 0b00010000
        rcall LCD_INST
	
        pop r16
        ret
LCD_FNCSET:
        push r16

        andi r16, 0b00000011	; Clean the unused bits
        lsl r16
        lsl r16
        ori r16, 0b00100000
        rcall LCD_INST

        pop r16
        ret
LCD_CGRAM_ADDR:
        push r16

        andi r16, 0b00111111	; Clean the unused bits
        ori r16, 0b01000000
        rcall LCD_INST
	
        pop r16
        ret
LCD_DDRAM_ADDR:
        push r16
	
        ori r16, 0b10000000
        rcall LCD_INST

        pop r16
        ret
LCD_CHAR:
        set_rs
        clear_rw

        rcall LCD_SENDDATA

        clear_rs
        ret
LCD_FIRST_ROW:
        rcall LCD_HOME
        ret
LCD_SECOND_ROW:
        push r16

        ldi r16, 64
        rcall LCD_DDRAM_ADDR

        pop r16
        ret
LCD_THIRD_ROW:
        push r16

        ldi r16, 20
        rcall LCD_DDRAM_ADDR

        pop r16
        ret
LCD_FOURTH_ROW:
        push r16

        ldi r16, 84
        rcall LCD_DDRAM_ADDR

        pop r16
        ret
LCD_STRING:
        push XL
        push XH
        push r16
        push r17

        mov r17, r16
1:
        ld r16, X+
        cpi r16, 0
        breq 2f			; if r16 = 0 then end subroutine

        rcall LCD_CHAR		; if r16 /= 0 then send char

        cpi r17,0
        breq 1b			; r17 is zero, no need to wait
        mov r16, r17
        rcall WAITMS
	
        rjmp 1b

2:
        pop r17
        pop r16
        pop XH
        pop XL
        ret
LCD_SENDHEX:
        push r16
        push r18
        push r17

        mov r18, r16
        lsr r16
        lsr r16
        lsr r16
        lsr r16

        cpi r16, 10
        brlo 1f
        ;; r16 is greater or equal than 10
        subi r16, 10
        ldi r17, 'A'
        add r16, r17
        rjmp 2f
1:
        ;; r16 is lower than 10
        ldi r17, '0'
        add r16, r17
2:
        rcall LCD_CHAR
        mov r16, r18
        andi r16, 0b00001111

        cpi r16, 10
        brlo 1f
        ;; r16 is greater or equal than 10
        subi r16, 10
        ldi r17, 'A'
        add r16, r17
        rjmp 2f
1:
        ;; r16 is lower than 10
        ldi r17, '0'
        add r16, r17
2:
        rcall LCD_CHAR

        pop r17
        pop r18
        pop r16
        ret
