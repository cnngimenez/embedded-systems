;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; wait.asm
	   
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

;; Registers used:
	;; r17, r18, r19
WAIT:
	ldi r17, 0
	ldi r18, 0
	ldi r19, 0

LOOP_WAIT:
	nop
	nop
	nop
	nop
	nop

inc r17
cpi r17, 0xff
breq WAIT1_END

rjmp LOOP_WAIT

WAIT1_END:
	;; check if the high value is UPPER
	ldi r17, 0

inc r18
cpi r18, 0xff
brne LOOP_WAIT

WAIT2_END:
	ldi r18, 0

inc r19
cpi r19, 0x80
brne LOOP_WAIT

ret			; UPPER waiting limit achieved
