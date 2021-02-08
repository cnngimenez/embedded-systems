;; Copyright 2021 Christian Gimenez
	   
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

.set Num, 255
.set Den, 1

.text
RESET:
	rcall LCD_INIT

	ldi r16, Num
	rcall LCD_SENDHEX
	ldi r16, '/'
	rcall LCD_CHAR
	ldi r16, Den
	rcall LCD_SENDHEX	
	ldi r16, '='
	rcall LCD_CHAR
	
	ldi r16, Num
	ldi r17, Den
	rcall DIV

	ldi r16, '('
	rcall LCD_CHAR
	mov r16, r18
	rcall LCD_SENDHEX

	ldi r16, ','
	rcall LCD_CHAR

	mov r16, r19
	rcall LCD_SENDHEX

	ldi r16, ')'
	rcall LCD_CHAR

1:
	sleep
	break
	rjmp 1b

.include "../../lcd-st7066-328p.asm"
.include "../../conversions.asm"
