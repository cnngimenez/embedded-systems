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

.include "../../registers-inc.asm"
.text
RESET:
        rcall LCD_INIT
	  ldi r16, 0b00000010
        rcall LCD_FNCSET

        ldi r16, '0'
        rcall LCD_CHAR

        ldi r16, 10
        rcall LCD_DDRAM_ADDR
        ldi r16, '1'
        rcall LCD_CHAR

        ldi r16, 20
        rcall LCD_DDRAM_ADDR
        ldi r16, '2'
        rcall LCD_CHAR

        ldi r16, 30
        rcall LCD_DDRAM_ADDR
        ldi r16, '3'
        rcall LCD_CHAR

        ldi r16, 64
        rcall LCD_DDRAM_ADDR
        ldi r16, '4'
        rcall LCD_CHAR

        ldi r16, 74
        rcall LCD_DDRAM_ADDR
        ldi r16, '5'
        rcall LCD_CHAR

        ldi r16, 84
        rcall LCD_DDRAM_ADDR
        ldi r16, '6'
        rcall LCD_CHAR

        ldi r16, 94
        rcall LCD_DDRAM_ADDR
        ldi r16, '7'
        rcall LCD_CHAR

        ldi r16, 255
        rcall WAITMS
        ldi r16, 255
        rcall WAITMS
        ldi r16, 255
        rcall WAITMS
        ldi r16, 255
        rcall WAITMS

        rcall LCD_CLEAR

        rcall LCD_FIRST_ROW
        ldi r16, '1'
        rcall LCD_CHAR
        ldi r16, ' '
        rcall LCD_CHAR
        ldi r16, 'R'
        rcall LCD_CHAR
        ldi r16, 'o'
        rcall LCD_CHAR
        ldi r16, 'w'
        rcall LCD_CHAR

        rcall LCD_SECOND_ROW
        ldi r16, '2'
        rcall LCD_CHAR
        ldi r16, ' '
        rcall LCD_CHAR
        ldi r16, 'R'
        rcall LCD_CHAR
        ldi r16, 'o'
        rcall LCD_CHAR
        ldi r16, 'w'
        rcall LCD_CHAR

        rcall LCD_THIRD_ROW
        ldi r16, '3'
        rcall LCD_CHAR
        ldi r16, ' '
        rcall LCD_CHAR
        ldi r16, 'R'
        rcall LCD_CHAR
        ldi r16, 'o'
        rcall LCD_CHAR
        ldi r16, 'w'
        rcall LCD_CHAR

        rcall LCD_FOURTH_ROW
        ldi r16, '4'
        rcall LCD_CHAR
        ldi r16, ' '
        rcall LCD_CHAR
        ldi r16, 'R'
        rcall LCD_CHAR
        ldi r16, 'o'
        rcall LCD_CHAR
        ldi r16, 'w'
        rcall LCD_CHAR

1:
        sleep
        break
        rjmp 1b

.include "../../lcd-st7066-328p.asm"
