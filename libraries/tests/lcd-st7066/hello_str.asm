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

;; .include "../../vector-inc.asm"
.include "../../registers-inc.asm"

.section .rodata

.data_start:
.str_hello:
	.string "Hello World"

.str_kanas:
	.byte 0b10111010, 0b11011101, 0b11000110, 0b11000001, 0b11011100, 0b10111110, 0b10110110, 0b10110010, 0

.set data_length, 25
	
.text
RESET:
	rcall .COPY_TO_RAM
	
      rcall LCD_INIT

	ldi r16, 0b00000110
	rcall LCD_DISPLAYCONTROL
	
	ldi r16, 255
	ldi XL, lo8(.str_hello)
	ldi XH, hi8(.str_hello)
	rcall LCD_STRING

	rcall LCD_SECOND_ROW

	ldi r16, 255
	ldi XL, lo8(.str_kanas)
	ldi XH, hi8(.str_kanas)
	rcall LCD_STRING

1:
	sleep
	break
	rjmp 1b

.COPY_TO_RAM:
	push ZL
	push ZH
	push XL
	push XH
	push r17
	push r16

	ldi r17, data_length
	ldi ZL, lo8(STATIC_DATA)
	ldi ZH, hi8(STATIC_DATA)
	ldi XL, lo8(.data_start)
	ldi XH, hi8(.data_start)
	
1:
	lpm r16, Z+
	cpi r17, 0
	breq 2f
	
	dec r17
	st X+, r16
	rjmp 1b

2:
	st X+, r16

	pop r16
	pop r17
	pop XH
	pop XL
	pop ZH
	pop ZL
	ret

.include "../../lcd-st7066.asm"

STATIC_DATA:
