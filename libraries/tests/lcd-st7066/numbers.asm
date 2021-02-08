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
2:

	ldi r17, '0'		; r17 : char to show
	dec r17
1:
	inc r17
	mov r16, r17
	rcall LCD_CHAR

	ldi r16, 250
	rcall WAITMS
	ldi r16, 250
	rcall WAITMS

	cpi r17, '9'
	brne 1b
	rjmp 2b

.include "../../lcd-st7066-328p.asm"
